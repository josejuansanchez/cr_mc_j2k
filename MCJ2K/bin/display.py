import sys

def info(string):

    pass

def error(string):
    sys.stderr.write(string)
    sys.stderr.flush()
    sys.exit()
