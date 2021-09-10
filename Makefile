JEKYLL ?= jekyll

.PHONY: site
site: jekyll

.PHONY: clean
clean:
	rm -rf public/**

public:
	mkdir -p $@

.PHONY: jekyll
jekyll: | public
	$(JEKYLL) build -d public
