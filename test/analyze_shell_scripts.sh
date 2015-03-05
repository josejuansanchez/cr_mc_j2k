#!/bin/bash

# We are using ShellCheck to analyze the shell scripts.
# ShellCheck is a static analysis tool for shell scripts.
# * GitHub: https://github.com/koalaman/shellcheck
# * Website: http://www.shellcheck.net

if [[ $CR_MC_J2K_HOME = "" ]]; then
    echo "Error. CR_MC_J2K_HOME is not defined"
    exit 1
fi

find "$CR_MC_J2K_HOME" -type f -name "*.sh" -print0 | while read -d $'\0' file
do
  echo -e "Analyzing: $file"
  shellcheck $file
done

