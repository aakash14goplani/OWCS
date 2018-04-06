<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs><%--

- PreUpdate.xml
-
- DESCRIPTION
-
-    When a content category is created, edited, or copied,
-    this element is called before the database update
-    function is invoked.
-
-    This element is passed in an argument: 'updatetype'
-    whose value can drive special processing based
-    on the type of update
-
-    Documents expect to see the blob field which require
-    special handling
--%>

<%
	String updatetype = ics.GetVar("updatetype");
    ics.LogMsg("VAL, updatetype=" + updatetype);
	if("setformdefaults".equalsIgnoreCase(updatetype))
	{
	}
	else if("editfront".equalsIgnoreCase(updatetype))
	{
	}
	else if("edit".equalsIgnoreCase(updatetype))
	{
	}
	else if("create".equalsIgnoreCase(updatetype))
	{
	}
	else if("delete".equalsIgnoreCase(updatetype))
	{
	}
	else if("remotepost".equalsIgnoreCase(updatetype))
	{
	}
	else if("updatefrom".equalsIgnoreCase(updatetype))
	{
	}

%>
</cs:ftcs>
