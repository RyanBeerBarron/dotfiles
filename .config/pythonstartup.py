# Store interactive Python shell history in ~/.cache/python_history
# instead of ~/.python_history.
#
# Create the following .config/pythonstartup.py file
# and export its path using PYTHONSTARTUP environment variable:
#
# export PYTHONSTARTUP="${XDG_CONFIG_HOME:-$HOME/.config}/pythonstartup.py"

import atexit
import os
import readline
import sys
import io

context = globals()
class Prompt:
    def __str__(self):
        context_keys = set(context.keys())
        self.new_keys = context_keys - fixed
        self.new_keys.remove('fixed')
        if not self.new_keys:
            return 'Global environment: {}\n'
        else:
            return self.pretty_print()

    def pretty_print(self):
        output = io.StringIO()
        print('Global environment: { ', end='', file=output)
        for i, key in enumerate(self.new_keys):
            print(f'{key}: {context[key]}', end='', file=output)
            if i < len(self.new_keys) - 1:
                print(", ", end='', file=output)
        print(' }', end='\n', file=output)
        contents = output.getvalue()
        output.close()
        return contents
    new_keys = None

histfile = os.path.join(os.getenv("XDG_CACHE_HOME", os.path.expanduser("~/.cache")), "python_history")
try:

    readline.read_history_file(histfile)
    # default history len is -1 (infinite), which may grow unruly
    readline.set_history_length(1000)
    sys.ps1 = Prompt()
except FileNotFoundError:
    pass
atexit.register(readline.write_history_file, histfile)
fixed = set(globals().keys())
