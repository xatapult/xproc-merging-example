<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  exclude-result-prefixes="#all" expand-text="true">

  <xsl:mode on-no-match="shallow-copy"/>

  <xsl:param name="temps-filename" as="xs:string" required="yes"/>
  <xsl:param name="city-ids-filename" as="xs:string" required="yes"/>

  <xsl:template match="body">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:for-each select="doc($temps-filename)/*/citytemp">
        <xsl:variable name="city-id" as="xs:string" select="@id"/>
        <p>{doc($city-ids-filename)/*/city-id[@id eq $city-id]/@name}: {@temp}</p>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
