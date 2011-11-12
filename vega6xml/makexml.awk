
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
} NR == 12 {
	playercount = $1;
	print "  <players>";
} NR >= 14 && NR < 14+playercount {
	split ($0, a, /;/);
	sub (/ *$/, "", a[1]);
	sub (/^ */, "", a[9]);

	printf ("    <player id=\"%d\"><name>%s</name><rating>%d</rating></player>\n",NR-13,a[1],a[9]);
} NR == 14+playercount {
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
#} NR == 18+playercount*5 {
#	print "  </roundresults>";
} NR == 18+playercount*5 + 1 {
	rounds = split ($0, roundgames);
	game = 0;
} NR > 18+playercount*5 + 1 && NR < 18+playercount*5 + 1 + rounds {
	++game;
	for (round=1; round<=rounds; ++round) {
		if (game <= roundgames[round]) {
			code=sprintf ("%07d", $round);
			white[round,game] = substr(code,1,3);
			black[round,game] = substr(code,4,3);
			resultcode[round,game] = substr(code,7,1);
		}
	}
	maxgame = game;
} END {
	print "  <rounds>";
	for (round=1; round<=rounds; ++round) {
		printf ("    <round id=\"%d\">\n", round);
		for (game=1; game<=roundgames[round]; ++game) {
			rc = resultcode[round,game];
			printf ("      <game status=\"%d\">", rc != 7 && rc != 9);
			printf ("<player id=\"%d\" color=\"white\" oponent=\"%d\" score=\"%s\"/>",
				white[round,game], black[round,game],
				calc_score(rc, 1));
			printf ("<player id=\"%d\" color=\"black\" oponent=\"%d\" score=\"%s\"/>",
				black[round,game], white[round,game],
				calc_score(rc, 0));
			print "</game>";
		}
		print "    </round>";
	}
	print "  </rounds>";
	print "</tournament>";
}
