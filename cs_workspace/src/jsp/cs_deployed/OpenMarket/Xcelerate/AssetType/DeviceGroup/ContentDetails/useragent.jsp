<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/DeviceGroup/ContentDetails/useragent
// 
// INPUT
// 
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<div name="criteriaSection" style="border: 1px solid #d9d7d3;border-radius: 4px;">
    <div style="padding-left: 8px;padding-top: 5px; padding-bottom: 5px">
    
    <%
		String userAgent = ics.GetVar("fieldvalue");
		if( Utilities.goodString( userAgent ))
		{
			if(!Utilities.goodString( ics.GetVar("ContentDetails:devicenamelist")))
			{
			%>
         		<%=ics.GetVar("fieldvalue")%>
         	<%
			}
			else
			{
         	%>
	        	<span class="disabledText">
	         		<%=ics.GetVar("fieldvalue")%>
	         	</span>
         	<%
			}
         } 
		else
		{
         %>
        	 <span class="disabledText"><xlat:stream key="UI/Forms/NotApplicable"/></span>
         <%
         } 
         %>
    </div>
	
</div>
</cs:ftcs>