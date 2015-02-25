import sys

def info(string):
    sys.stderr.write(string)
    sys.stderr.flush()

def error(string):
    sys.stderr.write("[0;31m")
    sys.stderr.write("Fatal error: ")
    sys.stderr.write(string)
    sys.stderr.write("Aborting!")
    sys.stderr.write("[1;0m")
    sys.stderr.flush()
    sys.exit()

def warning(string):
    sys.stderr.write("[0;34m")
    sys.stderr.write("Warning: ")
    sys.stderr.write(string)
    sys.stderr.write("[1;0m")
    sys.stderr.flush()
