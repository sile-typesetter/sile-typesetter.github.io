JEKYLL := docker run -v "$(PWD)":/srv/jekyll jekyll/builder:latest jekyll

.PHONY: site
site: jekyll

.PHONY: clean
clean:
	rm -rf public/**

public:
	mkdir -p $@

.PHONY: jekyll
jekyll: | public
	$(JEKYLL) build --incremental
	rsync -av _site/ public/

public/CNAME: | public
	echo sile-typesetter.org > $@
