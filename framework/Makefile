%.stl:	%.scad
	openscad "$^" -q --export-format stl  -o "$@"

all: $(patsubst %.scad,%.stl,$(wildcard *GPU*.scad))
clean:
	rm -f *.stl

.PHONY: all clean
