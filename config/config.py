#!/usr/bin/python

import sys
import os
import imp

# Checking the environment variable CR_MC_J2K_HOME
if not os.environ["CR_MC_J2K_HOME"]:
	print "Error. CR_MC_J2K_HOME is not defined"
	sys.exit(-1)

CR_MC_J2K_HOME = os.environ["CR_MC_J2K_HOME"]

# Load the path for all the tools used in the experiments
tools_config_file_path = CR_MC_J2K_HOME + "/config/tools.py"
tools = imp.load_source("tools", tools_config_file_path)

# Load the configuration file with information about the sequence:
# - compression parameters used in kdu_compress
# - motion estimation parameters
sequence_config_file_path = CR_MC_J2K_HOME + "/config/sequences/speedway_layers-8_levels-4_precincts-128_blk-16.py"
sequence = imp.load_source("sequence", sequence_config_file_path)