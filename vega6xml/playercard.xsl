<?xml version="1.0" encoding="ISO-8859-1"?>

<!--
  This is part of vega6xml

  Copyright (C) 2016 Milan Cvetkovic
  milanc at prosperacc dot on dot ca

  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation; either version 2
  of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
-->

<!--
    Transforms players.xml to player card html page
-->

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl">

  <xsl:output
      method="xml"
      omit-xml-declaration="yes"
      encoding="UTF-8"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
      indent="yes"
      media-type="text/html"/>

  <xsl:template match="/">
    <html>
      <head>
	<title>Kingsview Chess Club | Etobicoke | Toronto</title>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta name="description" content="Kingsview Chess Club is Etobicoke chess club with long tradition. Unofficially rated tournaments, casual games every Wednesday night."/>

	<link type="text/css" rel="stylesheet" href="/css/kingsview.css"/>
	<link type="text/css" rel="stylesheet" href="/css/2cols.css"/>
	<link type="text/css" rel="stylesheet" href="/css/table.css"/>

      </head>

      <body>
	<xsl:apply-templates select="tournament"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="tournament">
    <div id="header">
      <div style="float: left; width: 95px;">
	<img src="/king.png" width="75" height="75" alt="Black King" style="padding: 10px" />
      </div>
      <div style="float: right; width: 95px">
	<img src="/knight.png" width="75" height="75" alt="White Knight" style="padding: 10px"/>
      </div>
      <h1>Kingsview Chess Club</h1>
      <h2><xsl:value-of select="@id"/> Tournament</h2>
    </div>

    <div class="colmask leftmenu">
      <div class="colright">
	<div class="col1wrap">
	  <div class="col1">
	    <xsl:apply-templates select="players"/>
	  </div>
	</div>

	<div class="col2">
	  <div id="navigation">
	    <h2></h2>
	    <ul>
	      <li><a href="/">Home</a></li>
	    </ul>
	    <h2>2011 Ratings</h2>
	    <ul>
	      <li><a href="/2011_ratings/">Cross Table</a></li>
	      <li><a href="/2011_ratings/playercard.html">Player Report</a></li>
	      <li><a href="/2011_ratings/rounds.html">Game Results</a></li>
	      <li>
		<a href="games.html">Rounds 1-6 games</a>
		<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
		<a href="2011_ratings.pgn">download</a>
	      </li>
	      <li>
		<a href="games-2.html">Rounds 6-* games</a>
		<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
		<a href="2011_ratings-2.pgn">download</a>
	      </li>
	    </ul>
	    <h2>Resources</h2>
	    <ul>
	      <li><a href="http://chesstempo.com/pgn-viewer.html">ChessTempo PGN Viewer</a></li>
	      <li><a href="http://vegachess.com">VEGA PRO Tournament SW</a></li>
	      <li><a href="http://scid.sourceforge.net/">PGN files by SCID</a></li>
	    </ul>
	  </div>
	  <!-- Column 1 end -->
	</div>
      </div>
    </div>

    <div id="footer">
      <div style="float: left; width: 80px;">
	<img src="/king.png" width="60" height="60" alt="Black King" style="padding: 10px" />
      </div>
      <div style="float: right; width: 80px">
      <img src="/knight.png" width="60" height="60" alt="White Knight" style="padding: 10px"/></div>
      <div>
	<address>
	  <br/>
	  Kingview Chess Club<br/>
	  432 Horner Avenue, Toronto, ON<br/>
	  <a href="mailto:plumia@sympatico.ca">mailto:plumia at sympatico.ca</a>
	</address>
      </div>
    </div>

  </xsl:template>

  <xsl:template match="players">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="player">
    <xsl:element name="table">
      <xsl:attribute name="id">p<xsl:value-of select="@id"/></xsl:attribute>

      <caption>
	<xsl:text>ID=</xsl:text>
	<xsl:value-of select="@id"/>
	<xsl:text>, ELO=</xsl:text>
	<xsl:value-of select="rating"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="name"/>
      </caption>
      <thead>
	<tr><th rowspan="2">Round</th><th rowspan="2">Color</th><th colspan="3">Oponent</th><th rowspan="2">Diff</th><th rowspan="2">Exp</th><th rowspan="2">Res</th></tr>
	<tr><th>ID</th><th>Name</th><th>Rating</th></tr>
      </thead>

      <tfoot>
	<tr>
	  <th colspan="5" rowspan="2">Games played:</th>
	  <th class="center">W</th><th class="center">B</th><th class="center">T</th>
	</tr>
	<tr>
	  <th class="center"><xsl:value-of select="count(games/game[@color='white'])"/></th>
	  <th class="center"><xsl:value-of select="count(games/game[@color='black'])"/></th>
	  <th class="center"><xsl:value-of select="count(games/game)"/></th>
	</tr>
	<tr>
	  <th colspan="5">New Rating:</th>
	  <th colspan="3"><xsl:value-of select="newrating"/></th>
	</tr>
	<tr>
	  <th colspan="5">Score from Best 8 Games:</th>
	  <th colspan="3">
	    <xsl:value-of select="sum(games/game[position() &lt; 8]/@score)"/>
	  </th>
	</tr>
      </tfoot>

      <tbody>
	<xsl:apply-templates select="games"/>
      </tbody>

    </xsl:element>
  </xsl:template>

  <xsl:template match="player/games">
      <xsl:apply-templates>
	<xsl:sort select="@round"/>
      </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="game">
    <xsl:element name="tr">
      <xsl:attribute name="class">
	<xsl:choose>
	  <xsl:when test="position() mod 2">odd</xsl:when>
	  <xsl:otherwise>even</xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>

      <td class="summarynumber"><xsl:value-of select="@round"/></td>
      <xsl:element name="td">
	<xsl:attribute name="class"><xsl:value-of select="@color"/></xsl:attribute>
	<xsl:value-of select="@color"/>
      </xsl:element>
      <td class="number"><xsl:value-of select="@oponent"/></td>
      <td>
	<xsl:element name="a">
	  <xsl:attribute name="href">#p<xsl:value-of select="@oponent"/></xsl:attribute>
	  <xsl:value-of select="../../../player[@id=current()/@oponent]/name"/>
	</xsl:element>
      </td>
      <td class="number"><xsl:value-of select="@oponentrating"/></td>
      <td class="number"><xsl:value-of select="../../rating - @oponentrating"/></td>
      <td class="number"><xsl:value-of select="@expectscore"/></td>
      <td class="number">
	<xsl:choose>
	  <xsl:when test="@status=0">
	    <xsl:text>adj</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="@score"/>
	  </xsl:otherwise>
	</xsl:choose>
      </td>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
