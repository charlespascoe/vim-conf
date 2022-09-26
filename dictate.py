import sys
import re
import random
import PySide6
import threading
import os
import subprocess
import time
from socketserver import UnixStreamServer, StreamRequestHandler, ThreadingMixIn
from PySide6 import QtCore, QtWidgets, QtGui

socket_path = '/tmp/dictation'

try:
    os.unlink(socket_path)
except OSError:
    if os.path.exists(socket_path):
        raise

subscribers = []

substitutions = []

def load_subtitutions():
    global substitutions
    substitutions = []

    # TODO: Escapes (e.g. \/)
    pattern_re = re.compile(r'^/([^/]+)/([^/]+)/$')

    with open('dictation_substitutions') as f:
        print('Loading substitutions from file')

        for line in f:
            line = line.strip()

            match = pattern_re.match(line)

            if match:
                print(line)
                sub_from, sub_to = match[1], match[2]
                substitutions.append((re.compile(sub_from), sub_to))


load_subtitutions()

def replace_substitutions(s):
    global substitutions

    for sub_from, sub_to in substitutions:
        s = sub_from.sub(sub_to, s)

    s = s.replace('\n', '\\n')

    return s


class Handler(StreamRequestHandler):
    def handle(self):
        # TODO: Locking
        if self.request not in subscribers:
            subscribers.append(self.request)

        for data in self.rfile:
            line = data.decode('utf-8').strip()

            print('> ' + line)

            if line == 'start-dictation':
                start_dictation()

            if line == 'reload':
                load_subtitutions()


        print("Disconnected")


auto_start_dictation = False

def start_dictation():
    global auto_start_dictation
    auto_start_dictation = True
    script = f'tell application "System Events" to set frontmost of every process whose unix id is {os.getpid()} to true'
    subprocess.check_call(['/usr/bin/osascript', '-e', script])


def on_focus(next_fun):
    def f(*args):
        global auto_start_dictation
        next_fun(*args)
        if auto_start_dictation:
            auto_start_dictation = False
            subprocess.check_call(['/usr/bin/osascript', '-e', 'tell application "System Events" to keystroke "d" using command down'])

    return f


def return_to_vim():
    subprocess.check_call(['/usr/bin/osascript', '-e', 'tell application "Alacritty" to activate'])


class ThreadedUnixStreamServer(ThreadingMixIn, UnixStreamServer):
    pass


def run_unix_server():
    with ThreadedUnixStreamServer(socket_path, Handler) as server:
        server.serve_forever()


def broadcast(output):
    output = replace_substitutions(output) + '\n'

    sys.stdout.write(output)
    sys.stdout.flush()

    for request in subscribers:
        if not request._closed:
            request.send(output.encode())
    # TODO: remove disconnected sockets

class MyWidget(QtWidgets.QWidget):
    def __init__(self):
        super().__init__()

        # self.input = QtWidgets.QLineEdit()
        self.input = QtWidgets.QPlainTextEdit()

        self.layout = QtWidgets.QVBoxLayout(self)
        self.layout.setContentsMargins(0,0,0,0)
        self.layout.addWidget(self.input)
        self.input.textChanged.connect(self.on_input)

        # This is a hack, but I CANNOT figure out how to do this "properly"
        self.input.focusInEvent = on_focus(self.input.focusInEvent)

    @QtCore.Slot()
    def on_input(self):
        s = self.input.toPlainText()
        if s != '':
            broadcast(s[0].lower() + s[1:])
            self.input.setPlainText('')
            return_to_vim()

if __name__ == "__main__":
    t = threading.Thread(target=run_unix_server, daemon=True)
    t.start()

    app = QtWidgets.QApplication([])

    widget = MyWidget()
    widget.setWindowTitle('Dictation')
    widget.show()

    sys.exit(app.exec())
