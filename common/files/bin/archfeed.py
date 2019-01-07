import feedparser
import sys
import threading
import time

from html.parser import HTMLParser


feed = {}
def get_feed():
    feed['feed'] = feedparser.parse('https://www.archlinux.org/feeds/news/')


t = threading.Thread(target=get_feed)
t.daemon = True
t.start()
for _ in range(30):
    if 'feed' in feed:
        d = feed['feed']
        break
    time.sleep(0.1)
else:
    print('ERROR: Timed out getting feed')
    sys.exit(1)

if not d['entries']:
    print('ERROR: No entries found in feed!')
    sys.exit(1)
first_item = d['entries'][0]


class Escapes:
    RESET_ALL = '\033[0m'
    RESET_BOLD = '\033[21m'
    RESET_COLOR = '\033[39m'
    RESET_UNDERLINED = '\033[24m'
    BOLD = '\033[1m'
    UNDERLINED = '\033[4m'
    RED = '\033[31m'
    BLUE = '\033[34m'
    DARK_GREY = '\033[90m'


class BashHTMLParser(HTMLParser):

    CURRENT_URL = "<invalid url>"
    INVALID_URL = "<invalid url>"

    START_MAP = {
        "a": " " + Escapes.UNDERLINED,
        "code": " " + Escapes.DARK_GREY,
        "li": "• ",
        "p": "",
        "pre": "",
        "strong": Escapes.BOLD,
        "ul": "",
    }
    END_MAP = {
        "a": Escapes.RESET_UNDERLINED + " ",
        "code": Escapes.RESET_COLOR + " ",
        "li": "",
        "p": "\n",
        "pre": "",
        "strong": Escapes.RESET_BOLD,
        "ul": "",
    }

    def handle_starttag(self, tag, attrs):
        print(self.START_MAP[tag], end="")
        if tag == "a":
            self.CURRENT_URL = dict(attrs)["href"]

    def handle_endtag(self, tag):
        print(self.END_MAP[tag], end="")
        if tag == "a":
            print(f"[ {self.CURRENT_URL} ] ", end="")

    def handle_data(self, data):
        print(data.strip(), end="")


parser = BashHTMLParser()


def print_entry(entry):
    print(Escapes.RED + ' • ' + Escapes.RESET_ALL + Escapes.BOLD + Escapes.UNDERLINED + entry['title'] + Escapes.RESET_ALL)
    try:
        parser.feed(entry['description'])
    except:
        print(Escapes.RESET_ALL)
        raise
    print(Escapes.RESET_ALL)


entries = d["entries"][:int(sys.argv[1])] if len(sys.argv) > 1 else d["entries"]

print(Escapes.BLUE + Escapes.BOLD + Escapes.UNDERLINED + d['feed']['title'] + Escapes.RESET_ALL + "\n")
for entry in entries:
    print_entry(entry)
