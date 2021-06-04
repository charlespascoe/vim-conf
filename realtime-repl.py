import subprocess
import re

def run_code(src, dst):
    py = subprocess.Popen(['bash', '-c', 'python3 -qui - 2>&1'], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    for line in vim.buffers[src]:
        py.stdin.write((line + "\n").encode('utf-8'))

    py.stdin.close()
    py.wait()
    output = py.stdout.read().decode('utf-8')

    r = re.compile(r'\.\.\.|>>>')

    results = [line.strip().split('\n')[-1] for line in r.split(output)[1:-1]]

    vim.buffers[dst][:] = results


node = None

def init_node():
    global node
    node = subprocess.Popen(['node', '-i'], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

def run_js_code(src, dst):
    global node

    lines = [line for line in vim.buffers[src]]

    for line in lines:
        node.stdin.write((line + "\n").encode('utf-8'))

    node.stdin.close()
    node.wait()
    output = node.stdout.read().decode('utf-8')

    r = re.compile(r'\n?> |\.\.\.')

    results = [' '.join(l.strip() for l in line.split('\n')) for line in r.split(output)[1:-1]]

    for i in range(min(len(results), len(lines))):
        if lines[i].startswith('//'):
            results[i] = lines[i]

    vim.buffers[dst][:] = results

    node = subprocess.Popen(['node', '-i'], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
