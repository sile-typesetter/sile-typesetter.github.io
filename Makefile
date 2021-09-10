.PHONY: site
site: jekyll

.PHONY: clean
clean:
	rm -rf public/**

public:
	mkdir -p $@

define jekyll =
	docker run -v "$(PWD)":/srv/jekyll -v "$(PWD)"/public:/srv/jekyll/public \
        jekyll/builder:latest /bin/bash -c "chmod -R 777 /srv/jekyll{,/public} && jekyll $1"
endef

.PHONY: jekyll
jekyll: | public
	$(call jekyll,build -d public)

public/CNAME: | public
	echo sile-typesetter.org > $@
