
ifeq ($(INSTDIR),)
	instdir = /var/www
else
	instdir = $(INSTDIR)
endif


vegfile = $(wildcard *.veg)
tournament = $(basename $(vegfile))
tdir = $(instdir)/$(tournament)
cssfiles = $(wildcard ../css/*.css)
cssdir = $(instdir)/css
scriptdir = ../../vega6xml

install: crosstablescore playercard rounds css

crosstablescore: $(tdir) $(tdir)/index.html

playercard: $(tdir) $(tdir)/playercard.html

rounds: $(tdir) $(tdir)/rounds.html

css: $(cssdir) $(foreach file,$(cssfiles),$(cssdir)/$(notdir $(file)))

$(cssdir)/%.css: ../css/%.css $(cssdir)
	cp $< $@

$(tdir):
	mkdir -p $(tdir)

$(cssdir):
	mkdir -p $(cssdir)

$(tdir)/index.html: +crosstablescore.html $(tdir)
	cp +crosstablescore.html $@

+crosstablescore.html: +players.xml $(scriptdir)/crosstablescore.xsl
	xsltproc -o $@ $(scriptdir)/crosstablescore.xsl $<

$(tdir)/playercard.html: +playercard.html $(tdir)
	cp +playercard.html $@

$(tdir)/rounds.html: +rounds.html $(tdir)
	cp +rounds.html $@

+playercard.html: +players.xml $(scriptdir)/playercard.xsl
	xsltproc -o $@ $(scriptdir)/playercard.xsl $<

+rounds.html: +players.xml $(scriptdir)/rounds.xsl
	xsltproc -o $@ $(scriptdir)/rounds.xsl $<

+players.xml: +tournament.xml $(scriptdir)/players.xsl
	xsltproc -o $@ $(scriptdir)/players.xsl $<

+tournament.xml: $(vegfile) $(scriptdir)/makexml.awk
	awk -f $(scriptdir)/makexml.awk $< >$@ || rm -f $@

clean:
	rm -f ./+* *~
