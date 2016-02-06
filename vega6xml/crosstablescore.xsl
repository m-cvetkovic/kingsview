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
	    <xsl:choose>
	      <xsl:when test="/tournament/@pairing=5 or /tournament/@pairing=2">
		<xsl:attribute name="class">center</xsl:attribute>
		<xsl:attribute name="colspan">
		  <xsl:value-of select="count(player)"/>
		</xsl:attribute>
		<xsl:text>Players</xsl:text>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:attribute name="colspan">
		  <xsl:value-of select="count(../rounds/round)"/>
		</xsl:attribute>
		<xsl:text>Rounds</xsl:text>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:element>
	  <xsl:if test="/tournament/@pairing!=5 and /tournament/@pairing!=2">
	    <th colspan="3">Games</th>
	  </xsl:if>
	  <th rowspan="2">Perf</th>
	  <th rowspan="2">New<br/>Rating</th>
	  <th rowspan="2">Score</th>
	  <xsl:if test="/tournament/@pairing!=5  and /tournament/@pairing!=2 and /tournament/@nmax">
	    <th rowspan="2">Best <xsl:value-of select="/tournament/@nmax"/><br/>Score</th>
	  </xsl:if>
	</tr>
	<tr>
	  <xsl:choose>
	    <xsl:when test="/tournament/@pairing=5 or /tournament/@pairing=2">
	      <xsl:for-each select="player">
		<th class="center">
		  <xsl:value-of select="position()"/>
		</th>
	      </xsl:for-each>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:for-each select="../rounds/round">
		<th class="center">
		  <xsl:element name="a">
		    <xsl:attribute name="href">rounds.html#r<xsl:value-of select="@id"/></xsl:attribute>
		    <xsl:value-of select="@id"/>
		  </xsl:element>
		</th>
	      </xsl:for-each>
	      <th>W</th><th>B</th><th>T</th>
	    </xsl:otherwise>
	  </xsl:choose>
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

  <xsl:template name="printscore_rr">
    <xsl:param name="mygame"/>
    <xsl:choose>
      <xsl:when test="$mygame/@status = '0'">*</xsl:when>
      <xsl:otherwise>
	<xsl:choose>
	  <xsl:when test="not($mygame/@score)">-</xsl:when>
	  <xsl:when test="$mygame/@score = '0.5'">½</xsl:when>
	  <xsl:otherwise><xsl:value-of select="$mygame/@score"/></xsl:otherwise>
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

      <xsl:choose>
	<xsl:when test="/tournament/@pairing=5 or /tournament/@pairing=2">
	  <xsl:variable name="gg" select="games/game"/>
	  <xsl:for-each select="exsl:node-set($playerranks)/playerrank">
	    <xsl:sort select="@rank" data-type="number"/>
	    <xsl:choose>
	      <xsl:when test="$id = @id"><td class="hole"/></xsl:when>
	      <xsl:otherwise>
		<xsl:choose>
		  <xsl:when test="/tournament/@pairing=5">
		    <td class="grey">
		      <xsl:call-template name="printscore_rr">
			<xsl:with-param name="mygame" select="$gg[@color='white'and @oponent=current()/@id]"/>
		      </xsl:call-template>
		      <xsl:call-template name="printscore_rr">
			<xsl:with-param name="mygame" select="$gg[@color='black'and @oponent=current()/@id]"/>
		      </xsl:call-template>
		    </td>
		  </xsl:when>
		  <xsl:otherwise>
		    <!-- single round robin, cells have game color -->
		    <xsl:variable name="rrgame"
				  select="$gg[@oponent=current()/@id]"/>
		    <td class="{$rrgame/@color}">
		      <xsl:call-template name="printscore_rr">
			<xsl:with-param name="mygame" select="$rrgame"/>
		      </xsl:call-template>
		    </td>
		  </xsl:otherwise>
		</xsl:choose>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:for-each>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:for-each select="../../rounds/round">
	    <xsl:variable name="pgame" select="$pgames/game[@round=current()/@id]"/>
	    <xsl:choose>
	      <xsl:when test="$pgame">

		<td class="{$pgame/@color}">
		  <xsl:choose>
		    <xsl:when test="$pgame/@color='white'">
		      <xsl:text>w</xsl:text>
		    </xsl:when>
		    <xsl:when test="$pgame/@color='black'">
		      <xsl:text>b</xsl:text>
		    </xsl:when>
		    <xsl:otherwise/>
		  </xsl:choose>
		  <xsl:call-template name="printscore">
		    <xsl:with-param name="mygame" select="$pgame"/>
		  </xsl:call-template>
		  <xsl:value-of select="exsl:node-set($playerranks)/playerrank[@id=$pgame/@oponent]/@rank"/>
		</td>

	      </xsl:when>
	      <xsl:otherwise>
		<td class="grey">-</td>
	      </xsl:otherwise>
	    </xsl:choose>

	  </xsl:for-each>
	</xsl:otherwise>
      </xsl:choose>

      <xsl:if test="/tournament/@pairing!=5 and /tournament/@pairing!=2">
	<!-- Game counts only for swiss tournaments -->
	<td class="number"><xsl:value-of select="count(games/game[@color='white'])"/></td>
	<td class="number"><xsl:value-of select="count(games/game[@color='black'])"/></td>
	<td class="summarynumber"><xsl:value-of select="count(games/game[@status='1'])"/></td>
      </xsl:if>
      <td class="number"><xsl:value-of select="perfrt"/></td>
      <td class="summarynumber"><xsl:value-of select="newrating"/></td>
      <xsl:if test="/tournament/@pairing!=5 and /tournament/@pairing!=2 and /tournament/@nmax">
	<td class="number"><xsl:value-of select="sum(games/game/@score)"/></td>
      </xsl:if>
      <td class="summarynumber"><xsl:value-of select="best8score"/></td>
    </xsl:element>
  </xsl:template>


</xsl:stylesheet>
