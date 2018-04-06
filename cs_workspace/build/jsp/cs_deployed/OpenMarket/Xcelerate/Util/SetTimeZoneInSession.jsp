<%@page import="oracle.fatwire.sites.timezone.TimeZoneDetectorFactory"%>
<%@page import="oracle.fatwire.sites.timezone.TimeZoneDetector"%>
<%@page import="java.util.TimeZone"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="ccuser" uri="futuretense_cs/ccuser.tld"
%><%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs><%--

INPUT

OUTPUT

--%>

<%

	TimeZone tz = null;
	%>
	<usermanager:getloginusername varname="loggedInUsername" />
	<usermanager:getuserfromname username='<%=ics.GetVar("loggedInUsername")%>' objvarname="loggedInUserObj" />
	<ccuser:gettimezone name="loggedInUserObj" varname="userPreferedTz"/><%
	if(Utilities.goodString(ics.GetVar("userPreferedTz")))
	{
		tz=TimeZone.getTimeZone( ics.GetVar("userPreferedTz") );
		ics.SetSSVar("time.zone", tz.getID());
	}
	else 
	{
 %>
<ics:callelement element="OpenMarket/Xcelerate/Util/GenerateTimeZoneData"/>
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Util/SetTimeZoneInSession" outstring="setTimeZoneURL"/>

<%
		if(!Utilities.goodString(ics.GetVar("timeZoneJson")))
		{
%>
			<script>
				var xhrArgs = {
						<% 
						if(session.getAttribute("X-CSRF-Token") != null){
						%>
							headers: {
									'X-CSRF-Token' : '<%=session.getAttribute("X-CSRF-Token")%>'
							} ,
						<%	  
						}
						%>
			            url: '<%=ics.GetVar("setTimeZoneURL")%>',
					content: {"timeZoneJson": getTimeZoneJson()},
				      handleAs: "text",
					sync: true,
			      	error: function(error){
				      }
				    };
			    var deferred = dojo.xhrPost(xhrArgs);
			    
			</script>
<%
		}
		else
		{
			if (request.getMethod().equalsIgnoreCase("POST"))
			{
				try
				{
					TimeZoneDetector d = TimeZoneDetectorFactory.getDetector(ics.GetVar("timeZoneJson"));
					tz = d.getTimeZone();
					
				}
				catch(Exception e)
				{
					
					tz = TimeZone.getDefault();
				}
				ics.SetSSVar("time.zone", tz.getID());
			}
		}
	}

 %>
</cs:ftcs>