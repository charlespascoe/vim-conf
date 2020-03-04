import urllib3
import json
import os
import vim
import tempfile
import webbrowser


class Config:
    def __init__(self, loaded):
        if type(loaded) is not dict:
            raise Exception('config must be an object')

        if 'todoist' not in loaded:
            raise Exception('config.todoist missing')

        self.todoist = ServiceConfig('config.todoist', loaded['todoist'])


class ServiceConfig:
    def __init__(self, path, loaded):
        if type(loaded) is not dict:
            raise Exception('%s must be an object' % path)

        if 'host' not in loaded:
            raise Exception('%s.host missing' % path)

        if type(loaded['host']) is not str:
            raise Exception('%s.host must be a string' % path)

        self.host = loaded['host']

        if 'apiKey' not in loaded:
            raise Exception('%s.apiKey missing' % path)

        if type(loaded['apiKey']) is not str:
            raise Exception('%s.apiKey must be a string' % path)

        self.api_key = loaded['apiKey']


http = urllib3.PoolManager()


config_path = os.path.expanduser('~/.bulletnotesrc')


with open(config_path, encoding='utf-8') as f:
    config = Config(json.loads(f.read()))


def req(method, url, api_key=None, json_body=None):
    headers = {}

    if api_key is not None:
        headers['Authorization'] = 'Bearer %s' % api_key

    if json_body is None:
        res = http.request(
            method,
            url,
            headers=headers
        )
    else:
        headers['Content-Type'] = 'application/json; charset=utf-8'

        body = json.dumps(json_body).encode('utf-8')

        res = http.request(
            method,
            url,
            headers=headers,
            body=body
        )

    if res.status < 200 or res.status > 299:
        raise Exception('%s %s failed: %s' % (method, url, res.status))

    content_type = res.getheader('content-type', '').strip()

    if not content_type.startswith('application/json'):
        raise Exception('Expected application/json response, got %s' % content_type)

    # Should probably check content-encoding or similar

    parsed_content = json.loads(res.data.decode('utf-8'))

    return parsed_content


def bullet_to_new_task(bullet):
    d = {
        'content': bullet.content
    }

    if len(bullet.subbullets) > 0:
        d['comment'] = '\n'.join(str(b) for b in bullet.subbullets)

    return d


def export_tasks(bullets):
    if not vim.current.buffer.name.endswith('.bn'):
        raise Exception('Not a Bulletnotes file')

    try:
        with open('.bn_proj_id') as f:
            str_id = f.read()

        proj_id = int(str_id)
    except Exception as ex:
        raise Exception('No Project ID found')

    doc = bulletnotes.parse_doc(vim.current.buffer, bullets)

    new_tasks = [
        bullet_to_new_task(bullet)
        for bullet in doc.walk()
        if bullet.bullet_type == '*'
    ]

    req(
        'POST',
        f'{config.todoist.host}/api/projects/{proj_id}/tasks',
        config.todoist.api_key,
        new_tasks
    )


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
