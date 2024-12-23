# /^\*\/\* make '\''[a-z0-9_-]*'\'' \*\//!d; # find rows with the tag
# s/\*\/\* make '\''//; # remove text before the export name
# s/'\''.*/.stl/ # remove text after, and add the STL file extension
TARGETS=$(shell sed '/^\*\/\* make '\''[a-zA-Z0-9_\-\ ]*'\'' \*\//!d;s/\*\/\* make '\''//;s/'\''.*/.stl/' PLSS.scad)

all: ${TARGETS}

# auto-generated .scad files with .deps make make re-build always. keeping the
# scad files solves this problem. (explanations are welcome.)
.SECONDARY: $(shell echo "${TARGETS}" | sed 's/\.stl/.scad/g')

# explicit wildcard expansion suppresses errors when no files are found
include $(wildcard *.deps)

# s/^\*\/\* make '\''$*'\'' \*\/\ /\!/; # add the ! operator to the target so that openscad will only render what we want
# s/^$$fn \= [0-9]*\;/$$fn = 144\;/ # set the rendering resolution
%.scad:
	#sed 's/^\*\/\* make '\''$*'\'' \*\/\ /\!/;s/^$$fn \= [0-9]*\;/$$fn = 144\;/' PLSS.scad  > $@

%.stl: %.scad
	#/Applications/OpenSCAD\ 2.app/Contents/MacOS/OpenSCAD -m make -o $@ -d $@.deps $<
	#/Applications/OpenSCAD\ 2.app/Contents/MacOS/OpenSCAD --enable all -o $@ $<
	echo "$@"
