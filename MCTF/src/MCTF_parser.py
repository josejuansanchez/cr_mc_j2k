#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

import argparse

class MCTF_parser(argparse.ArgumentParser):

#    def __init__(self, parser):
#        super(MCTF_parser, self).__init__(parser)
#    def __init__(self, *p):
#        super(MCTF_parser, self).__init__(*p)

    def always_B(self, always_B):
        self.add_argument("--always_B", help="forces to use only B frames. (Default = {})".format(always_B))

    def block_overlaping(self, block_overlaping):
        self.add_argument("--block_overlaping", help="number of overlaped pixels between the blocks in the motion compensation process. (Default = {})".format(block_overlaping))

    def block_size(self, block_size):
        self.add_argument("--block_size", help="size of the blocks in the motion estimation process. (Default = {})".format(block_size))

    def block_size_min(self, block_size_min):
        self.add_argument("--block_size_min", help="minimal block size allowed in the motion estimation process. (Default = {})".format(block_size_min))

    def border_size(self, border_size):
        self.add_argument("--border_size", help="size of the border of the blocks in the motion estimation process. (Default = {})".format(border_size))

    def GOPs(self, GOPs):
        self.add_argument("--GOPs", help="number of Group Of Pictures to process. (Default = {})".format(GOPs))

    def pictures(self, pictures):
        self.add_argument("--pictures", help="number of images to process. (Default = {})".format(pictures))

    def pixels_in_x(self, pixels_in_x):
        self.add_argument("--pixels_in_x", help="width of the pictures. (Default = {})".format(pixels_in_x))

    def pixels_in_y(self, pixels_in_y):
        self.add_argument("--pixels_in_y", help="height of the pictures. (Default = {})".format(pixels_in_y))

    def quantizations(self, quantizations):
        self.add_argument("--quantizations", help="controls the quality level and the bit-rate of the code-stream. (Default = {})".format(quantizations))

    def search_range(self, search_range):
        self.add_argument("--search_range", help="size of the search areas in the motion estimation process. (Default = {})".format(search_range))

    def subpixel_accuracy(self, subpixel_accurary):
        self.add_argument("--subpixel_accuracy", help="subpixel motion estimation order. (Default = {})".format(subpixel_accurary))

    def TRLs(self, TRLs):
        self.add_argument("--TRLs", help="number of Temporal Resolution Levels. (Default = {})".format(TRLs))

    def SRLs(self, SRLs):
        self.add_argument("--SRLs", help="number of Spatial Resolution Levels. (Default = {})".format(SRLs))

    def update_factor(self, update_factor):
        self.add_argument("--update_factor", help="weight of the update step. (Default = {})".format(update_factor))

