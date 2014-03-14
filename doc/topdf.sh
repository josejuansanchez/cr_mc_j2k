#!/bin/bash

pandoc md/index.md -o pdf/index.pdf
pandoc md/algorithm.md -o pdf/algorithm.pdf
pandoc md/tools.md -o pdf/tools.pdf
pandoc md/cacheformat.md -o pdf/cacheformat.pdf
pandoc md/packets.md -o pdf/packets.pdf
pandoc md/changelog.md -o pdf/changelog.pdf
pandoc md/stateoftheart.md -o pdf/stateoftheart.pdf