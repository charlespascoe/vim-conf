import inspect
import os
print(os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe()))))
