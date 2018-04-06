<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<cs:ftcs>


<%     
	/*   
		 Call to filter/encode all request Input Parameter Strings  
         EncodeParameters can have a list of input parameters that can 
         be exclude from encoding and/or cleaned. "Delimited by a comma" 
         Must not encode / clean browseURL parameter value for the 
         following parameters. 
          1. displayData 
          2. browseUrl 
          3. attributes
       */
%>
 

<ics:callelement element="UI/Utils/encodeParameters">
	<ics:argument name="excludeParametersLst" value="attributes,displayData,browseUrl"/>
</ics:callelement>
 
</cs:ftcs>