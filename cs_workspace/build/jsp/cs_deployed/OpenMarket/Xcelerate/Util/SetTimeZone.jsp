<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="date" uri="futuretense_cs/date.tld" %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet"%>
<%//
// OpenMarket/Xcelerate/Util/SetTimeZone
//
// INPUT
//
// OUTPUT
// This element is used to set the clienttimezoneoffset in user session it is called by
// OpenMarket/Flame/Common/UIFramework/PortletCSFormMode
// This element is to set the Client Time zone in case of portal
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%> 
<cs:ftcs>
<satellite:link assembler="query" outstring="showContentURL" container="servlet">
	 <satellite:argument name="pagename" value="OpenMarket/Xcelerate/Util/SetTimeZoneSession"/>
</satellite:link>
<% if (ics.GetSSVar("clientTimezoneOffset")==null) { %>
<SCRIPT>
		       var <portlet:namespace/>_offset=<portlet:namespace/>_getClientOffset();
			   function <portlet:namespace/>_getClientOffset() {
				var curdate = new Date() ;
				var offset = curdate.getTimezoneOffset();
				var finaloffset = "";
				if (offset >= 0) {
					finaloffset = finaloffset+"-";
				} else {
					finaloffset = finaloffset+"+";
				}
				var newoffset=offset;
				var lstr=newoffset.length;
				newoffset=newoffset+'';
				if (newoffset.indexOf("-")>=0)
				offset=newoffset.substring(1,lstr);
				var x = parseInt(offset/600);
				finaloffset=finaloffset+x;
				offset=offset-(x*600);
				x=parseInt(offset/60);
				finaloffset=finaloffset+x;
				offset=offset-(x*60);
				finaloffset=finaloffset+":";
				x = parseInt(offset/10);
				finaloffset=finaloffset+x;
				offset =offset-(x*10);
				finaloffset=finaloffset+offset;
				if (finaloffset.indexOf("+")>=0)
				   {
				    finaloffset=finaloffset.substring(1,finaloffset.length);
					finaloffset="%2B"+finaloffset;
				   }
				return finaloffset;
			}

document.write("<img src=\"<%=ics.GetVar("showContentURL")%>&#38;clientTimezoneOffset="+<portlet:namespace/>_offset+"\" height=1 width=1 />");
</SCRIPT>

<% } %>

</cs:ftcs>






