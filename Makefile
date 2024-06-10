.ONESHELL:
.SECONDARY:
.SECONDEXPANSION:
.DELETE_ON_ERROR:

.SHELLFLAGS += -e

.PHONY: public
public: zola

.PHONY: clean
clean:
	rm -rf public/**
	rm -f examples/**.pdf

# Works in our deploy because Make is 4.3+ run by Nix
MAKEFLAGS += --jobs $(shell nproc)

EXAMPLES := $(shell tomlq -r '.[][] | select(.devel != true) | .fn' data/examples.toml)
EXAMPLEPDFS := $(addprefix static/examples/,$(addsuffix .pdf,$(EXAMPLES)))

DEVELEXAMPLES := $(shell tomlq -r '.[][] | select(.devel == true) | .fn' data/examples.toml)
DEVELEXAMPLEPDFS := $(addprefix static/examples/,$(addsuffix .pdf,$(DEVELEXAMPLES)))

EXAMPLEPNGS := $(addprefix static/examples/,$(addsuffix .png,$(EXAMPLES) $(DEVELEXAMPLES)))
EXAMPLETHBS := $(addprefix static/examples/,$(addsuffix -thumb.png,$(EXAMPLES) $(DEVELEXAMPLES)))

LOCALTESTFONTS := FONTCONFIG_FILE=$(PWD)/fontconfig.conf
SILEFLAGS ?= -d versions -f fontconfig

# This is a monkey patch to figure out how many passes we have to to to
# garantee the TOC is up to date, simplify when #230 is fixed.
hastoc = [[ -f $(patsubst static/%,%,$(subst .pdf,.toc,$@)) ]] && echo true || echo false
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

.PHONY: static
static: examples lua-api-docs

DOCSBRANCH = master
.PHONY: lua-api-docs
lua-api-docs: static/lua-api/index.html

static/lua-api/index.html: sile-sources-$(DOCSBRANCH)
	pushd $<
	touch aminclude.am
	nix develop --phase autoreconf
	nix develop --configure
	nix develop --command bash -c "make lua-api-docs"
	popd
	rsync -av $</lua-api-docs/ $(@D)/

sile-sources-$(DOCSBRANCH):
	git clone -b $(DOCSBRANCH) --depth 1 --recurse-submodules https://github.com/sile-typesetter/sile $@

.PHONY: examples
examples: $(EXAMPLEPDFS) $(DEVELEXAMPLEPDFS) $(EXAMPLEPNGS) $(EXAMPLETHBS)

include Makefile-fonts

HASH := \#

$(EXAMPLEPDFS): SILE ?= sile
$(DEVELEXAMPLEPDFS): SILE ?= nix run github:sile-typesetter/sile$(HASH)sile --

static/examples/docbook.pdf: SILEFLAGS += -c docbook

static/%.pdf: content/%.sil $(addprefix .fonts/,$(EXAMFONTFILES))
	mkdir -p $(dir $@)
	$(runsile)

static/%.pdf: content/%.xml $(addprefix .fonts/,$(EXAMFONTFILES))
	mkdir -p $(dir $@)
	$(runsile)

static/%.pdf: content/%.lua $(addprefix .fonts/,$(EXAMFONTFILES))
	mkdir -p $(dir $@)
	lua $< $@

$(EXAMPLEPNGS): %.png: %.pdf
	magick -density 300 $<[0] -background white -quality 95 -sharpen 0x1.0 -colorspace RGB -flatten $@

$(EXAMPLETHBS): %-thumb.png: %.pdf
	magick -density 72 $<[0] -background white -quality 95 -sharpen 0x1.0 -colorspace RGB -flatten $@

.PHONY: zola
zola: static
	zola build

public/CNAME:
	echo sile-typesetter.org > $@
