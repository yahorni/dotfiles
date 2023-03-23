import atexit
import os
import readline


def save(prev_h_len, history_file):
    new_h_len = readline.get_current_history_length()
    # readline.set_history_length(1000)
    readline.append_history_file(new_h_len - prev_h_len, history_file)


def main():
    hist_file = os.path.expandvars("$XDG_DATA_HOME/python.hist")
    hist_len = 0

    try:
        readline.read_history_file(hist_file)
        hist_len = readline.get_current_history_length()
    except FileNotFoundError:
        with open(hist_file, 'wb'):
            pass

    atexit.register(save, hist_len, hist_file)


main()
