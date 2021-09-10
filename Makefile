.PHONY: site
site: jekyll examples

.PHONY: clean
clean:
	rm -rf public/**
	rm -f examples/**.pdf

public:
	mkdir -p $@

EXAMPLESILS := $(wildcard examples/*.sil)
EXAMPLEPDFS := $(addprefix public/,$(addsuffix .pdf,$(basename $(EXAMPLESILS))))

.PHONY: examples
examples: $(EXAMPLEPDFS)

$(EXAMPLEPDFS): public/%.pdf: %.sil
	mkdir -p $(dir $@)
	sile $< -o $@

.PHONY: jekyll
jekyll: | public
	jekyll build --incremental -d public

public/CNAME: | public
	echo sile-typesetter.org > $@
