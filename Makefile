.PHONY: site
site: jekyll examples

.PHONY: clean
clean:
	rm -rf public/**
	rm -f examples/**.pdf

public:
	mkdir -p $@

EXAMPLESRCS := $(wildcard examples/*.sil)
EXAMPLEPDFS := $(addprefix public/,$(addsuffix .pdf,$(basename $(EXAMPLESRCS))))
EXAMPLEPNGS := $(addsuffix .png,$(basename $(EXAMPLEPDFS)))

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
