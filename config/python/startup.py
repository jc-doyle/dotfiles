import sys
import readline
import atexit
import os

# Prompt
sys.ps1 = '> '

# History
histfile = os.path.join(os.getenv("XDG_CACHE_HOME", os.path.expanduser("~/.cache")), "python_history")
try:
    readline.read_history_file(histfile)
    # default history len is -1 (infinite), which may grow unruly
    readline.set_history_length(1000)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, histfile)
