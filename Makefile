SRC = $(wildcard *.sol)

.PHONY: clean outdir

all: outdir $(SRC:.sol=.bin)

%.bin: %.sol
	solc --overwrite --abi --bin --optimize = -o out/ $<

outdir:
	mkdir -p out

clean:
	rm -f out/*