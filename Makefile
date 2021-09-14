.ONESHELL:
.SECONDARY:
.SECONDEXPANSION:
.DELETE_ON_ERROR:

.SHELLFLAGS += -e

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

LOCALTESTFONTS := FONTCONFIG_FILE=$(PWD)/fontconfig.conf
SILEFLAGS ?= -d versions -f fontconfig

# This is a monkey patch to figure out how many passes we have to to to
# garantee the TOC is up to date, simplify when #230 is fixed.
hastoc = [[ -f $(patsubst public/%,%,$(subst .pdf,.toc,$@)) ]] && echo true || echo false
pages = pdfinfo $@ | awk '$$1 == "Pages:" {print $$2}' || echo 0
silepass = $(LOCALTESTFONTS) sile $(SILEFLAGS) $< -o $@ && pg0=$${pg} pg=$$($(pages))
define runsile =
	pg0=$$($(pages)) hadtoc=$$($(hastoc))
	$(silepass)
	if $(hastoc); then
		$${hadtoc} || $(silepass)
		[[ "$${pg}" -eq "$${pg0}" ]] || $(silepass)
	fi
endef

.PHONY: examples
examples: $(EXAMPLEPDFS) $(EXAMPLEPNGS)

include Makefile-fonts

$(EXAMPLEPDFS): public/%.pdf: %.sil $(addprefix .fonts/,$(EXAMFONTFILES))
	mkdir -p $(dir $@)
	$(runsile)

$(EXAMPLEPNGS): %.png: %.pdf
	magick $<[0] -background white -density 300 -quality 90 -colorspace RGB -flatten $@

.PHONY: jekyll
jekyll: | public
	jekyll build --incremental -d public

public/CNAME: | public
	echo sile-typesetter.org > $@
