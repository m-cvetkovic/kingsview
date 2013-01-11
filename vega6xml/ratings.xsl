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

  <!-- Prevent the output -->
  <xsl:template match="rounds"/>

  <xsl:template match="players">

    <xsl:variable name="rounds" select="count(../rounds/round)"/>

    <table>
      <caption>
	<xsl:value-of select="/tournament/@name"/>
	<xsl:text>, Ratigs at Round </xsl:text>
	<xsl:value-of select="$rounds"/>
      </caption>

      <thead>
	<tr>
	  <th>Rank</th>
	  <th>Name</th>
	  <th>Old Rating</th>
	  <th>New Rating</th>
	</tr>
      </thead>

      <tbody>
	<xsl:apply-templates>
	  <xsl:sort select="newrating" order="descending" data-type="number"/>
	</xsl:apply-templates>
      </tbody>
    </table>

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

      <td class="number"><xsl:value-of select="position()"/></td>
      <td><xsl:element name="a"><xsl:attribute name="href">playercard.html#p<xsl:value-of select="@id"/></xsl:attribute><xsl:value-of select="name"/></xsl:element></td>
      <td class="number"><xsl:value-of select="rating"/></td>
      <td class="summarynumber"><xsl:value-of select="newrating"/></td>
    </xsl:element>
  </xsl:template>


</xsl:stylesheet>
