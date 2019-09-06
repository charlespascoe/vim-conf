import urllib3
import json
import os
import vim


class Config:
    def __init__(self, loaded):
        if type(loaded) is not dict:
            raise Exception('config must be an object')

        if 'taskConverter' not in loaded:
            raise Exception('config.taskConverter missing')

        self.task_converter = ServiceConfig('taskConverter', loaded['taskConverter'])

        if 'skvs' not in loaded:
            raise Exception('config.skvs missing')

        self.skvs = ServiceConfig('skvs', loaded['skvs'])

        if 'pushcuts' not in loaded:
            raise Exception('config.pushcuts missing')

        self.pushcuts = ServiceConfig('pushcuts', loaded['pushcuts'])


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


def bulletnote_to_taskpaper(bulletnote_text):
    payload = {
        'from': 'bulletnotes',
        'to': 'taskpaper',
        'input': bulletnote_text,
    }

    result = req(
        'POST',
        config.task_converter.host + '/api/convert',
        config.task_converter.api_key,
        payload
    )

    if type(result) is not dict:
        raise Exception('Expected a dictionary response, but got %s' % type(result))

    if type(result['ok']) is not bool:
        raise Exception('Expected "ok" to be a bool, but got %s' % type(result['ok']))

    if not result['ok']:
        if 'error' not in result or type(result['error']) is not str:
            raise Exception('An unknown error occurred')
        else:
            raise Exception('Error: ' + result['error'])

    return result['output']


def upload_to_skvs(text):
    payload = {
        'value': text
    }

    result = req(
        'POST',
        config.skvs.host + '/api/entries',
        config.skvs.api_key,
        payload
    )

    return result['id']


def send_push_notification(push_id, text, content):
    url = '%s/%s/notifications/%s' % (
        config.pushcuts.host,
        config.pushcuts.api_key,
        push_id
    )

    payload = {
        'text': text,
        'input': content
    }

    req(
        'POST',
        url,
        json_body = payload
    )


def export_tasks():
    if not vim.current.buffer.name.endswith('.bn'):
        raise Exception('Not a Bulletnotes file')

    bulletnote_text = '\n'.join(vim.current.buffer[:])

    taskpaper = bulletnote_to_taskpaper(bulletnote_text)

    proj = vim.eval('exists("g:bn_proj_name") ? g:bn_proj_name : ""')

    skvs_payload = json.dumps({
        'proj': proj,
        'taskpaper': taskpaper
    })

    taskpaper_key = upload_to_skvs(skvs_payload)

    send_push_notification('Tasks', 'Import to %s' % (proj or 'Inbox'), taskpaper_key)


def check_project_exists():
    proj = vim.eval('exists("g:bn_proj_name") ? g:bn_proj_name : ""')

    if proj == '':
        raise Exception('No project set')

    send_push_notification('CheckProject', 'Check "%s" exists' % proj, proj)
