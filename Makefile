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

EXAMPLES := $(shell yq -r '.[][] | select(.devel != true) | .fn' _data/examples.yml)
EXAMPLEPDFS := $(addprefix public/examples/,$(addsuffix .pdf,$(EXAMPLES)))

DEVELEXAMPLES := $(shell yq -r '.[][] | select(.devel == true) | .fn' _data/examples.yml)
DEVELEXAMPLEPDFS := $(addprefix public/examples/,$(addsuffix .pdf,$(DEVELEXAMPLES)))

EXAMPLEPNGS := $(addprefix public/examples/,$(addsuffix .png,$(EXAMPLES) $(DEVELEXAMPLES)))
EXAMPLETHBS := $(addprefix public/examples/,$(addsuffix -thumb.png,$(EXAMPLES) $(DEVELEXAMPLES)))

LOCALTESTFONTS := FONTCONFIG_FILE=$(PWD)/fontconfig.conf
SILEFLAGS ?= -d versions -f fontconfig

# This is a monkey patch to figure out how many passes we have to to to
# garantee the TOC is up to date, simplify when #230 is fixed.
hastoc = [[ -f $(patsubst public/%,%,$(subst .pdf,.toc,$@)) ]] && echo true || echo false
pages = pdfinfo $@ | awk '$$1 == "Pages:" {print $$2}' || echo 0
silepass = $(LOCALTESTFONTS) $(SILE) $(SILEFLAGS) $< -o $@ && pg0=$${pg} pg=$$($(pages))
define runsile =
	pg0=$$($(pages)) hadtoc=$$($(hastoc))
	$(silepass)
	if $(hastoc); then
		$${hadtoc} || $(silepass)
		[[ "$${pg}" -eq "$${pg0}" ]] || $(silepass)
	fi
endef

.PHONY: examples
examples: $(EXAMPLEPDFS) $(DEVELEXAMPLEPDFS) $(EXAMPLEPNGS) $(EXAMPLETHBS)

include Makefile-fonts

$(EXAMPLEPDFS): SILE ?= sile
$(DEVELEXAMPLEPDFS): SILE ?= nix run github:sile-typesetter/sile --

$(EXAMPLEPDFS) $(DEVELEXAMPLEPDFS): public/%.pdf: %.sil $(addprefix .fonts/,$(EXAMFONTFILES))
	mkdir -p $(dir $@)
	$(runsile)

$(EXAMPLEPNGS): %.png: %.pdf
	magick -density 300 $<[0] -background white -quality 95 -sharpen 0x1.0 -colorspace RGB -flatten $@

$(EXAMPLETHBS): %-thumb.png: %.pdf
	magick -density 72 $<[0] -background white -quality 95 -sharpen 0x1.0 -colorspace RGB -flatten $@

.PHONY: jekyll
jekyll: | public
	jekyll build --incremental -d public

public/CNAME: | public
	echo sile-typesetter.org > $@
