
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

  <xsl:template match="pgnfiles"/>

  <xsl:template match="pgn">
    <tr>
      <td>
	<xsl:element name="a">
	  <xsl:attribute name="href">
	    <xsl:value-of select="@html"/>
	  </xsl:attribute>
	  <xsl:value-of select="@name"/>
	</xsl:element>
      </td>
      <td><a href="{@file}">PGN</a></td>
    </tr>
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
      <h2><xsl:value-of select="@name"/> Tournament</h2>
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
	    <h2><xsl:value-of select="@name"/></h2>
	    <ul>
	      <li><a href="./">Cross Table</a></li>
	      <li><a href="./playercard.html">Player Report</a></li>
	      <li><a href="./rounds.html">Game Results</a></li>
	    </ul>
	    <h2>Games:</h2>
	    <ul>
	      <li>
		  <table>
		    <xsl:apply-templates select="//pgnfiles/pgn"/>
		    <xsl:for-each select="//rounds/round[@htmlfile]">
		      <tr>
			<td>
			  <xsl:element name="a">
			    <xsl:attribute name="href">
			      <xsl:value-of select="@htmlfile"/>
			    </xsl:attribute>
			    <xsl:text>Round </xsl:text>
			    <xsl:value-of select="@id"/>
			  </xsl:element>
			</td>
			<td>
			  <a href="{@pgnfile}">PGN</a>
			</td>
		      </tr>
		    </xsl:for-each>
		  </table>
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

</xsl:stylesheet>
