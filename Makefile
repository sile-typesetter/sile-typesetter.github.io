.PHONY: site
site: jekyll examples

.PHONY: clean
clean:
	rm -rf public/**
	rm -f examples/**.pdf

public:
	mkdir -p $@

EXAMPLES := $(shell yq -r '.[][].fn' _data/examples.yml)
EXAMPLEPDFS := $(addprefix public/examples/,$(addsuffix .pdf,$(EXAMPLES)))
EXAMPLEPNGS := $(addprefix public/examples/,$(addsuffix .png,$(EXAMPLES)))

.PHONY: examples
examples: $(EXAMPLEPDFS) $(EXAMPLEPNGS)

$(EXAMPLEPDFS): public/%.pdf: %.sil
	mkdir -p $(dir $@)
	sile $< -o $@

$(EXAMPLEPNGS): %.png: %.pdf
	magick $<[0] -background white -density 300 -quality 90 -colorspace RGB -flatten $@

.PHONY: jekyll
jekyll: | public
	jekyll build --incremental -d public

public/CNAME: | public
	echo sile-typesetter.org > $@
