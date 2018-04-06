<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/Device/ContentForm/height
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
<%@ page import="javax.imageio.ImageIO, javax.swing.ImageIcon, java.awt.Image, java.net.URL, java.util.*"%>
<%@ page import="org.apache.commons.logging.Log,org.apache.commons.logging.LogFactory" %>
<cs:ftcs>
<% 
Log log = LogFactory.getLog("com.fatwire.logging.cs.mobility");
if (Utilities.goodString(ics.GetVar("id"))) { %>
<render:getbloburl outstr="myURL" c="Device" field="urlimage" blobkey="id" cid='<%=ics.GetVar("id")%>' blobheader="image/png"/>
<%
if(ics.GetVar("myURL") != null)
{
URL url = new URL(request.getScheme(),request.getServerName(),request.getServerPort(),ics.GetVar("myURL"));
Image image = ImageIO.read(url);
int imgHeight = 0;
int imgWidth = 0;

if (image != null) {
	try{   //Fix for bug 16744374. On headless servers, with no graphic cards etc available to support AWT, blobHeight and blobWidth can not be calculated.
		ImageIcon icon = new ImageIcon(image);
		imgHeight = icon.getIconHeight();
		imgWidth = icon.getIconWidth();
		}
	catch(Exception e)
	{
	log.error("Exception while loading the Device Image: "+e.getMessage());
	}
}
if(imgHeight > 0 && imgWidth > 0)
{
%>

<INPUT TYPE="hidden" NAME="blobHeight" id="blobHeight" VALUE='<%=String.valueOf(imgHeight)%>' />
<INPUT TYPE="hidden" NAME="blobWidth" id="blobWidth" VALUE='<%=String.valueOf(imgWidth)%>' />
<%
}
}
}
%>
<INPUT TYPE="text" NAME='<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>' ID='<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>' SIZE="6" VALUE='<%=ics.GetVar("fieldvalue")%>' onkeyup="valueChanged(event,'<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>','<%=ics.GetVar("urlblobserver")%>')"  /><xlat:lookup key="dvin/UI/MobilitySolution/ScreenDimensions/inPixels" varname="alttext"/><IMG style="vertical-align: middle; margin-left: 10px;" SRC='<%=ics.GetVar("cs_imagedir")+"/graphics/common/icon/help_new.png"%>' ALT='<%=ics.GetVar("alttext")%>'  TITLE='<%=ics.GetVar("alttext")%>' />

			
</cs:ftcs>