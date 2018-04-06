<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="device" uri="futuretense_cs/device.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%//
// avisports/Page/GoToMobileSiteLink
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
<%@ page import="com.fatwire.cs.core.mobility.device.DeviceGroup,com.fatwire.cs.core.mobility.device.Device" %>
<cs:ftcs>

<ics:if condition='<%=(ics.GetVar("d") == null) %>' >
<ics:then>
			<device:load name="device" />  
			<device:get name="device" property="suffix" output="d" />
</ics:then>
</ics:if>
<!-- If user is viewing this page from a mobile, show below link.  -->
<ics:if condition='<%=Utilities.goodString(ics.GetVar("d")) %>' >
<ics:then>
			
			<ics:callelement element="avisports/Page/GetHomePageID">
			<ics:argument name="siteplanname" value="Touch" />
			</ics:callelement>
			<render:callelement elementname="avisports/Page/DeviceLink" scoped="global" />
											
			<div align="center">						
			<a href="<%=ics.GetVar("pageUrl") %>"><xlat:stream key="dvin/UI/Mobility/MobileSite" /></a>
			</div>
								
</ics:then>
</ics:if>	

</cs:ftcs>