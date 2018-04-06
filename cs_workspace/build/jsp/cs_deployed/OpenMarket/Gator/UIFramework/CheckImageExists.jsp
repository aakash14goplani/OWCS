<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/UIFramework/CheckImageExists
//
// INPUT Variables.Image
//
// OUTPUT Variables.Image is either unchanged if the image exists or it is set to Default.png
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.net.URL"%>


<cs:ftcs>

<%
String imgPath = ics.GetVar("Image");
if(imgPath!=null)
{
	int indexOfImagePath = imgPath.indexOf('/', 1);
	if(indexOfImagePath != -1)
	{
		imgPath = imgPath.substring(indexOfImagePath);
		URL imgUrl = config.getServletContext().getResource(imgPath);
		if(imgUrl==null)
		{
			ics.SetVar("Image",ics.GetVar("cs_imagedir")+"/OMTree/TreeImages/default.png");
		}
	}
}
%>

</cs:ftcs>