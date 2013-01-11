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

  <xsl:import href="tournament.xsl"/>

  <!-- For explanation why this is here, see note in "player" template.  -->
  <xsl:strip-space elements="players"/>

  <!-- Prevent the output -->
  <xsl:template match="rounds"/>

  <xsl:template name="playertable">
    <xsl:param name="player"/>
    <div class="smalltablediv">
      <xsl:if test="$player">
	<xsl:element name="table">
	  <xsl:attribute name="id">p<xsl:value-of select="$player/@id"/></xsl:attribute>

	  <caption>
	    <xsl:value-of select="$player/name"/>
	    <xsl:text> ID=</xsl:text>
	    <xsl:value-of select="$player/@id"/>
	    <xsl:text> ELO=</xsl:text>
	    <xsl:value-of select="$player/rating"/>
	  </caption>
	  <thead>
	    <tr><th rowspan="2">Round</th><th rowspan="2">Color</th><th colspan="3">Oponent</th><th rowspan="2">Diff</th><th rowspan="2">Exp</th><th rowspan="2">Res</th><th rowspan="2" class="center">Rating<br/>Adj.</th></tr>
	    <tr><th>ID</th><th>Name</th><th>Rating</th></tr>
	  </thead>

	  <tfoot>
	    <tr>
	      <th colspan="6" rowspan="2">Games played:</th>
	      <th class="center">W</th><th class="center">B</th><th class="center">T</th>
	    </tr>
	    <tr>
	      <th class="center"><xsl:value-of select="count($player/games/game[@color='white'])"/></th>
	      <th class="center"><xsl:value-of select="count($player/games/game[@color='black'])"/></th>
	      <th class="center"><xsl:value-of select="count($player/games/game[@status='1'])"/></th>
	    </tr>
	    <tr>
	      <th colspan="6">New rating:</th>
	      <th colspan="3"><xsl:value-of select="$player/newrating"/></th>
	    </tr>
	    <tr>
	      <th colspan="6">
	      <xsl:text>Score</xsl:text>
	      <xsl:if test="/tournament/@nmax">
		<xsl:text> from best </xsl:text>
		<xsl:value-of select="/tournament/@nmax"/>
		<xsl:text> games</xsl:text>
	      </xsl:if>
	      <xsl:text>:</xsl:text>
	      </th>

	      <th colspan="3">
		<xsl:choose>
		  <xsl:when test="/tournament/@nmax">
		    <xsl:value-of select="$player/best8score"/>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:value-of select="sum($player/games/game/@score)"/>
		  </xsl:otherwise>
		</xsl:choose>
	      </th>
	    </tr>
	  </tfoot>

	  <tbody>
	    <xsl:apply-templates select="$player/games"/>
	  </tbody>

	</xsl:element>
      </xsl:if>
    </div>

  </xsl:template>

  <xsl:template match="player">
    <!--
	must force white stripping for players,
	otherwise position() here counts WS nodes
    -->
    <xsl:if test="position() mod 2 = 1">
      <div style="float: left">
	<xsl:call-template name="playertable">
	  <xsl:with-param name="player" select="."/>
	</xsl:call-template>
	<xsl:call-template name="playertable">
	  <xsl:with-param name="player" select="following-sibling::player[1]"/>
	</xsl:call-template>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="player/games">
      <xsl:apply-templates>
	<xsl:sort select="@round" data-type="number"/>
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

      <!--td class="summarynumber"><xsl:value-of select="@round"/></td-->
      <td class="number">
	<xsl:element name="a">
	  <xsl:attribute name="href">rounds.html#r<xsl:value-of select="@round"/></xsl:attribute>
	  <xsl:value-of select="@round"/>
	</xsl:element>
      </td>

      <xsl:choose>
	<xsl:when test="@oponent=0">
	  <td/><td/><td>BYE</td><td/><td/><td/><td/><td/>
	</xsl:when>
	<xsl:otherwise>
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
	      <xsl:when test="@status='1'">
		<!-- complete rated games -->
		<xsl:value-of select="@score"/>
		<xsl:if test="@oponentrating &lt; ../../weakest8oponent">
		  <xsl:text>*</xsl:text>
		</xsl:if>
	      </xsl:when>
	      <xsl:when test="@status='0'">
		<!-- adjourned games -->
		<xsl:text>adj</xsl:text>
	      </xsl:when>
	      <xsl:otherwise>
		<!-- forfeit games -->
		<xsl:value-of select="@score"/><xsl:text>F</xsl:text>
	      </xsl:otherwise>
	    </xsl:choose>
	  </td>

	  <td class="number">
	      <xsl:if test="@status='1'">
		<!-- complete rated games -->
		<xsl:value-of select="round(32 * (@score - @expectscore))"/>
	      </xsl:if>
	  </td>

	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
