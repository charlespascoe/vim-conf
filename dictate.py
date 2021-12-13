import sys
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


def substitutions(s):
    # TODO: Move this to an external file that is loaded
    subs = [
        ('sea RC', 'CRC'),
        ('cRC', 'CRC'),
        ('CLC', 'CRC'),
        ('can figuration', 'configuration'),
        ('couch TV', 'CouchDB'),
        ('couch dB', 'CouchDB'),
        ('couch GB', 'CouchDB'),
        ('couch DB', 'CouchDB'),
        ('reach controller', 'rate controller'),
        ('reach control', 'rate control'),
        ('route controller', 'rate controller'),
        ('route control', 'rate control'),
        ('great controller', 'rate controller'),
        ('bridge controller', 'rate controller'),
        ('rest API', 'REST API'),
        ('\n', '\\n'),
    ]

    for sub_from, sub_to in subs:
        s = s.replace(sub_from, sub_to)

    return s


class Handler(StreamRequestHandler):
    def handle(self):
        # TODO: Locking
        if self.request not in subscribers:
            subscribers.append(self.request)

        for data in self.rfile:
            line = data.decode('utf-8').strip()

            if line == 'start-dictation':
                start_dictation()

            print('> ' + line)

        print("Disconnected")


def start_dictation():
    script = f'tell application "System Events" to set frontmost of every process whose unix id is {os.getpid()} to true'
    subprocess.check_call(['/usr/bin/osascript', '-e', script])

    time.sleep(0.1)

    subprocess.check_call(['/usr/bin/osascript', '-e', 'tell application "System Events" to keystroke "d" using command down'])


def return_to_vim():
    subprocess.check_call(['/usr/bin/osascript', '-e', 'tell application "Alacritty" to activate'])


class ThreadedUnixStreamServer(ThreadingMixIn, UnixStreamServer):
    pass


def run_unix_server():
    with ThreadedUnixStreamServer(socket_path, Handler) as server:
        server.serve_forever()


def broadcast(output):
    output = substitutions(output) + '\n'

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
        self.layout.addWidget(self.input)
        self.input.textChanged.connect(self.magic)

    @QtCore.Slot()
    def magic(self):
        # s = self.input.text()
        s = self.input.toPlainText()
        if s != '':
            broadcast(s[0].lower() + s[1:])
            # self.input.setText('')
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
