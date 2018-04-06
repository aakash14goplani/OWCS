<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld" %>

<%//
// UI/Layout/CenterPane/MobilityInsiteAction
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
<%@ page import="com.fatwire.mobility.beans.DeviceGroupBean"%>
<%@ page import="com.fatwire.mobility.beans.DeviceImageBean"%>
<%@ page import="com.openmarket.xcelerate.asset.SitePlanAsset"%>
<%@ page import="com.openmarket.xcelerate.site.Publication"%>
<%@ page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@ page import="javax.imageio.ImageIO, javax.swing.ImageIcon, java.awt.image.BufferedImage, java.net.URL, java.util.*"%>
<cs:ftcs>

<ics:callelement element="UI/Data/Carousel/SkinCarouselAction" />

<%
	List<DeviceImageBean> listDeviceImages = (List<DeviceImageBean>) request.getAttribute("listDeviceImages");
	
	if(listDeviceImages.size() > 0)
	{
		DeviceImageBean deviceImageBean = null;
		if (null == ics.GetVar("deviceImageId"))
		{
			deviceImageBean = listDeviceImages.get(0);
			for(int i = 0; i < listDeviceImages.size(); i++)
			{
				if(MobilityUtils.DESKTOP_DEVICEIMAGE_NAME.equalsIgnoreCase(listDeviceImages.get(i).getDeviceImageInfo().getDeviceImageName()))
				{
					deviceImageBean = listDeviceImages.get(i);
					break;
				}
			}
			//This is a hack for mobility beta. Ideally, we need not call this method, but we are doing so to get the pixelDimension of the device image. 
			deviceImageBean = MobilityUtils.getDeviceImage(ics, deviceImageBean.getDeviceImageInfo().getDeviceImageId());
		}
		else
			deviceImageBean = MobilityUtils.getDeviceImage(ics, Long.parseLong(ics.GetVar("deviceImageId")));		
		
		request.setAttribute("deviceImageBean", deviceImageBean);
		request.setAttribute("eligibleDevices", MobilityUtils.encodeCharAsHTML(new ObjectMapper().writeValueAsString(listDeviceImages)));
	}
%>

</cs:ftcs>
