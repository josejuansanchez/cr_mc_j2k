import sys

def info(string):
ifdef({DEBUG}},
    sys.stderr.write(string)
    sys.stderr.flush()
)
    pass

def error(string):
    sys.stderr.write(string)
    sys.stderr.flush()
    sys.exit()
