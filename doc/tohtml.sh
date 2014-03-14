#!/bin/bash

#pandoc -s report.md --highlight-style=tango -o report.html --toc
#pandoc -s -c css/style.css report.md -o report.html

pandoc -c css/style.css md/index.md -o html/index.html
pandoc -c css/style.css md/algorithm.md -o html/algorithm.html
pandoc --latexmathml -c css/style.css md/tools.md -o html/tools.html
pandoc -c css/style.css md/cacheformat.md -o html/cacheformat.html
pandoc -c css/style.css md/packets.md -o html/packets.html
pandoc -c css/style.css md/changelog.md -o html/changelog.html
pandoc -c css/style.css md/stateoftheart.md -o html/stateoftheart.html
pandoc -c css/style.css md/todos.md -o html/todos.html
pandoc -c css/style.css md/knapsack.md -o html/knapsack.html
