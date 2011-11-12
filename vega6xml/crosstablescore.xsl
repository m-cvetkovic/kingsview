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

  <xsl:import href="tournament.xsl"/>

  <xsl:variable name="playerranks">
    <xsl:for-each select="/tournament/players/player">
      <xsl:sort select="best8score" order="descending" data-type="number"/>
      <playerrank id="{@id}" rank="{position()}"/>
    </xsl:for-each>
  </xsl:variable>

  <!-- Prevent the output -->
  <xsl:template match="rounds"/>

  <xsl:template match="players">

    <xsl:variable name="rounds" select="count(../rounds/round)"/>

    <table>
      <caption>
	<xsl:value-of select="/tournament/@name"/>
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

</xsl:stylesheet>
