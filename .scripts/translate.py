#!/usr/bin/env python3
import subprocess
from html.parser import HTMLParser
import os
import sys

import argparse
import requests

WRDHUNT = 'https://wooordhunt.ru/word/{}'


argparser = argparse.ArgumentParser(description='Translate words from english to russian')
argparser.add_argument('-n', '--notify', action='store_true', help='Uses libnotify to show translation')
arggroup = argparser.add_mutually_exclusive_group(required=True)
arggroup.add_argument('-s', '--selection', action='store_true', help='Uses xsel to get unknown word')
arggroup.add_argument('-d', '--dmenu', action='store_true', help='Uses dmenu to input unknown word')
arggroup.add_argument('-a', '--argument', type=str, help='Word to translate. Passes as argument')
arggroup.add_argument('-w', '--word', action='store_true', help='Word to translate reads from stdin')
args = vars(argparser.parse_args())

if args.get('notify'):
    MESSAGE = 'notify-send -u normal -t 5000 "{}" "{}"'
else:
    MESSAGE = 'printf "{}\n{}\n"'


class WrdParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.result = []
        self.accepted = False

    def handle_starttag(self, tag, attrs):
        if tag != 'span':
            return
        for name, value in attrs:
            if name == 'class' and value == 't_inline_en':
                self.accepted = True

    def handle_data(self, data):
        if self.accepted:
            self.accepted = False
            self.result.append(data)


if args.get('selection'):
    unknown_word = subprocess.check_output("xsel -o", shell=True).decode("utf-8")
    if not unknown_word or unknown_word == '\n':
        unknown_word = subprocess.check_output("xsel -b -o", shell=True).decode("utf-8")
elif args.get('dmenu'):
    unknown_word = subprocess.check_output('dmenu -i -p "Enter word to translate" <&-', shell=True)[:-1].decode("utf-8")
elif args.get('word'):
    unknown_word = input().strip()
else:
    unknown_word = args.get('argument')

if not unknown_word or unknown_word == '\n':
    os.system(MESSAGE.format("Translation", "No input"))
    exit(1)

response = requests.get(WRDHUNT.format(unknown_word))
parser = WrdParser()
parser.feed(response.content.decode("utf-8"))

if len(parser.result) < 1:
    os.system(MESSAGE.format(unknown_word, "No result"))
    exit(1)
else:
    os.system(MESSAGE.format(unknown_word, parser.result[0]))
    exit(0)
