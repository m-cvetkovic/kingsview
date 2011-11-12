
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
gamesfiles = 2011_ratings.pgn 2011_ratings-2.pgn games.html games-2.html
xsldeps = $(scriptdir)/tournament.xsl

install: games crosstablescore playercard rounds css

games: $(tdir) $(gamesfiles)
	cp 2011_ratings.pgn $(tdir)
	cp 2011_ratings-2.pgn $(tdir)
	cp games.html $(tdir)
	cp games-2.html $(tdir)

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

+crosstablescore.html: +players.xml $(xsldeps) $(scriptdir)/crosstablescore.xsl
	xsltproc -o $@ $(scriptdir)/crosstablescore.xsl $<

$(tdir)/playercard.html: +playercard.html $(tdir)
	cp +playercard.html $@

$(tdir)/rounds.html: +rounds.html $(tdir)
	cp +rounds.html $@

+playercard.html: +players.xml $(xsldeps) $(scriptdir)/playercard.xsl
	xsltproc -o $@ $(scriptdir)/playercard.xsl $<

+rounds.html: +players.xml $(xsldeps) $(scriptdir)/rounds.xsl
	xsltproc -o $@ $(scriptdir)/rounds.xsl $<

+players.xml: +tournament.xml $(scriptdir)/players.xsl
	xsltproc -o $@ $(scriptdir)/players.xsl $<

+tournament.xml: $(vegfile) $(scriptdir)/makexml.awk
	awk -v fname=$(tournament) -f $(scriptdir)/makexml.awk $< >$@ || rm -f $@

clean:
	rm -f ./+* *~
