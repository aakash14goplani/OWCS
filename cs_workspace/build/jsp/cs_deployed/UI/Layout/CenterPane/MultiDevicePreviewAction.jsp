<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld" %>

<%//
// UI/Layout/CenterPane/MultiDevicePreviewAction
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
<%@ page import="com.openmarket.xcelerate.asset.DeviceGroup"%>
<%@ page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@ page import="javax.imageio.ImageIO, javax.swing.ImageIcon, java.awt.Image, java.net.URL, java.util.*"%>
<cs:ftcs>

<%
	List<DeviceImageBean> listDeviceImages = new ArrayList<DeviceImageBean>();
	List<DeviceGroupBean> deviceGroupList = new ArrayList<DeviceGroupBean>();
	SitePlanAsset spAsset = MobilityUtils.getSiteplanForAsset(ics, ics.GetVar("c"), Long.parseLong(ics.GetVar("cid")));
	
	if(null != spAsset)
		deviceGroupList = MobilityUtils.getDeviceGroupsForSiteplan(ics, Long.parseLong(spAsset.Get(MobilityUtils.ATTR_SITEPLAN_ID)));
	else
		deviceGroupList = MobilityUtils.getDeviceGroups(ics);
	
	if (Utilities.goodString(ics.GetVar("devicegroup")))
		listDeviceImages = MobilityUtils.getDeviceImages(ics, DeviceGroup.STANDARD_TYPE_NAME, Long.parseLong(ics.GetVar("devicegroup")));
	else
	{
		if(deviceGroupList.size() > 0)
		{
			int i = deviceGroupList.size() - 1;
			for (; i >= 0; i--)	
			{
				listDeviceImages = MobilityUtils.getDeviceImages(ics, DeviceGroup.STANDARD_TYPE_NAME, deviceGroupList.get(i).getId());
				if (listDeviceImages.size() > 0)
					break;
			}
			ics.SetVar("devicegroup", String.valueOf(deviceGroupList.get(i).getId()));
		}
		else
			ics.RemoveVar("devicegroup");
	}
		
	request.setAttribute("devicegroup", ics.GetVar("devicegroup"));
	request.setAttribute("listDeviceImages", listDeviceImages);
	request.setAttribute("deviceGroupList", deviceGroupList);
%>

</cs:ftcs>
