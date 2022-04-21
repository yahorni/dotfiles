#!/usr/bin/env python3

import configparser
import json
import logging
import os
import os.path
import random
from dataclasses import dataclass
from typing import Optional

import genanki

CONFIG_FILENAME = "ankinote.ini"


def get_random_id():
    return random.randrange(1 << 30, 1 << 31)


@dataclass
class WordInfo:
    word: str
    translate: str
    extended: dict[str, list[str]]
    collocations: list[str]


class AnkiData:
    def __init__(self, config, profile):
        self.model_id = config.getint(profile, "model_id", fallback=get_random_id())
        self.deck_id = config.getint(profile, "deck_id", fallback=get_random_id())

        self.model_name = config.get(profile, "model_name", fallback="default_model")
        self.deck_file = config.get(profile, "deck_file", fallback="anki_deck.apkg")
        self.deck_description = config.get(profile, "description", fallback="")

        self.with_forvo_link = config.getboolean(profile, "forvo", fallback=False)

        self.model = self.__generate_model()
        self.deck = self.__generate_deck()

    def __generate_model(self):
        if self.with_forvo_link:
            forvo_section = "<hr id='sound'><h3>Произношение:</h3>" \
                + "<a href=\"https://forvo.com/search/{{word}}/en/\">FORVO</a>"

        return genanki.Model(
            self.model_id,
            self.model_name,
            fields=[
                {"name": "word"},
                {"name": "translate"},
                {"name": "extended"},
                {"name": "collocations"},
            ],
            templates=[
                {
                    "name": "{{word}}",
                    "qfmt": "<h1>{{word}}</h1>",
                    "afmt": "{{FrontSide}}<hr id='answer'><h3>Перевод:</h3>{{translate}}"
                    + "<hr id='extended'><h3>Примеры:</h3>{{extended}}"
                    + "<hr id='collocations'><h3>Словосочетания:</h3>{{collocations}}"
                    + (forvo_section if self.with_forvo_link else "")
                },
            ])

    def __generate_deck(self):
        return genanki.Deck(self.deck_id, self.deck_description)

    @staticmethod
    def __prepare_extended(extended: dict[str, list[str]]) -> str:
        extended_html = ""
        for part, examples in extended.items():
            extended_html += f"<h4>{part}</h4>"
            first_subsection = True
            for ex in examples:
                if ex.startswith("- "):
                    if not first_subsection:
                        extended_html += "</ul>"
                    else:
                        first_subsection = False
                    extended_html += ex + "<ul>"
                else:
                    extended_html += f"<li>{ex}</li>"
            extended_html += "</ul>"
        return extended_html

    @staticmethod
    def __prepare_collocations(collocations: list[str]) -> str:
        collocation_html = "<ul>"
        for coll in collocations:
            collocation_html += f"<li>{coll}</li>"
        collocation_html += "</ul>"
        return collocation_html

    def add_note(self, new_info: WordInfo):
        note = genanki.Note(model=self.model,
                            fields=[new_info.word,
                                    new_info.translate,
                                    self.__prepare_extended(new_info.extended),
                                    self.__prepare_collocations(new_info.collocations)])
        self.deck.add_note(note)

    def export_deck(self):
        genanki.Package(self.deck).write_to_file(self.deck_file)
        logging.info(f"package '{self.deck_file}' is exported")


class WordLoader:
    def __init__(self, config, profile):
        self.directory = config.get(profile, "directory", fallback="words")
        self.words = []

    def read_words(self) -> bool:
        try:
            self.words = [os.path.splitext(name)[0] for name in os.listdir(self.directory)]
            logging.info(f"loaded {len(self.words)} words")
            return True
        except FileNotFoundError as ex:
            logging.error(f"can't read words from directory '{self.directory}': {ex}")
        return False

    def parse_word(self, word: str) -> Optional[WordInfo]:
        filename = os.path.join(self.directory, word + ".json")
        try:
            with open(filename, "r", encoding="utf-8") as word_file:
                word_obj = json.load(word_file)
                if "error" in word_obj:
                    logging.warning(f"skipping '{word}'")
                    return None

                return WordInfo(word_obj["word"],
                                word_obj["translate"],
                                word_obj["extended"],
                                word_obj["collocations"])
        except FileNotFoundError as ex:
            logging.error(f"can't parse '{word}': {ex}")
        except json.decoder.JSONDecodeError as ex:
            logging.error(f"can't parse '{word}': {ex}")
        return None

    def get_words(self) -> list[str]:
        return self.words


def read_config() -> (configparser.ConfigParser, str):
    config = configparser.ConfigParser()
    profile = ""

    config.read(CONFIG_FILENAME)
    if "default" not in config:
        logging.warning("config not found")
        return config, profile

    if "profile" not in config["default"]:
        logging.warning("'profile' not found in config")
        return config, profile

    profile = config["default"]["profile"]
    if profile not in config:
        logging.warning(f"profile '{profile}' not found in config")

    return config, profile


def main():
    logging.basicConfig(format="[%(levelname)s] %(message)s", level=logging.INFO)

    config, profile = read_config()
    word_loader = WordLoader(config, profile)
    if not word_loader.read_words():
        return

    anki_data = AnkiData(config, profile)
    for word in word_loader.get_words():
        word_info = word_loader.parse_word(word)
        if word_info:
            anki_data.add_note(word_info)
    anki_data.export_deck()


if __name__ == "__main__":
    main()
