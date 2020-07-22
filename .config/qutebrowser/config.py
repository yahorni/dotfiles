import os
from os import path

# SETTINGS
c.colors.tabs.bar.bg = '#333333'
c.colors.webpage.bg = 'black'
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.page = 'always'
c.colors.webpage.prefers_color_scheme_dark = True
c.completion.cmd_history_max_items = 0
c.completion.height = '30%'
c.completion.open_categories = ['searchengines']
c.completion.web_history.exclude = ['*']
c.completion.web_history.max_items = 0
c.confirm_quit = ['downloads']
c.content.autoplay = False
c.content.cookies.store = False
c.content.pdfjs = True
c.input.mouse.rocker_gestures = True
c.scrolling.bar = 'when-searching'
c.statusbar.show = 'in-mode'
c.url.default_page = 'about:blank'
c.url.start_pages = ['about:blank']
c.zoom.default = '150%'

# TABS
c.tabs.background = True
c.tabs.position = 'right'
c.tabs.title.alignment = 'right'
c.tabs.width = 250
c.tabs.last_close = 'close'
c.tabs.show = 'never'
config.bind('B', 'config-cycle tabs.show always never')
config.bind('И', 'config-cycle tabs.show always never') # rus
config.bind('<Ctrl-Tab>', 'tab-next')
config.bind('<Alt-Tab>', 'tab-prev')

# SEARCH ENGINES
c.url.searchengines = {
    'DEFAULT': 'https://www.google.com/search?&q={}',
    'dd': 'https://duckduckgo.com/?q={}',
    'gg': 'https://www.google.com/search?&q={}',
    'rt': 'https://rutracker.org/forum/search_cse.php?q={}',
    'yt': 'https://youtube.com/search?q={}',
    'ym': 'https://music.yandex.ru/search?text={}',
    'gs': 'https://github.com/search?q={}',
    'gh': 'https://github.com/{}',
    'er': 'https://translate.google.com/#en/ru/{}',
    're': 'https://translate.google.com/#ru/en/{}',
}

# FONT
c.fonts.default_family = ['monospace']
c.fonts.default_size = '12pt'

# THEME
theme_path = path.expandvars("$XDG_DATA_HOME/qutebrowser/styles/global-dark.css")
config.bind('cs', f'config-cycle content.user_stylesheets [{theme_path}] [] ;; reload')
config.bind('сы', f'config-cycle content.user_stylesheets [{theme_path}] [] ;; reload')

# BINDS
config.bind('xa', 'spawn ytloader -f a {url}')
config.bind('чф', 'spawn ytloader -f a {url}') # rus
config.bind('xv', 'spawn ytloader {url}')
config.bind('чм', 'spawn ytloader {url}')      # rus
config.bind('xo', 'spawn linkhandler {url}')
config.bind('чщ', 'spawn linkhandler {url}')   # rus
config.bind('xe', 'edit-url')
config.bind('zq', 'quit')
config.bind('яй', 'quit') # rus
config.bind('A', 'config-cycle statusbar.show always in-mode')
config.bind('Ф', 'config-cycle statusbar.show always in-mode') # rus

# RUSSIAN LAYOUT BINDS
config.bind('П', 'scroll-to-perc')          # G
config.bind('Р', 'back')                    # H
config.bind('О', 'tab-next')                # J
config.bind('Л', 'tab-prev')                # K
config.bind('Д', 'forward')                 # L
config.bind('Т', 'search-prev')             # N
config.bind('Щ', 'set-cmd-text -s :open -t')# O
config.bind('ЗЗ', 'open -t -- {primary}')   # PP
config.bind('Зз', 'open -t -- {clipboard}') # Pp
config.bind('К', 'reload -f')               # R
config.bind('ЯЙ', 'quit')                   # ZQ
config.bind('фв', 'download-cancel')        # ad
config.bind('св', 'download-clear')         # cd
config.bind('в', 'tab-close')               # d
config.bind('пп', 'scroll-to-perc 0')       # gg
config.bind('ш', 'enter-mode insert')       # i
config.bind('р', 'scroll left')             # h
config.bind('о', 'scroll down')             # j
config.bind('л', 'scroll up')               # k
config.bind('д', 'scroll right')            # l
config.bind('т', 'search-next')             # n
config.bind('щ', 'set-cmd-text -s :open')   # o
config.bind('зЗ', 'open -- {primary}')      # pP
config.bind('зз', 'open -- {clipboard}')    # pp
config.bind('к', 'reload')                  # r
config.bind('г', 'undo')                    # u
config.bind('м', 'enter-mode caret')        # v
config.bind('нв', 'yank domain')            # yd
config.bind('нз', 'yank pretty-url')        # yp
config.bind('не', 'yank title')             # yt
config.bind('нн', 'yank')                   # yy

# EDITOR
term = os.getenv('TERMINAL', 'st')
term_args = [term, '-c', 'dropdown', '-e']
editor = os.getenv("EDITOR", 'nvim')
if editor == "vim" or editor == "nvim":
    editor_args = [editor, "-u", "/dev/null", "{}"]
else:
    editor_args = [editor, "{}"]
c.editor.command = term_args + editor_args

# COMMANDS
c.aliases = {
    # common
    'q': 'quit',
    'Q': 'quit',
    'wq': 'quit --save',
    # tabs
    'tm': 'tab-move',
    'tg': 'tab-give',
    # tor
    'tor': 'set content.proxy socks://localhost:9050/',
    'sys': 'set content.proxy system',
}

# HOST BLOCKING
c.content.host_blocking.lists = [
    'https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts',
]
hosts = path.expandvars('$XDG_DATA_HOME/qutebrowser/hosts')
if path.exists(hosts):
    c.content.host_blocking.lists.append('file://' + hosts)
