import vim
import tempfile
import webbrowser
import random
import re
import subprocess
import os


def bullets_to_char_set(bullets):
    return ''.join('\\' + bullet for bullet in bullets)


def isempty(s):
    return s == '' or s.isspace()


anchor_charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'


def gen_anchor_id(length):
    return ''.join(random.choice(anchor_charset) for i in range(length))


def export_html(bullets, firstline, lastline):
    if not vim.current.buffer.name.endswith('.bn'):
        raise Exception('Not a Bulletnotes file')

    doc = bulletnotes.parse_doc(vim.current.buffer[firstline-1:lastline], bullets)

    doc_formatter = bulletnotes.html.DocumentFormatter.default()

    html = doc_formatter.to_full_html(doc)

    with tempfile.NamedTemporaryFile(mode='w',delete=False,encoding='utf8',suffix='.html') as f:
        f.write(html)
        path = f.name

    webbrowser.open_new('file://' + path)

    print('Exported to temporary file: ' + path)

def export_to_clipboard(bullets, firstline, lastline):
    if not vim.current.buffer.name.endswith('.bn'):
        raise Exception('Not a Bulletnotes file')

    doc = bulletnotes.parse_doc(vim.current.buffer[firstline-1:lastline], bullets)

    doc_formatter = bulletnotes.html.DocumentFormatter.default()

    html = doc_formatter.to_full_html(doc)

    # macOS only
    p = subprocess.Popen(
        ['textutil', '-format', 'html', '-convert', 'rtf', '-stdin', '-stdout'],
        stdout=subprocess.PIPE,
        stdin=subprocess.PIPE,
    )

    p.stdin.write(html.encode('utf-8'))
    p.stdin.close()

    rtf = p.stdout.read()
    p.wait()

    with os.popen('pbcopy -Prefer rtf', 'w') as copy:
        copy.write(rtf.decode('utf-8'))


def word_count(bullets, firstline, lastline):
    if not vim.current.buffer.name.endswith('.bn'):
        raise Exception('Not a Bulletnotes file')

    doc = bulletnotes.parse_doc(vim.current.buffer[firstline-1:lastline], bullets)

    whitespace = re.compile(r'\s+')
    nonaphanum = re.compile('[^a-z0-9\s]', re.I)

    # TODO: Also count text

    total = 0

    note_bullets = (b for b in doc.walk() if isinstance(b, bulletnotes.Bullet) and b.bullet_type == '-')

    for bullet in note_bullets:
        total += len(whitespace.split(nonaphanum.sub('', bullet.content)))

    return total


def find_bullet(lines, start_line, bullet_types):
    bullet_regexp = re.compile('^((\\s{4})*)([' + bullets_to_char_set(bullet_types) + ']) ')
    indent_match = bullet_regexp.match(lines[start_line])

    if not indent_match:
        return None

    indent = indent_match.group(1)
    indent_level = len(indent) // 4

    pos = start_line + 1

    while pos < len(lines):
        line = lines[pos]

        is_continuation = (
            # Line must not be empty (only contiguous text)
            not isempty(line) and
            # Indent must be at least the indent of the bullet
            line.startswith(indent) and
            # Line must not be a new subbullet
            not bullet_regexp.match(line)
        )

        if is_continuation:
            pos += 1
        else:
            break

    return {
        'startline': start_line,
        'endline': pos - 1,
        'indent': indent_level,
    }


def find_bullet_and_children(lines, start_line, bullet_types):
    bullet = find_bullet(lines, start_line, bullet_types)

    if bullet is None:
        return None

    end = bullet['endline']
    lnum = end + 1

    while lnum < len(lines):
        line = lines[lnum]

        if line.strip() == '':
            # Intermediate whitespace is fine
            lnum += 1
            continue

        b = find_bullet(lines, lnum, bullet_types)

        if b is None or b['indent'] <= bullet['indent']:
            # Found non-bullet text or a bullet of the same or less indentation;
            # therefore no more children
            break

        # Best end found so far
        end = b['endline']
        lnum = end + 1

    bullet['endline'] = end

    return bullet
