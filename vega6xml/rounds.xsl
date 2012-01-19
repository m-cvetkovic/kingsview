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

  <!-- For explanation why this is here, see note in "game" template.  -->
  <xsl:strip-space elements="round"/>

  <!-- Prevent the output -->
  <xsl:template match="players"/>

  <xsl:template match="round">
    <div class="smalltablediv">
      <xsl:element name="table">
	<xsl:attribute name="id">r<xsl:value-of select="@id"/></xsl:attribute>

	<caption>Round <xsl:value-of select="@id"/></caption>
	<thead>
	  <tr><th>Board</th><th>White</th><th>Black</th><th>Result</th></tr>
	</thead>

	<tbody>
	  <xsl:apply-templates/>
	</tbody>

      </xsl:element>
    </div>
  </xsl:template>

  <xsl:template match="player">
    <xsl:element name="a">
      <xsl:attribute name="href">playercard.html#p<xsl:value-of select="@id"/></xsl:attribute>
      <xsl:value-of select="/tournament/players/player[@id=current()/@id]/name"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="game">
    <!--
	must force white stripping for round,
	otherwise position() here counts WS nodes
    -->

    <xsl:element name="tr">
      <xsl:attribute name="class">
	<xsl:choose>
	  <xsl:when test="position() mod 2">odd</xsl:when>
	  <xsl:otherwise>even</xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>

      <td class="number"><xsl:value-of select="position()"/></td>
      <td><xsl:apply-templates select="player[@color = 'white']"/></td>
      <td><xsl:apply-templates select="player[@color = 'black']"/></td>
      <td class="center">
	<xsl:choose>
	  <xsl:when test="@status = '0'">adj</xsl:when>
	  <xsl:when test="player[@color='white']/@score = '0.5'">½ - ½</xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="player[@color='white']/@score"/>
	    <xsl:text> - </xsl:text>
	    <xsl:value-of select="player[@color='black']/@score"/>
	    <xsl:if test="@status = '2'">F</xsl:if>
	  </xsl:otherwise>
	</xsl:choose>
      </td>
    </xsl:element>
  </xsl:template>

  <xsl:template match="bye">
    <!--
	must force white stripping for round,
	otherwise position() here counts WS nodes
    -->

    <xsl:element name="tr">
      <xsl:attribute name="class">
	<xsl:choose>
	  <xsl:when test="position() mod 2">odd</xsl:when>
	  <xsl:otherwise>even</xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>

      <td class="number"><xsl:value-of select="position()"/></td>
      <td>
	<xsl:element name="a">
	  <xsl:attribute name="href">playercard.html#p<xsl:value-of select="@playerid"/></xsl:attribute>
	  <xsl:value-of select="/tournament/players/player[@id=current()/@playerid]/name"/>
	</xsl:element>
      </td>

      <td>BYE</td>
      <td class="center">-</td>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
