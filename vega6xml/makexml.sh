#!/bin/sh

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

# Generate web page in /var/www/<tournament> based on Vega6 description file.

if [ $# != 1 ]; then
    echo "Usage: $0 <tournament.veg>"
    exit 1
fi

tournament=$(echo $1 | sed 's/.veg$//')
scriptpath=$(dirname $0)
awkname=$scriptpath/makexml.awk

awk -f $awkname $tournament.veg >./+tournament.xml
xsltproc $scriptpath/players.xsl ./+tournament.xml >./+players.xml

xsltproc $scriptpath/crosstablescore.xsl \
    ./+players.xml >./+crosstablescore.html

cp ./+crosstablescore.html /var/www/$tournament/index.html
