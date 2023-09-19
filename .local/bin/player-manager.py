#!/usr/bin/env python3

import sys

from gi.repository import GLib
import gi

gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl


def print_event(player_name, status):
    print(f"{player_name.lower()}: {status.lower()}")
    try:
        with open("/tmp/dwmbar.fifo", "a") as f:
            f.write("player 0\n")
    except BrokenPipeError as ex:
        print("caught BrokenPipeError", file=sys.stderr)


def on_event(player, status, manager):
    print_event(player.props.player_name, status.value_nick)


def on_player_appeared(manager, player):
    print_event(player.props.player_name, "appeared")


def on_player_vanished(manager, player):
    print_event(player.props.player_name, "vanished")


def on_metadata(player, metadata, manager):
    keys = metadata.keys()
    if "xesam:title" in keys:
        if "xesam:artist" in keys and metadata['xesam:artist'][0]:
            msg = f"{metadata['xesam:artist'][0]} - {metadata['xesam:title']}"
        else:
            msg = f"{metadata['xesam:title']}"
    else:
        msg = "metadata"

    print_event(player.props.player_name, msg)


def init_player(name, manager):
    if name.name not in ['spotifyd', 'mpd', 'mpv', 'firefox', 'chromium']:
        return

    player = Playerctl.Player.new_from_name(name)
    player.connect('playback-status::playing', on_event, manager)
    player.connect('playback-status::paused', on_event, manager)
    player.connect('playback-status::stopped', on_event, manager)
    player.connect('metadata', on_metadata, manager)
    manager.manage_player(player)

    print_event(name.name, "initiated")


def on_name_appeared(manager, name):
    init_player(name, manager)


manager = Playerctl.PlayerManager()
manager.connect('name-appeared', on_name_appeared)
manager.connect('player-appeared', on_player_appeared)
manager.connect('player-vanished', on_player_vanished)

for name in manager.props.player_names:
    init_player(name, manager)


main = GLib.MainLoop()
main._quit_by_sigint = True
main.run()
