import os
from os import path

# :config-write-py --defaults --force config.def.py

config.load_autoconfig(False)

# cyrillic layout workaround
config.unbind('.')
en_keys = "qwertyuiop[]asdfghjkl;'zxcvbnm,./"+'QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>?'
ru_keys = 'йцукенгшщзхъфывапролджэячсмитьбю.'+'ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ,'
c.bindings.key_mappings.update(dict(zip(ru_keys, en_keys)))

# SETTINGS
c.changelog_after_upgrade = 'never'
c.colors.tabs.bar.bg = '#333333'
c.colors.webpage.bg = 'black'
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.page = 'always'
c.colors.webpage.darkmode.policy.images = 'smart'
c.colors.webpage.preferred_color_scheme = 'dark'
c.completion.cmd_history_max_items = 0
c.completion.height = '30%'
c.completion.open_categories = ['searchengines']
c.completion.web_history.exclude = ['*']
c.completion.web_history.max_items = 0
c.confirm_quit = ['downloads']
c.content.autoplay = False
c.content.cookies.store = False
c.content.javascript.clipboard = 'ask'
c.content.notifications.enabled = False
c.content.pdfjs = True
c.content.prefers_reduced_motion = True
c.content.private_browsing = True
c.messages.timeout = 1500
c.qt.workarounds.disable_hangouts_extension = True
c.scrolling.bar = 'when-searching'
c.scrolling.smooth = True
c.statusbar.show = 'always'
c.url.default_page = 'about:blank'
c.url.start_pages = ['about:blank']
c.window.transparent = True
c.zoom.default = '110%'

# TABS
c.tabs.background = True
c.tabs.position = 'right'
c.tabs.title.alignment = 'right'
c.tabs.width = 250
c.tabs.last_close = 'close'
c.tabs.show = 'never'
c.tabs.background = True
config.bind('B', 'config-cycle tabs.show always never')
config.bind('<Ctrl-Tab>', 'tab-next')
config.bind('<Ctrl-Shift-Tab>', 'tab-prev')
config.bind('<Ctrl-H>', 'tab-move -')
config.bind('<Ctrl-L>', 'tab-move +')

# SEARCH ENGINES
c.url.searchengines = {
    'DEFAULT': 'https://www.google.com/search?&q={}',
    'dd': 'https://duckduckgo.com/?q={}',
    'gg': 'https://www.google.com/search?&q={}',
    'ya': 'https://yandex.com/search/?text={}',
    'rt': 'https://rutracker.org/forum/search_cse.php?q={}',
    'yt': 'https://youtube.com/search?q={}',
    'ym': 'https://music.yandex.ru/search?text={}',
    'gs': 'https://github.com/search?q={}',
    'gh': 'https://github.com/{}',
    'er': 'https://translate.google.com/#en/ru/{}',
    're': 'https://translate.google.com/#ru/en/{}',
    'ef': 'https://translate.google.com/#en/fr/{}',
    'fe': 'https://translate.google.com/#fr/en/{}',
    'rf': 'https://translate.google.com/#fr/ru/{}',
    'fr': 'https://translate.google.com/#ru/fr/{}',
}

# FONT
c.fonts.default_family = ['monospace']
c.fonts.default_size = '12pt'

# AD/HOST BLOCKS
c.content.blocking.enabled = True
c.content.blocking.adblock.lists = ['https://easylist.to/easylist/easylist.txt', 'https://easylist.to/easylist/easyprivacy.txt']
c.content.blocking.hosts.lists = ['https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts']
c.content.blocking.method = 'both'
c.content.blocking.hosts.block_subdomains = True

# THEME
theme_path = path.expandvars("$XDG_DATA_HOME/qutebrowser/styles/global-dark.css")
config.bind('cs', f'config-cycle content.user_stylesheets [{theme_path}] [] ;; reload')

# BINDS
config.bind('xa', 'spawn setsid tsp ytloader.sh -f a {url}') # eng
config.bind('xv', 'spawn setsid tsp ytloader.sh -u -d downloads {url}') # eng
config.bind('xo', 'spawn linkhandler {url}')
config.bind('xe', 'edit-url')
config.bind('zq', 'quit')
config.bind('a', 'config-cycle statusbar.show always in-mode')
config.bind('A', 'config-cycle scrolling.bar when-searching overlay')
config.bind('xd', 'config-cycle colors.webpage.darkmode.enabled')
config.bind('ys', 'yank selection')
config.bind('cD', 'download-cancel')
config.unbind('ad')

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
