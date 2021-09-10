JEKYLL ?= jekyll

.PHONY: public
public:
	$(JEKYLL) build -d $@
