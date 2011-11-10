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

<!-- transform players.xsl to crosstablescore.html -->

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

  <xsl:variable name="playerranks">
    <xsl:for-each select="/tournament/players/player">
      <xsl:sort select="best8score" order="descending" data-type="number"/>
      <playerrank id="{@id}" rank="{position()}"/>
    </xsl:for-each>
  </xsl:variable>

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
	<xsl:apply-templates/>
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
	    <xsl:apply-templates/>
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

    <xsl:variable name="rounds" select="count(../rounds/round)"/>

    <table>
      <caption>
	<xsl:value-of select="/tournament/@id"/>
	<xsl:text>, Cross Table at Round </xsl:text>
	<xsl:value-of select="$rounds"/>
      </caption>

      <thead>
	<tr>
	  <th rowspan="2">ID</th>
	  <th rowspan="2">Name</th>
	  <th rowspan="2">Rating</th>
	  <xsl:element name="th">
	    <xsl:attribute name="class">center</xsl:attribute>
	    <xsl:attribute name="colspan">
	      <xsl:value-of select="count(../rounds/round)"/>
	    </xsl:attribute>
	    <xsl:text>Rounds</xsl:text>
	  </xsl:element>
	  <th colspan="3">Games</th>
	  <th rowspan="2">Perf</th>
	  <th rowspan="2">New<br/>Rating</th>
	  <th rowspan="2">Score</th>
	  <th rowspan="2">Best 8<br/>Score</th>
	</tr>
	<tr>
	  <xsl:for-each select="../rounds/round">
	    <th class="center"><xsl:value-of select="@id"/></th>
	  </xsl:for-each>
	  <th>W</th><th>B</th><th>T</th>
	</tr>
      </thead>

      <tbody>
	<xsl:apply-templates>
	  <xsl:sort select="best8score" order="descending" data-type="number"/>
	</xsl:apply-templates>
      </tbody>
    </table>

  </xsl:template>

  <xsl:template name="printscore">
    <xsl:param name="mygame"/>
    <xsl:choose>
      <xsl:when test="$mygame/@status = '0'">*</xsl:when>
      <xsl:otherwise>
	<xsl:choose>
	  <xsl:when test="$mygame/@score = '0'">-</xsl:when>
	  <xsl:when test="$mygame/@score = '1'">+</xsl:when>
	  <xsl:when test="$mygame/@score = '0.5'">=</xsl:when>
	  <xsl:otherwise>?</xsl:otherwise>
	</xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="player">

    <xsl:element name="tr">
      <xsl:attribute name="class">
	<xsl:choose>
	  <xsl:when test="position() mod 2">odd</xsl:when>
	  <xsl:otherwise>even</xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>

      <xsl:variable name="id" select="@id"/>
      <xsl:variable name="pgames" select="games"/>

      <td class="number"><xsl:value-of select="exsl:node-set($playerranks)/playerrank[@id=$id]/@rank"/></td>
      <td><xsl:element name="a"><xsl:attribute name="href">playercard.html#p<xsl:value-of select="@id"/></xsl:attribute><xsl:value-of select="name"/></xsl:element></td>
      <td class="number"><xsl:value-of select="rating"/></td>

      <xsl:for-each select="../../rounds/round">
	<xsl:variable name="pgame" select="$pgames/game[@round=current()/@id]"/>
	<xsl:choose>
	  <xsl:when test="$pgame">

	    <xsl:choose>
	      <xsl:when test="$pgame/@color='white'">
		<td class="white">
		  <xsl:text>w</xsl:text>
		  <xsl:call-template name="printscore">
		    <xsl:with-param name="mygame" select="$pgame"/>
		  </xsl:call-template>
		  <xsl:value-of select="exsl:node-set($playerranks)/playerrank[@id=$pgame/@oponent]/@rank"/>
		</td>
	      </xsl:when>
	      <xsl:otherwise>
		<td class="black">
		  <xsl:text>b</xsl:text>
		  <xsl:call-template name="printscore">
		    <xsl:with-param name="mygame" select="$pgame"/>
		    </xsl:call-template>
		  <xsl:value-of select="exsl:node-set($playerranks)/playerrank[@id=$pgame/@oponent]/@rank"/>
		</td>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:when>
	  <xsl:otherwise>
	    <td class="grey">-</td>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:for-each>

      <td class="number"><xsl:value-of select="count(games/game[@color='white'])"/></td>
      <td class="number"><xsl:value-of select="count(games/game[@color='black'])"/></td>
      <td class="summarynumber"><xsl:value-of select="count(games/game)"/></td>
      <td class="number"><xsl:value-of select="perfrt"/></td>
      <td class="summarynumber"><xsl:value-of select="newrating"/></td>
      <td class="number"><xsl:value-of select="sum(games/game/@score)"/></td>
      <td class="summarynumber"><xsl:value-of select="best8score"/></td>
    </xsl:element>
  </xsl:template>

  <xsl:template match="rounds"/>
</xsl:stylesheet>
