
# This is part of vega6xml
#
# Copyright (C) 2016 Milan Cvetkovic
# milanc at prosperacc dot on dot ca
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

# Print XML tournament description out of Vega6 tournament.veg file
# Usage:
#  awk -f makexml.awk <tournament.veg>

function calc_score(resultcode, iswhite) {
	if (resultcode == 5) return 0.5;
	if (iswhite && (resultcode == 1 || resultcode==3)) return 1;
	if (!iswhite && (resultcode == 0 || resultcode==4)) return 1;
	return 0;
} BEGIN {
	print "<?xml version=\"1.0\" ?>";
} NR == 2 {
	printf ("<tournament id=\"%s\" name=\"%s\">\n", fname, $0);
	split (pgnfiles,ar);
	pgncount = 0;
	for (pgnfile in ar) {
		v = ar[pgnfile];
		sub (/r/, "", v);
		sub (/[.]pgn$/, "", v);
		if (match (v, /^[0-9]*$/))
		    apgnfiles[v] = 1;
		else {
			name = v;
			sub (/-x$/, " to end", name);
			sub (/-/, " to ", name);
			sub (/^/, "Rounds ", name);
			if (!pgncount++) {
				print "  <pgnfiles>";
			}
			printf ("    <pgn name=\"%s\" file=\"r%s.pgn\" html=\"r%s.html\"/>\n",
				name, v, v);
		}
	}
	if (pgncount) {
				print "  </pgnfiles>";
	}
} NR == 3 {
	print "  <city>" $0 "</city>";
#} NR == 4 {
#       FIDE hosting federation
#	print "<city>" $0 "</city>";
} NR == 5 {
	sub (/,/, "", $1);
	print "  <begindate>" $1 "</begindate>" "<enddate>" $2 "</enddate>";
#} NR == 6 {
# myArbiter
#} NR == 7 {
# 0.5 1.0
#    points draw and win
#} NR == 8 {
# 1 2 0 0 0 0 0 0 0 0
# tiebreacks details: 0=not active, N=some tiebrack
#  1: Buccholz Cut 1
#  2: Buccholz Total
#  3: Buccholz Median
#  4: Sonneborn-Berger
#  5: Cumulative
#  6: Average Rat. Opp.
#  7: Most Blacks
#  8: Most Wins
#  9: Av. Perf. Rat. Opp.
} NR == 9 {
# 5 5 9 0 1 1 0
#   number_of_rounds
#   current_round
#   pairing_system: Swiss Dubov=1
#   simple round robin = 2
#   Swiss Vega = 3
#   Swiss USCF = 4
#   double round robin = 5
#   amalfi rating = 6
#   Swiss Lim = 7
#   amalfi color = 8
#   user defined = 9
#   using_fide_rating_for_pairing: 1=yes, 0=no
#   registration: 0=opened, 1=closed
#   tournament_status= 0=wait pairing, 1=wait result
#   use Kallithea 2009 rule for Buchholz: 1=yes, 0=no
	current_round = $2;
	pairing = $3;
	print "  <pairing>" pairing "</pairing>";
	if (pairing == 5)
		sections=4; # Round Robin
	else # pairing = 7
		sections=5; # swiss
} NR == 12 {
	playercount = $1;
	print "  <players>";
} NR >= 13+1 && NR < 13+(1+playercount) {
	split ($0, a, /;/);
	sub (/ *$/, "", a[1]);
	sub (/^ */, "", a[9]);

	printf ("    <player id=\"%d\"><name>%s</name><rating>%d</rating></player>\n",NR-13,a[1],a[9]);
} NR == 13+(1+playercount) {
	print "  </players>";
#	print "  <colors>";
#} NR >= 15+playercount && NR < 15+playercount*2 {
#	printf ("    <playercolor playerid=\"%d\">\n", $1);
#	for (i=2; i<NF; ++i)
#		printf ("      <color round=\"%d\">%d</color>\n", i-1, $i);
#	print "    </playercolor>"
#} NR == 15+playercount*2 {
#	print "  </colors>";
#	print "  <oponents>";
#} NR >= 16+playercount*2 && NR < 16+playercount*3 {
#	printf ("    <playeroponent playerid=\"%d\">\n", $1);
#	for (i=2; i<NF; ++i)
#		printf ("      <oponent round=\"%d\">%d</oponent>\n", i-1, $i);
#	print "    </playeroponent>"
#} NR == 16+playercount*3 {
#	print "  </oponents>";
#	print "  <floaters>";
#} NR >= 17+playercount*3 && NR < 17+playercount*4 {
#	printf ("    <playerfloater playerid=\"%d\">\n", $1);
#	for (i=2; i<NF; ++i)
#		printf ("      <floater round=\"%d\">%d</floater>\n", i-1, $i);
#	print "    </playerfloater>"
#} NR == 17+playercount*4 {
#	print "  </floaters>";
#	print "  <roundresults>"
#} NR >= 18+playercount*4 && NR < 18+playercount*5 {
#	printf ("    <playerround playerid=\"%d\">\n", $1);
#	for (i=2; i<NF; ++i)
#		printf ("      <round id=\"%d\"><result>%d</result></round>\n", i-1, $i);
#	print "    </playerround>";
#} NR == 18+playercount*sections {
#	print "  </roundresults>";
} NR == 13+(playercount+1)*sections+1 {
# code pairing

#	4(7)->46
#	6(14)->108 (18+1)*5= 13+(playercount+1)*sections
	rounds = split ($0, roundgames);
	max_games = 0;
	for (i in roundgames) {
		if (roundgames[i] > max_games) {
			max_games=roundgames[i];
		}
	}
	game = 0;
} NR > 13+(playercount+1)*sections+1 &&
  NR <= 13+(playercount+1)*sections+1 + max_games {
	++game;
	for (round=1; round<=current_round; ++round) {
		if (game <= roundgames[round]) {
			code=sprintf ("%07d", $round);
			white[round,game] = substr(code,1,3);
			black[round,game] = substr(code,4,3);
			resultcode[round,game] = substr(code,7,1);
			#print "ROUND:" round " game:" game " WHITE:" white[round,game] ":BLACK:" black[round,game];
		}
	}
} END {
	print "  <rounds>";
	for (round=1; round<=current_round; ++round) {
		printf ("    <round id=\"%d\"", round);
		if (round in apgnfiles) {
			printf (" pgnfile=\"r%d.pgn\" htmlfile=\"r%d.html\"",
				round, round);
		}
		printf (">\n", round);
		for (game=1; game<=roundgames[round]; ++game) {
			if (white[round,game] == "000") {
				printf ("      <bye playerid=\"%d\"/>\n",
					black[round,game]);
			} else if (black[round,game] == "000") {
				printf ("      <bye playerid=\"%d\"/>\n",
					white[round,game]);
			} else {
				rc = resultcode[round,game];
				if (rc == 1 || rc == 5 || rc == 0) status=1; # complete, counts
				# not complete (7=adjourned, 9=notplayed)
				else if (rc == 7 || rc == 9) status=0;
				else status=2; # complete, forfeit
				printf ("      <game status=\"%d\">", status);
				printf ("<player id=\"%d\" color=\"white\" oponent=\"%d\" score=\"%s\"/>",
					white[round,game], black[round,game],
					calc_score(rc, 1));
				printf ("<player id=\"%d\" color=\"black\" oponent=\"%d\" score=\"%s\"/>",
					black[round,game], white[round,game],
					calc_score(rc, 0));
				print "</game>";
			}
		}
		print "    </round>";
	}
	print "  </rounds>";
	print "</tournament>";
}
