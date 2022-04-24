#!/usr/bin/env python3

import argparse
import json
import subprocess
import sys
from html.parser import HTMLParser

import requests

WORDHUNT_URL = "https://wooordhunt.ru/word/{}"


class WordParser(HTMLParser):
    def __init__(self):
        super().__init__()

        self.translations = []
        self.collocations = []
        self.extended = {}

        self.accepted = False
        self.in_h4 = False
        self.h4_title = ""
        self.in_div = False
        self.in_i = False
        self.in_lvl = 0
        self.last_lvl = 0
        self.in_block = False

    def handle_starttag(self, tag, attrs):
        if tag == "div":
            # parse basic translation options
            for name, value in attrs:
                if name == "class" and value == "t_inline_en":
                    self.accepted = True
            # parse collocations
            for name, value in attrs:
                if name == "class" and value == "block phrases":
                    self.in_block = True
                    self.collocations.append("")
            # parse examples of one type of translation
            if self.in_h4:
                if self.in_div:
                    self.in_lvl += 1
                else:
                    for name, value in attrs:
                        if name == "class" and value == "tr":
                            self.in_div = True
        # parse type of extended translations (verb, noun, adj, ...)
        elif tag == "h4":
            self.in_h4 = True
        # parse small notes
        elif tag == "i" and self.in_h4:
            self.in_i = True
        elif tag == "br":
            # newlines in translations
            if self.in_h4:
                self.extended[self.h4_title][-1] = \
                    self.extended[self.h4_title][-1].strip()
                self.extended[self.h4_title].append("")
            # newlines in collocations
            elif self.in_block:
                self.collocations[-1] = self.collocations[-1].strip()
                self.collocations.append("")
        # remove "snoska" in translations
        elif tag == "p" and self.in_block:
            for name, value in attrs:
                if name == "class" and value == "snoska":
                    if len(self.collocations[-1].strip()) == 0:
                        self.collocations.pop()
                    self.in_block = False

    def handle_endtag(self, tag):
        if tag == "div":
            if self.in_div:
                if self.in_lvl > 0:
                    self.in_lvl -= 1
                else:
                    if self.extended[self.h4_title][-1] == "":
                        self.extended[self.h4_title].pop()
                    self.h4_title = ""
                    self.in_h4 = False
                    self.in_div = False
                    self.last_lvl = 0
                    # not checking in_lvl cause it should be 0 now
            elif self.in_block:
                if len(self.collocations[-1].strip()) == 0:
                    self.collocations.pop()
                self.in_block = False

    def handle_data(self, data):
        # get simple translation
        if self.accepted:
            self.accepted = False
            self.translations.append(data)
        # catch header extended examples
        elif self.in_h4 and self.h4_title == "":
            self.h4_title = data.strip()
            self.extended[self.h4_title] = []
        # get one example (extended)
        elif self.in_div:
            data = data.replace('\u2002', ' ')
            # add brackets for <i> elements
            if self.in_i:
                self.in_i = False
                previous = self.extended[self.h4_title][-1]
                stripped_data = data.strip()
                # put <i></i> in '()'
                if previous == "- " and stripped_data[0] != "(" and stripped_data[-1] != ")":
                    data = "(" + stripped_data + ") "
                # concatenate several <i>...</i> tags in '()'
                elif previous.endswith(") ") and stripped_data[0] != "(" and stripped_data[-1] != ")":
                    self.extended[self.h4_title][-1] = previous[:-2]
                    data = " " + stripped_data + ") "
            # add new example (no empty or useless rows) ["if" left intentionally]
            if data != "" and data[0:3] != "ещё":
                # check depth level of tags in <div>
                if len(self.extended[self.h4_title]) > 0:
                    self.extended[self.h4_title][-1] += data
                else:
                    self.extended[self.h4_title].append(data)
            self.last_lvl = self.in_lvl
        # get collocation
        elif self.in_block:
            data = data.replace('\u2002', ' ')

            if data != "":
                self.collocations[-1] += data


def init_argparse():
    argparser = argparse.ArgumentParser(description="translate words from english to russian")
    argparser.add_argument("-e", "--extended", action="store_true", help="show extended translations")
    argparser.add_argument("-c", "--collocations", action="store_true", help="show collocations")

    outputgroup = argparser.add_mutually_exclusive_group(required=False)
    outputgroup.add_argument("-n", "--notify", action="store_true", help="use libnotify to show translation")
    outputgroup.add_argument("-j", "--json", action="store_true", help="show output in json")

    inputgroup = argparser.add_mutually_exclusive_group(required=True)
    inputgroup.add_argument("-s", "--selection", action="store_true", help="use xsel to get unknown word")
    inputgroup.add_argument("-d", "--dmenu", action="store_true", help="use dmenu to input unknown word")
    inputgroup.add_argument("-w", "--word", type=str, help="word to translate")
    inputgroup.add_argument("-i", "--input", action="store_true", help="reads word for translate from stdin")

    return vars(argparser.parse_args())


def get_word(args):
    if args.get("selection"):
        unknown_word = subprocess.check_output("xsel -o", shell=True).decode("utf-8")

        if not unknown_word or unknown_word == '\n':
            unknown_word = subprocess.check_output("xsel -b -o", shell=True).decode("utf-8")
    elif args.get("dmenu"):
        try:
            unknown_word = subprocess.check_output(
                "dmenu -i -p 'Enter word to translate' <&-", shell=True)[:-1].decode("utf-8")
        except subprocess.CalledProcessError:
            sys.exit()
    elif args.get("input"):
        unknown_word = input().strip()
    else:
        unknown_word = args.get("word")

    return unknown_word.strip()


def get_translation_from_extended(extended):
    key = next(iter(extended))
    translation = extended[key][0]
    return translation.lstrip('- ')


def send_notification(args, header, content):
    if args.get("notify"):
        command = ["notify-send", "-u", "normal", "-t", "5000", header, content]
    else:
        command = ["echo", header, content]
    subprocess.call(command)


def print_error(args, unknown_word):
    if args.get("json"):
        error = {"word": unknown_word, "error": "no result"}
        error_json = json.dumps(error, ensure_ascii=False, indent=2)
        print(error_json)
    else:
        send_notification(args, unknown_word, "no result")


def print_result(args, unknown_word, parser):
    if parser.translations:
        translation = parser.translations[0]
    elif parser.extended:
        translation = get_translation_from_extended(parser.extended)
    elif parser.collocations:
        translation = parser.collocations[0]
    else:
        raise RuntimeError("failed to acquire translation from parsed data")

    if args.get("json"):
        info = {"word": unknown_word, "translate": translation}
        if args.get("extended"):
            info["extended"] = parser.extended
        if args.get("collocations"):
            info["collocations"] = parser.collocations

        json_info = json.dumps(info, ensure_ascii=False, indent=2)
        print(json_info)
    else:
        info = [translation]
        if args.get("extended"):
            ext = '\n'.join([k + ":\n" + '\n'.join(v) for k, v in parser.extended.items()])
            info.append(ext)
        if args.get("collocations"):
            colls = '\n'.join(parser.collocations)
            info.append(colls)

        send_notification(args, unknown_word, '\n'.join(info))


def main():
    args = init_argparse()
    unknown_word = get_word(args)

    if not unknown_word:
        send_notification(args, "translate.py", "empty input")
        sys.exit(1)

    response = requests.get(WORDHUNT_URL.format(unknown_word))
    parser = WordParser()
    parser.feed(response.content.decode("utf-8"))

    if parser.translations or parser.extended or parser.collocations:
        print_result(args, unknown_word, parser)
        sys.exit(0)
    else:
        print_error(args, unknown_word)
        sys.exit(1)


if __name__ == "__main__":
    main()
