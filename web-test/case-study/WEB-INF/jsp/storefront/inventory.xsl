<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
					   version="1.0">

	<xsl:template match="/">
 		<jsp:root xmlns:jsp="http://java.sun.com/jsp_1_2"
					 xmlns:html="html"> 

		<table border='1' cellpadding='5'>
			<th>Picture</th>
			<th>Item</th>
         <th>Description</th>
         <th>Price</th>
      	<xsl:apply-templates/>
		</table>
 		</jsp:root>
	</xsl:template>

   <xsl:template match="ITEM">
		<xsl:variable name='sku'>
			<xsl:value-of select='SKU'/>
		</xsl:variable>

		<xsl:variable name='name'>
			<xsl:value-of select='NAME'/>
		</xsl:variable>

		<xsl:variable name='description'>
			<xsl:value-of select='DESCRIPTION'/>
		</xsl:variable>

		<xsl:variable name='price'>
			<xsl:value-of select='PRICE'/>
		</xsl:variable>

		<tr><td>
<xsl:value-of select="$sku"/>
<xsl:value-of select="$name"/>
<xsl:value-of select="$price"/>
		</td>
		<td><xsl:value-of select='$name'/></td>
		<td><xsl:value-of select='$description'/></td>
		<td><xsl:value-of select='$price'/></td>
		<td>
			<form action='add-selection-to-cart-action.do'>
				<html:links name='{$sku}.{$name}'>
					<option value='00'>0.00</option>
					<option value='0.25'>0.25</option>
					<option value='0.50'>0.50</option>
					<option value='0.75'>0.75</option>
					<option value='1.00'>1.00</option>
				</html:links>
			</form>
		</td>
		</tr>
		
   </xsl:template>

</xsl:stylesheet>
