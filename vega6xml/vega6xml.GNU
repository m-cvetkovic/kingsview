ifeq ($(INSTDIR),)
	instdir = /var/www
else
	instdir = $(INSTDIR)
endif


vegfile = $(wildcard *.veg)
tournament = $(basename $(vegfile))
tdir = $(instdir)/$(tournament)
tmpdir = ./+tmp
cssfiles = $(wildcard ../css/*.css)
cssdir = $(instdir)/css
pgnfiles=$(wildcard *.pgn)
gameshtml=$(addsuffix .html, $(addprefix $(tdir)/, $(basename $(pgnfiles))))
gamespgn=$(addprefix $(tdir)/,$(pgnfiles))
xsldeps = $(scriptdir)/tournament.xsl

games: $(tdir) $(gameshtml) $(gamespgn)

test:
	echo $(gameshtml)

$(tdir)/%.pgn: %.pgn
	cp $< $@

$(tdir)/%.html: %s.pgn $(scriptdir)/games.xml $(tmpdir)/players.xml
	xsltproc --stringparam pgnfile $< --stringparam title "2011 Ratings, Round 1" -o $@ $(scriptdir)/games.xsl $(tmpdir)/players.xml

crosstablescore: $(tdir) $(tdir)/index.html

ratings: $(tdir) $(tdir)/ratings.html

playercard: $(tdir) $(tdir)/playercard.html

rounds: $(tdir) $(tdir)/rounds.html

css: $(cssdir) $(foreach file,$(cssfiles),$(cssdir)/$(notdir $(file)))

$(cssdir)/%.css: ../css/%.css $(cssdir)
	cp $< $@

$(tmpdir) $(tdir) $(cssdir):
	mkdir -p $@

$(tdir)/index.html: $(tmpdir)/crosstablescore.html $(tdir)
	cp $(tmpdir)/crosstablescore.html $@

$(tdir)/ratings.html: $(tmpdir)/ratings.html $(tdir)
	cp $(tmpdir)/ratings.html $@

$(tmpdir)/%.html: $(scriptdir)/%.xsl $(tmpdir)/players.xml $(tmpdir)/players.xml $(xsldeps)
	xsltproc -o $@ $< $(tmpdir)/players.xml

$(tdir)/playercard.html: $(tmpdir)/playercard.html $(tdir)
	cp $(tmpdir)/playercard.html $@

$(tdir)/rounds.html: $(tmpdir)/rounds.html $(tdir)
	cp $(tmpdir)/rounds.html $@

$(tmpdir)/players.xml: $(tmpdir)/tournament.xml $(scriptdir)/players.xsl
	xsltproc -o $@ $(scriptdir)/players.xsl $<

$(tmpdir)/tournament.xml: $(vegfile) $(scriptdir)/makexml.awk $(tmpdir)
	awk -v fname=$(tournament) -v pgnfiles="$(wildcard r*.pgn)" -f $(scriptdir)/makexml.awk $< >$@ || rm -f $@

$(tdir)/%.html: %.pgn $(scriptdir)/games.xsl $(tmpdir)/players.xml
	xsltproc --stringparam pgnfile $< -o $@ $(scriptdir)/games.xsl $(tmpdir)/players.xml
	cp $< $(tdir)

clean:
	rm -fr $(tmpdir) *~
