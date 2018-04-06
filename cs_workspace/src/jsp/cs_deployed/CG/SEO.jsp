<%@page import="java.net.URL"%>
<%@page import="java.io.InputStream"%>
<%@page import="org.apache.commons.io.IOUtils"%>
<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.lang.Math"%>
<cs:ftcs>
<%
try
{
	if (StringUtils.isNotEmpty(ics.GetVar("cgResourceId")) &&
		("wsdk.comments".equals(ics.GetVar("cgTagName")) || "wsdk.reviews".equals(ics.GetVar("cgTagName"))))
	{
		String urlStr = ics.GetVar("cgProductionUrl") + "/wsdk/" + ics.GetVar("cgTagName")
			+ "/plain.html?gateway=true&structure=1"
			+ "&site_id=" + ics.GetVar("cgSiteName")
			+ "&resource_id=" + ics.GetVar("cgResourceId");
    	
		if (request.getParameter("seoPageNo" + ics.GetVar("cgResourceId")) != null)
		{
			urlStr += "&page_number=" + request.getParameter("seoPageNo" + ics.GetVar("cgResourceId"));
		}
		
		URL url = new URL(urlStr);		  
		InputStream is = url.openStream();
		String str = IOUtils.toString(is, "UTF-8");
		
		ics.SetVar("cgContainerId", "communityGadgetContainer" + Math.random());
%>
<div id="<ics:getvar name="cgContainerId"/>" style="display:inline"><%=str%></div>
<script type="text/javascript">
	document.getElementById("<ics:getvar name="cgContainerId"/>").style.display='none';
</script>
<%
	}
}
catch(Exception e) { }
%>
</cs:ftcs>