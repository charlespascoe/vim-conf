import vim
import tempfile
import webbrowser
import re


def export_html(bullets, firstline, lastline):
    if not vim.current.buffer.name.endswith('.bn'):
        raise Exception('Not a Bulletnotes file')

    doc = bulletnotes.parse_doc(vim.current.buffer[firstline-1:lastline], bullets)

    doc_formatter = bulletnotes.html.DocumentFormatter.default()
    doc_formatter.section_formatter.append_br_to_paragraphs = True

    html = doc_formatter.to_full_html(doc)

    with tempfile.NamedTemporaryFile(mode='w',delete=False,encoding='utf8',suffix='.html') as f:
        f.write(html)
        path = f.name

    webbrowser.open_new('file://' + path)

    print('Exported to temporary file: ' + path)


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
