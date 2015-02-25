#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

import sys
import os

def call(string):
    x = os.system(string)
    if x!=0:
        sys.exit()

