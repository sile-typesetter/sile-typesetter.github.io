JEKYLL := bundle exec jekyll

.PHONY: site
site: jekyll

.PHONY: clean
clean:
	rm -rf public/**

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
jekyll: examples | public
	$(JEKYLL) build --incremental
	rsync -av _site/ public/

public/CNAME: | public
	echo sile-typesetter.org > $@
