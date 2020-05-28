import os
import os.path
from os import path

# SETTINGS
c.completion.open_categories = ['searchengines']
c.completion.height = '30%'
c.content.cookies.store = False
c.content.dns_prefetch = True
c.content.fullscreen.window = True
c.content.pdfjs = True
c.content.private_browsing = True
c.zoom.default = '125%'
c.url.default_page = 'about:blank'
c.url.start_pages = ['about:blank']

# SETTINGS I'M NOT SURE ABOUT
c.content.plugins = True
c.content.print_element_backgrounds = False
# c.qt.highdpi = False

# TABS
c.tabs.position = 'right'
c.tabs.title.alignment = 'right'
c.tabs.width = 250
c.tabs.last_close = 'close'
c.tabs.show = 'switching'
c.tabs.show_switching_delay = 800
config.bind(',t', 'config-cycle tabs.show always switching')
config.bind('<Ctrl-Tab>', 'tab-next')
config.bind('<Alt-Tab>', 'tab-prev')

# SEARCH ENGINES
c.url.searchengines = {
        'DEFAULT': 'https://www.google.com/search?&q={}',
        'dd': 'https://duckduckgo.com/?q={}',
        'gg': 'https://www.google.com/search?&q={}',
        'rt': 'http://rutracker.org/forum/search_cse.php?q={}',
        'yt': 'https://youtube.com/search?q={}',
        'ym': 'https://music.yandex.ru/search?text={}',
        'gs': 'https://github.com/search?q={}',
        'gh': 'https://github.com/{}',
        'er': 'https://translate.google.com/#en/ru/{}',
        're': 'https://translate.google.com/#ru/en/{}',
}

# FONT
font_size = 12
# maybe use default_family instead of monospace
c.fonts.completion.category = f'bold {font_size}pt monospace'
c.fonts.completion.entry = f'{font_size}pt monospace'
c.fonts.debug_console = f'{font_size}pt monospace'
c.fonts.downloads = f'{font_size}pt monospace'
c.fonts.hints = f'bold {font_size}pt monospace'
c.fonts.keyhint = f'{font_size}pt monospace'
c.fonts.messages.error = f'{font_size}pt monospace'
c.fonts.messages.info = f'{font_size}pt monospace'
c.fonts.messages.warning = f'{font_size}pt monospace'
c.fonts.prompts = f'{font_size}pt sans-serif'
c.fonts.statusbar = f'{font_size}pt monospace'
c.fonts.tabs = f'{font_size}pt monospace'

# COLORS
c.colors.webpage.bg = 'darkslategray'
c.colors.webpage.prefers_color_scheme_dark = True
c.colors.statusbar.private.bg = "darkslategray"
c.colors.statusbar.command.private.bg = "darkslategray"
# Set colors I want to change by command
parameters = [
    'colors.completion.odd.bg',
    'colors.completion.even.bg',
    'colors.completion.fg',
    'colors.statusbar.command.private.bg',
    'colors.statusbar.command.private.fg',
]
# Set new values for the colors
invertions = ['#DEB887', 'white', 'black', 'white', 'black']
invert_colors = dict(zip(parameters, invertions))
# Remember default values for colors
default_colors = {}
for parameter in parameters:
    value = getattr(c, parameter, 'red')
    if not isinstance(value, str):
        value = value[0]
    default_colors[parameter] = value
# Generate QB's command for changing colors
def set_colors(colors):
    return " ;; ".join(
        [f"set {command} {value}" for command, value in colors.items()])

# THEME
theme_path = path.expandvars("$XDG_DATA_HOME/qutebrowser/styles/all-sites.css")
c.content.user_stylesheets = [theme_path]
config.bind(',s', f'config-cycle content.user_stylesheets {theme_path} "" ;; reload')

# HACKS
closecmd = "spawn --userscript closequte"
config.bind('<Ctrl-Q>', closecmd)
config.bind('ZQ', closecmd)
config.bind('zq', closecmd)

# BINDINGS
config.bind('ci', set_colors(invert_colors))
config.bind('cs', set_colors(default_colors))
config.bind('xa', 'spawn ytloader -f a {url}')
config.bind('xv', 'spawn ytloader {url}')
config.bind('xh', 'spawn linkhandler {url}')
config.bind('xe', 'edit-url')

# EDITOR
terminal = os.getenv('TERMINAL', 'st')
editor = os.getenv("EDITOR", 'nvim')
c.editor.command = [terminal, '-c', 'dropdown', '-e', editor, '{}']

# COMMANDS
c.aliases = {
    # common
    'w': 'session-save',
    'q': closecmd,
    'Q': closecmd,
    'wq': 'quit --save',
    'tm': 'tab-move',
    'tg': 'tab-give',
    # tor
    'tor': 'set content.proxy socks://localhost:9050/',
    'sys': 'set content.proxy system',
    # javascript
    'jse': 'set content.javascript.enabled true',
    'jsd': 'set content.javascript.enabled false',
}

# HOST BLOCKING
c.content.host_blocking.lists = [
    'https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts',
]
hosts = path.expandvars('file://$XDG_DATA_HOME/qutebrowser/hosts')
if path.exists(hosts):
    c.content.host_blocking.lists.append(hosts)
