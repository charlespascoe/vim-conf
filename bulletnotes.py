import vim
import tempfile
import webbrowser


def export_html(bullets):
    if not vim.current.buffer.name.endswith('.bn'):
        raise Exception('Not a Bulletnotes file')

    doc = bulletnotes.parse_doc(vim.current.buffer, bullets)

    doc_formatter = bulletnotes.html.DocumentFormatter.default()
    doc_formatter.section_formatter.append_br_to_paragraphs = True

    html = doc_formatter.to_full_html(doc)

    with tempfile.NamedTemporaryFile(mode='w',delete=False,encoding='utf8',suffix='.html') as f:
        f.write(html)
        path = f.name

    webbrowser.open_new('file://' + path)

    print('Exported to temporary file: ' + path)
