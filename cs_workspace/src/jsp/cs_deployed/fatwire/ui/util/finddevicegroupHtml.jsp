<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// fatwire/ui/util/finddevicegroupHtml
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

<!-- user code here -->
<form action="<%=request.getContextPath()%>/ContentServer" name="sample" method="post">
<br/>

User Agent:  <input type="text"  size="100" name="agent" />  <br/>

What you are looking for Device:  <input type="radio" name="what" value="device" />
Device Group <input type="radio" name="what" value="devicegroup" checked />
<input type="hidden" name="pagename"  value="fatwire/ui/controller/controller" /> 
<input type="hidden" name="elementName"  value="fatwire/ui/util/finddevicegroup" /> 
<br/>
<input type="submit" >

</form> 
</cs:ftcs>