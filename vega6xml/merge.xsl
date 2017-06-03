<?xml version="1.0"?>

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
Creates SQL script populating the initial database, from tournamnents.xml
containing the data from all tournaments.
-->

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="text" indent="no"/>

  <xsl:template match="tournaments">
<xsl:text>CREATE TABLE tournament(_id INTEGER PRIMARY KEY,name STRING,startdate INTEGER, frequency INTEGER,type INTEGER,completed INTEGER);
CREATE TABLE player (_id INTEGER PRIMARY KEY,name TEXT UNIQUE,phone TEXT,cell TEXT,email TEXT);
CREATE TABLE playerrating(_id INTEGER PRIMARY KEY,playerid INTEGER,rating INTEGER,tournamentid INTEGER,date INTEGER, FOREIGN KEY(playerid) REFERENCES player(_id), FOREIGN KEY(tournamentid) REFERENCES tournament(_id));
CREATE TABLE game(tournamentid INTEGER,round INTEGER,date_scheduled INTEGER,date_complete INTEGER,white INTEGER,black INTEGER,result INTEGER,PRIMARY KEY (tournamentid,round,white,black),FOREIGN KEY (tournamentid) REFERENCES tournament(_id),FOREIGN KEY (white) REFERENCES player(_id),FOREIGN KEY (black) REFERENCES player(_id));
</xsl:text>
    <xsl:apply-templates select="tournament"/>
  </xsl:template>

  <xsl:template match="tournament">
    <xsl:variable name="tid" select="position()"/>
    <xsl:variable name="year" select="substring(./begindate,7,4)"/>
    <xsl:variable name="mon" select="substring(./begindate,4,2)"/>
    <xsl:variable name="dom" select="substring(./begindate,1,2)"/>
    <xsl:text>INSERT INTO tournament(_id,name,startdate,frequency,type) VALUES(</xsl:text>
    <xsl:value-of select="$tid"/><xsl:text>,'</xsl:text>
    <xsl:value-of select="@name"/><xsl:text>',</xsl:text>
    <xsl:value-of select="$dom"/><xsl:text>+100*(</xsl:text>
    <xsl:value-of select="$mon"/><xsl:text>+100*</xsl:text>
    <xsl:value-of select="$year"/><xsl:text>),0,</xsl:text>
    <xsl:value-of select="pairing"/><xsl:text>);
</xsl:text>

    <xsl:apply-templates select="players/player">
      <xsl:with-param name="tid" select="$tid"/>
      <xsl:with-param name="begindate" select="current()/begindate"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="rounds/round/game">
      <xsl:with-param name="tname" select="@id"/>
      <xsl:with-param name="tid" select="$tid"/>
      <xsl:with-param name="num" select="position()"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="players/player">
    <xsl:param name="tid"/>
    <xsl:param name="begindate"/>
    <xsl:variable name="year" select="substring($begindate,7,4)"/>
    <xsl:variable name="mon" select="substring($begindate,4,2)"/>
    <xsl:variable name="dom" select="substring($begindate,1,2)"/>
    <xsl:variable
	name="aboveplayer"
	select="(/tournaments/tournament[players/player/name=current()/name])[1]/@name"/>
    <xsl:if test="(false = starts-with(name,'BYE')) and $aboveplayer=../../@name">
      <xsl:text>INSERT INTO player(_id,name,phone,cell,email) VALUES(</xsl:text>
      <xsl:number level="any" count="players/player"/>
      <xsl:text>, '</xsl:text>
      <xsl:value-of select="name"/>
      <xsl:text>','','','');
INSERT INTO playerrating(playerid,rating,date) VALUES(</xsl:text>
      <xsl:number level="any" count="players/player"/>
      <xsl:text>,</xsl:text><xsl:value-of select="rating"/>
      <xsl:text>,</xsl:text><xsl:value-of select="$dom"/>
      <xsl:text>+100*(</xsl:text><xsl:value-of select="$mon"/>
      <xsl:text>+100*</xsl:text><xsl:value-of select="$year"/>
      <xsl:text>));
</xsl:text>
      </xsl:if>
  </xsl:template>

  <xsl:template match="rounds/round/game">
    <xsl:param name="tname"/>
    <xsl:param name="tid"/>
    <xsl:param name="num"/>
    <xsl:text>INSERT INTO game(tournamentid,round,white,black,result) VALUES(</xsl:text>
    <xsl:value-of select="$tid"/><xsl:text>,</xsl:text>
    <xsl:variable name="whiteid" select="player[@color='white']/@id"/>
    <xsl:variable
	name="whitename"
	select="/tournaments/tournament[@id=$tname]/players/player[@id=$whiteid]/name"/>

    <xsl:value-of select="../@id"/><xsl:text>,</xsl:text>
    <xsl:value-of select="$whitename"/><xsl:text>,
</xsl:text>
  </xsl:template>
</xsl:stylesheet>
