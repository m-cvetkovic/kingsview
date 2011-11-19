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

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl">

  <xsl:import href="tournament.xsl"/>

  <xsl:param name="pgnfile"/>

  <xsl:template match="/">
    <html>
      <head>
	<title>Kingsview Chess Club | Etobicoke | Toronto</title>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta name="description" content="Kingsview Chess Club is Etobicoke chess club with long tradition. Unofficially rated tournaments, casual games every Wednesday night."/>

    <link type="text/css"
	  rel="stylesheet"
	  href="http://chesstempo.com/css/board-min.css"/>

	<link type="text/css" rel="stylesheet" href="/css/kingsview.css"/>
	<!--link type="text/css" rel="stylesheet" href="/css/2cols.css"/-->
	<link type="text/css" rel="stylesheet" href="/css/games.css"/>

    <!-- Support libraries from Yahoo YUI project -->
    <script type="text/javascript"
	    src="http://chesstempo.com/js/pgnyui.js">
    </script>

    <script type="text/javascript"
	    src="http://chesstempo.com/js/pgnviewer.js">
    </script>

    <script type="text/javascript">
      new PgnViewer({
        boardName: "board1",
        pgnFile: '<xsl:value-of select="$pgnfile"/>',
        pieceSet: 'merida',
        pieceSize: 46,
        movesFormat: 'default'
      }
      );
    </script>

      </head>

      <body>

	<div id="header">
	  <div style="float: left; width: 95px;">
	    <img src="/king.png" width="75" height="75" alt="Black King" style="padding: 10px" />
	  </div>
	  <div style="float: right; width: 95px">
	  <img src="/knight.png" width="75" height="75" alt="White Knight" style="padding: 10px"/></div>
	  <h1>Kingsview Chess Club</h1>
	  <h3>
	    <xsl:value-of select="/tournament/@name"/>
	    <xsl:text>, </xsl:text>
	    <xsl:value-of select="/tournament/pgnfiles/pgn[@file=$pgnfile]/@name"/>
	  </h3>
	</div>

	<div id="container2">
	  <xsl:call-template name="navigation"/>

	  <div id="container1">
	    <div id="board1-container"></div>
	    <div id="board1-moves"></div>
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

      </body>
    </html>
  </xsl:template>

  <!-- Prevent the output -->
  <xsl:template match="players"/>
  <xsl:template match="rounds"/>

</xsl:stylesheet>
