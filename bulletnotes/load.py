import sys
import inspect
import os

bulletnotes_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
sys.path.append(os.path.dirname(bulletnotes_dir))

import bulletnotes
