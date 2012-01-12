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
    Transforms tournament.xml to players.xml
    players.xsl contains: list of all players
    with all their games, and rating information. Rating adjustments are
    calculated based on CFC rules for established players.
-->
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl">

  <xsl:output method="xml" indent="yes"/>

  <xsl:param name="nmax">
    <xsl:choose>
      <!-- Swiss Lim pairing is max8 -->
      <xsl:when test="/tournament/pairing=7">8</xsl:when>
      <xsl:otherwise>9999</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <!--tournament id="{@id}" name="{@name}" nmax="{$nmax}" pairing="{pairing}"-->
  <xsl:template match="tournament">
    <xsl:element name="tournament">
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
      <xsl:attribute name="pairing"><xsl:value-of select="pairing"/></xsl:attribute>
      <xsl:if test="$nmax != 9999">
	<xsl:attribute name="nmax">
	  <xsl:value-of select="$nmax"/>
	</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- no output for these elements -->
  <xsl:template match="city"/>
  <xsl:template match="pairing"/>
  <xsl:template match="begindate"/>
  <xsl:template match="enddate"/>

  <xsl:template match="pgnfiles">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="players">
    <players>
      <xsl:apply-templates/>
    </players>
  </xsl:template>

  <xsl:template name="perfrt">
    <xsl:param name="games"/>
    <xsl:variable name="gamesPlayed" select="count($games)"/>
    <xsl:variable name="sumOpRat" select="sum($games/@oponentrating)"/>
    <xsl:variable name="wins" select="count($games[@score='1'])"/>
    <xsl:variable name="losses" select="count($games[@score='0'])"/>
    <xsl:value-of select="round(($sumOpRat + 400 * ($wins - $losses)) div $gamesPlayed)"/>
  </xsl:template>

  <xsl:template name="newrt">
    <xsl:param name="games"/>
    <xsl:param name="oldrating"/>
    <xsl:value-of select="round($oldrating + 32 * (sum($games/@score)-sum($games/@expectscore)))"/>
  </xsl:template>

  <xsl:template name="expectresult">
    <xsl:param name="ratingdiff"/>
    <xsl:variable name="absdiff">
      <xsl:choose>
	<xsl:when test="$ratingdiff &gt; 0">
	  <xsl:value-of select="$ratingdiff"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="-$ratingdiff"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="absscore">
      <xsl:choose>
	<xsl:when test="$absdiff &lt; 3+1">0.50</xsl:when>
	<xsl:when test="$absdiff &lt; 3+1">0.50</xsl:when>
	<xsl:when test="$absdiff &lt; 10+1">0.51</xsl:when>
	<xsl:when test="$absdiff &lt; 17+1">0.52</xsl:when>
	<xsl:when test="$absdiff &lt; 25+1">0.53</xsl:when>
	<xsl:when test="$absdiff &lt; 32+1">0.54</xsl:when>
	<xsl:when test="$absdiff &lt; 39+1">0.55</xsl:when>
	<xsl:when test="$absdiff &lt; 46+1">0.56</xsl:when>
	<xsl:when test="$absdiff &lt; 53+1">0.57</xsl:when>
	<xsl:when test="$absdiff &lt; 61+1">0.58</xsl:when>
	<xsl:when test="$absdiff &lt; 68+1">0.59</xsl:when>
	<xsl:when test="$absdiff &lt; 76+1">0.60</xsl:when>
	<xsl:when test="$absdiff &lt; 83+1">0.61</xsl:when>
	<xsl:when test="$absdiff &lt; 91+1">0.62</xsl:when>
	<xsl:when test="$absdiff &lt; 98+1">0.63</xsl:when>
	<xsl:when test="$absdiff &lt; 106+1">0.64</xsl:when>
	<xsl:when test="$absdiff &lt; 113+1">0.65</xsl:when>
	<xsl:when test="$absdiff &lt; 121+1">0.66</xsl:when>
	<xsl:when test="$absdiff &lt; 129+1">0.67</xsl:when>
	<xsl:when test="$absdiff &lt; 137+1">0.68</xsl:when>
	<xsl:when test="$absdiff &lt; 145+1">0.69</xsl:when>
	<xsl:when test="$absdiff &lt; 153+1">0.70</xsl:when>
	<xsl:when test="$absdiff &lt; 162+1">0.71</xsl:when>
	<xsl:when test="$absdiff &lt; 170+1">0.72</xsl:when>
	<xsl:when test="$absdiff &lt; 179+1">0.73</xsl:when>
	<xsl:when test="$absdiff &lt; 188+1">0.74</xsl:when>
	<xsl:when test="$absdiff &lt; 197+1">0.75</xsl:when>
	<xsl:when test="$absdiff &lt; 206+1">0.76</xsl:when>
	<xsl:when test="$absdiff &lt; 215+1">0.77</xsl:when>
	<xsl:when test="$absdiff &lt; 225+1">0.78</xsl:when>
	<xsl:when test="$absdiff &lt; 235+1">0.79</xsl:when>
	<xsl:when test="$absdiff &lt; 245+1">0.80</xsl:when>
	<xsl:when test="$absdiff &lt; 256+1">0.81</xsl:when>
	<xsl:when test="$absdiff &lt; 267+1">0.82</xsl:when>
	<xsl:when test="$absdiff &lt; 278+1">0.83</xsl:when>
	<xsl:when test="$absdiff &lt; 290+1">0.84</xsl:when>
	<xsl:when test="$absdiff &lt; 302+1">0.85</xsl:when>
	<xsl:when test="$absdiff &lt; 315+1">0.86</xsl:when>
	<xsl:when test="$absdiff &lt; 328+1">0.87</xsl:when>
	<xsl:when test="$absdiff &lt; 344+1">0.88</xsl:when>
	<xsl:when test="$absdiff &lt; 357+1">0.89</xsl:when>
	<xsl:when test="$absdiff &lt; 374+1">0.90</xsl:when>
	<xsl:when test="$absdiff &lt; 391+1">0.91</xsl:when>
	<xsl:when test="$absdiff &lt; 411+1">0.92</xsl:when>
	<xsl:when test="$absdiff &lt; 432+1">0.93</xsl:when>
	<xsl:when test="$absdiff &lt; 456+1">0.94</xsl:when>
	<xsl:when test="$absdiff &lt; 484+1">0.95</xsl:when>
	<xsl:when test="$absdiff &lt; 517+1">0.96</xsl:when>
	<xsl:when test="$absdiff &lt; 559+1">0.97</xsl:when>
	<xsl:when test="$absdiff &lt; 619+1">0.98</xsl:when>
	<xsl:when test="$absdiff &lt; 734+1">0.99</xsl:when>
	<xsl:otherwise>1.00</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$ratingdiff &gt; 0">
	<xsl:value-of select="$absscore"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="format-number(1 - $absscore,'0.00')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="player">
    <xsl:variable name="id" select="@id"/>
    <xsl:variable name="rating" select="rating"/>

      <xsl:variable name="games">
	<xsl:for-each select="../../rounds/round">
	  <xsl:variable name="pgame" select="game/player[@id=$id]"/>
	  <xsl:choose>
	    <xsl:when test="$pgame">
	      <xsl:variable
		  name="oponentrating"
		  select="/tournament/players/player[@id=$pgame/@oponent]/rating"/>
	      <xsl:variable name="expectresult">
		<xsl:call-template name="expectresult">
		  <xsl:with-param name="ratingdiff" select="$rating - $oponentrating"/>
		</xsl:call-template>
	      </xsl:variable>
	      <game round="{@id}"
		    status="{$pgame/../@status}"
		    oponent="{$pgame/@oponent}"
		    oponentrating="{$oponentrating}"
		    color="{$pgame/@color}"
		    score="{$pgame/@score}"
		    expectscore="{$expectresult}"/>
	    </xsl:when>
	    <!-- bye in round-robin -->
	    <!--xsl:when test="bye[@playerid=$id]">
	      <game round="{@id}"
		    status="2"
		    oponent="-1"
		    oponentrating="0"
		    color="grey"
		    score="0"
		    expectscore="0"/>
	    </xsl:when-->
	    <!-- bye in swiss -->
	    <xsl:otherwise>
	      <game round="{@id}"
		    status="2"
		    oponent="0"
		    oponentrating="0"
		    color="grey"
		    score="0"
		    expectscore="0"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:for-each>
      </xsl:variable>

      <xsl:if test="/tournament/pairing=5 or count(exsl:node-set($games)/game[@status!=2]) != '0'">
	<player id="{@id}">

	  <xsl:copy-of select="name"/>
	  <xsl:copy-of select="rating"/>

	  <xsl:variable name="bestgames">
	    <!-- skip only adjourned games -->
	    <xsl:for-each select="exsl:node-set($games)/game[@status!='0']">
	      <xsl:sort
		  select="@oponentrating" order="descending" data-type="number"/>
	      <xsl:sort select="@score" order="descending" data-type="number"/>
	      <xsl:copy-of select="."/>
	    </xsl:for-each>
	  </xsl:variable>

	  <games>
	    <xsl:copy-of select="$games"/>
	  </games>

	  <best8score>
	    <xsl:value-of select="sum(exsl:node-set($bestgames)/game[position() &lt; $nmax+1]/@score)"/>
	  </best8score>
	  <weakest8oponent>
	    <xsl:choose>
	      <xsl:when test="count(exsl:node-set($bestgames)/game) &gt; $nmax">
		<xsl:value-of select="exsl:node-set($bestgames)/game[position()=$nmax]/@oponentrating"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:text>0</xsl:text>
	      </xsl:otherwise>
	    </xsl:choose>
	  </weakest8oponent>

	  <newrating>
	    <xsl:call-template name="newrt">
	      <xsl:with-param name="games" select="exsl:node-set($bestgames)/game[@status='1']"/>
	      <xsl:with-param name="oldrating" select="rating"/>
	    </xsl:call-template>
	  </newrating>

	  <perfrt>
	    <xsl:call-template name="perfrt">
	      <xsl:with-param name="games" select="exsl:node-set($bestgames)/game[@status='1']"/>
	    </xsl:call-template>
	  </perfrt>

	</player>
      </xsl:if>
  </xsl:template>

  <xsl:template match="rounds"><xsl:copy-of select="."/></xsl:template>

</xsl:stylesheet>
