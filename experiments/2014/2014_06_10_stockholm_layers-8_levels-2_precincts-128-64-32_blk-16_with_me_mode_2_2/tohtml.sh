#!/bin/bash

pandoc -s --latexmathml -c css/style.css md/report.md -o html/report.html

