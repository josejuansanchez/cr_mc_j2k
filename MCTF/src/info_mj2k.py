#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# info_mj2k.py

from info import info

class info_mj2k(info):

    def find_next_EOC_texture(self, file):
        """Find the next End Of fame's Code-stream (FFD9) in a Motion
        JPEG 2000 code-stream"""
        byte = file.read(1)
        #print "Buscando ..."
        #print byte
        while byte != '':
            #sys.stdout.write(byte)
            if byte == '\xff':
                #print "\xff"
                byte = file.read(1)
                if byte == '\xd9':
                    return file.tell()
            byte = file.read(1)
        return file.tell()

    def find_next_EOC_motion(self, file):
        """Find the next End Of fame's Code-stream (FFD9) in a Motion
        JPEG 2000 code-stream"""
        byte = file.read(1)
        #print "Buscando ..."
        #print byte
        while byte != '':
            #sys.stdout.write(byte)
            if byte == '\xff':
                #print "\xff"
                byte = file.read(1)
                if byte == '\xd9':
                    return file.tell()
            byte = file.read(1)
        return file.tell()

    def open_codestream(self, codestream_filename):
        """Open a Motion JPEG 2000 code-stream"""
        return open(codestream_filename + ".mjc", 'rb')

x=info_mj2k() # ?
