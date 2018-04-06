<%@page import="java.net.URLEncoder"%>
<%@page import="org.springframework.web.context.support.ServletContextResource"%>
<%@page import="java.io.File"%>
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
%>
<%@page import="java.util.Map"%>
<%@page import="java.util.concurrent.ConcurrentHashMap"%><cs:ftcs><%--

INPUT

OUTPUT

--%>
<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>
<%
Map<String, String> imageMap = (Map<String, String>) application.getAttribute("ImageMap");

if (imageMap == null)
{
	imageMap = new ConcurrentHashMap<String, String>();
	application.setAttribute("ImageMap", imageMap);
}
StringBuilder imagePath = new StringBuilder(ics.GetVar("cs_imagedir"));
String treeImagesDir = "/OMTree/TreeImages";
String assetType = ics.GetVar("AssetType");
assetType = assetType.replaceAll(" ","_");
String assetDef = ics.GetVar("AssetDef");
if(assetDef!=null)
	assetDef = assetDef.replaceAll(" ","_");
else
	assetDef ="";

if(imageMap.containsKey(assetType+"_"+assetDef))
{
	ics.SetVar("imageUsed",imageMap.get(assetType+"_"+assetDef));
}
else if(imageMap.containsKey(assetType))
{
	ics.SetVar("imageUsed",imageMap.get(assetType));
}

else
{
	imagePath = imagePath.append(treeImagesDir +"/AssetTypes/");
	int beginIndex = application.getContextPath().length() + 1 ;
	String tempPath = imagePath.toString() + assetType +"/" +assetType + "-" +assetDef+".png";
	ServletContextResource resource = new ServletContextResource(application, tempPath.substring(beginIndex));
	File file = resource.getFile();
	if(file.exists())
	{
		imageMap.put(assetType+"_"+assetDef, tempPath);
		application.setAttribute("ImageMap", imageMap);
		ics.SetVar("imageUsed",tempPath);
	}
	else
	{
		tempPath = imagePath.toString() + assetType + ".png";
		resource = new ServletContextResource(application, tempPath.substring(beginIndex));
		file = resource.getFile();
		if(file.exists())
		{
			imageMap.put(assetType,tempPath);
			application.setAttribute("ImageMap", imageMap);
			ics.SetVar("imageUsed",tempPath); 
		}
		else
		{
			ics.SetVar("imageUsed",ics.GetVar("cs_imagedir")+treeImagesDir+"/AssetTypes/Default.png");
		}
	}
}
%>
</cs:ftcs>