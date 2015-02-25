#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

from info import info

class info_j2k(info):

    def find_next_EOC_texture(self, file):
        """Find the length of JPEG 2000 image"""
        return int(file.readline())

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
        """Open a JPEG 2000 code-stream"""
        return open(codestream_filename + ".j2c", 'rb')

x=info_j2k() # ?
