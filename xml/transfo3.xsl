<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:output 
              method="html"
                encoding="UTF-8"
                doctype-public="-//W3C//DTD HTML 4.01//EN"
                doctype-system="http://www.w3.org/TR/html4/strict.dtd"
                indent="yes" 
            />
<xsl:template match="/">
    <html>
        <head>
            <title>Extraction temps d'execution </title>
        </head>
        <body>
         <table border="1" width="400" cellspacing="1" style="border-collapse: collapse" >            
         <thead>
             <tr>
                 <th> Test </th> 
                 <th> Time </th> 
             </tr>
             </thead>
            <xsl:for-each select="Site/Testing/Test">
                <tr> 
                <xsl:if test="@Status = 'passed'">
                    <td><xsl:value-of select="Name" />  </td>
                    <xsl:for-each select="Results/NamedMeasurement">
                       <xsl:if test="@name = 'Execution Time'">
                           <td><xsl:value-of select="Value" /></td>
                       </xsl:if> 
                    </xsl:for-each>
              </xsl:if> 
              <xsl:if test="@Status = 'failed'"> 
              <td><xsl:value-of select="Name" /> </td>
              <td> FAILED </td>
                </xsl:if> 
            </tr>
            </xsl:for-each>
            </table>
        </body>
    </html>           
</xsl:template>
</xsl:stylesheet>
