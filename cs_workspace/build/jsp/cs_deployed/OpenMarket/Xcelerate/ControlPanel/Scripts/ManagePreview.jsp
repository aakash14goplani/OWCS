<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld" 

%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" 

%><%
//
// OpenMarket/Xcelerate/ControlPanel/Scripts/ManagePreview
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><cs:ftcs><%
String mode = ics.GetVar("mode");
if (mode == null) mode = "preview";
%>
<html>
	<head>    
		<script type="text/javascript" >
			<ics:callelement element="OpenMarket/Xcelerate/ControlPanel/Scripts/Ajax"/>
			<ics:callelement element="OpenMarket/Xcelerate/ControlPanel/Scripts/RequestEngine" />
			<ics:callelement element="OpenMarket/Xcelerate/ControlPanel/Scripts/PreviewHelper">	
				<%if(ics.GetVar("wem") != null) {%>
				<ics:argument name="wem" value='<%=ics.GetVar("wem")%>' />
				<%}%>
			</ics:callelement>
		</script>
		<script type="text/javascript" src='<%=ics.GetProperty("ft.cgipath")+"js/dojo/dojo.js"%>' djConfig="debugAtAllCosts: false, isDebug: true, parseOnLoad: true"></script>
	</head>
	<body>
<!-- sample data -->
 	  
	</body>
</html> 
</cs:ftcs>
