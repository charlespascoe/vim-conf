import re
import vim
import os

symbols = set()

# TODO: Make language-independent (currently Go only)

symbol_re = re.compile(r'^([A-Za-z0-9_.-]+)\t')

field_tag_re = re.compile(r'`(?:json|yaml):"([^"]+)"')

gin_url_re = re.compile(r'\.(?:GET|POST|PUT|DELETE)\("([^"]+)"')

_cur_line = ""

# TODO: Try using Inspect: https://golang.org/pkg/go/ast/#example_Inspect
# (Keep universal ctags so that it can work with other languages
def gen_tags():
    # os.system('find . -name "*.go" | gotags -L - -f tags')
    os.system('find . -name "*.go" | ctags -L - > tags')

def load_tags():
    global symbols

    symbols = set()

    symbols.add('json')
    symbols.add('yaml')

    with open('tags', 'r') as tags:
        for line in tags:
            if line.startswith('!'):
                continue

            match = symbol_re.match(line)

            if match:
                symbols.add(match.group(1))

                for part in match.group(1).split('.'):
                    symbols.add(part)

def add_word(word):
    vim.command(f'silent spellgood! {word}')

def check_spelling():
    global _cur_line

    add_word('func')

    for line in vim.current.buffer:
        _cur_line = line

        tag_match = field_tag_re.search(_cur_line)

        if tag_match:
            for part in tag_match.group(1).split(','):
                add_word(part)

        url_match = gin_url_re.search(_cur_line)

        if url_match:
            prev_cur_line = _cur_line

            _cur_line = url_match.group(1)

            while True:
                badword, errtype = vim.eval('spellbadword(py3eval("_cur_line"))')

                if not badword:
                    break

                add_word(badword)
                _cur_line = _cur_line.replace(badword, '')

            _cur_line = prev_cur_line

        while True:
            badword, errtype = vim.eval('spellbadword(py3eval("_cur_line"))')

            if not badword:
                break

            if badword in symbols or (badword.endswith('s') and badword[:-1] in symbols):
                add_word(badword)

            _cur_line = _cur_line.replace(badword, '')
