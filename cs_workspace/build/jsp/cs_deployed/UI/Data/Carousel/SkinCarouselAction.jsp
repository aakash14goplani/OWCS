<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld" %>

<%//
// UI/Data/Carousel/SkinCarouselAction
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
<%@ page import="com.fatwire.mobility.util.MobilityUtils"%>
<%@ page import="com.fatwire.mobility.beans.SkinInfoBean"%>
<%@ page import="com.fatwire.mobility.beans.DeviceImageBean"%>
<%@ page import="com.fatwire.mobility.beans.DeviceGroupBean"%>
<%@ page import="com.openmarket.xcelerate.asset.SitePlanAsset"%>
<%@ page import="com.openmarket.xcelerate.site.Publication"%>
<%@ page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@ page import="javax.imageio.ImageIO, javax.swing.ImageIcon, java.awt.Image, java.net.URL, java.util.*"%>
<cs:ftcs>

<%
	List<DeviceImageBean> listDeviceImages = new ArrayList<DeviceImageBean>();
	SitePlanAsset spAsset = null;
	// Incase new asset is created, cid is null
	if(Utilities.goodString(ics.GetVar("cid"))){
		spAsset = MobilityUtils.getSiteplanForAsset(ics, ics.GetVar("c"), Long.parseLong(ics.GetVar("cid")));
	}
	String sAssetType = (null != spAsset) ? SitePlanAsset.STANDARD_TYPE_NAME: Publication.STANDARD_TYPE_NAME;
	Long sAssetId = (null != spAsset) ? Long.parseLong(spAsset.Get("id")): 1L;

	listDeviceImages = MobilityUtils.getDeviceImages(ics, sAssetType, sAssetId);	
	
	request.setAttribute("listDeviceImages", listDeviceImages);
%>
</cs:ftcs>