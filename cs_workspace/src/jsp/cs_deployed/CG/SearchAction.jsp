<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@page import="com.fatwire.assetapi.data.ExternalResourceMap" %>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.apache.commons.io.IOUtils"%>
<%@page import="org.codehaus.jettison.json.JSONArray"%>
<%@page import="org.codehaus.jettison.json.JSONObject"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.sun.jersey.api.client.*" %>
<%@page import="com.sun.jersey.api.client.config.*" %>
<%@page import="java.util.*"%>
<%@page import="com.fatwire.system.*"%>
<%@page import="com.fatwire.assetapi.data.*"%>
<%@page import="com.fatwire.assetapi.query.*"%>
<%@page import="com.openmarket.xcelerate.asset.*"%>
<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<cs:ftcs>
<ics:callelement element="CG/GetPermission"/>
<ics:callelement element="CG/GetMultiTicket"/>
<ics:callelement element="CG/GetParameters"/>
<%
try
{
	if (StringUtils.isNotEmpty(ics.GetVar("cgManagementUrl"))
		&& ics.GetVar("user-access-is-granted") != null)
	{
		String urlStr = ics.GetVar("cgManagementUrl") + "/rest/sites/search/" + ics.GetVar("cgAssetType")
		    	+ "?site_id=" + ics.GetVar("cgSiteName")
		    	+ "&locale=" + ics.GetVar("cgLocale")
	    		+ "&start=" + ((ics.GetVar("start")!=null)?ics.GetVar("start"):"0")
		    	+ "&count=" + ((ics.GetVar("count")!=null)?ics.GetVar("count"):"10")
		    	+ "&sort=" + ((ics.GetVar("sort")!=null)?ics.GetVar("sort"):"")
	    		+ "&searchText=" + URLEncoder.encode(((ics.GetVar("searchText")!=null)?ics.GetVar("searchText"):""))
				+ "&parent_widget=" + ics.GetVar("cgParentWidget")
				+ "&gateway=true"
				+ "&multiticket=" + ics.GetVar("cgMultiTicket");

		Client client = Client.create();
      	WebResource resource = client.resource(urlStr);
		ClientResponse clientResponse = resource.accept("application/json").get(ClientResponse.class);
		if (clientResponse.getStatus() != 200)
		{
			throw new RuntimeException("Failed getting response: " + clientResponse.getStatus());
		}
		
		JSONObject json = new JSONObject(clientResponse.getEntity(String.class));
		JSONArray resultList = new JSONArray();

		if (json.opt("status").equals("success") && json.has("items"))
		{
			JSONArray list = json.optJSONArray("items");
			if (list == null)
			{
				list = new JSONArray();
				list.put(json.getJSONObject("items"));
			}

			for (int i = 0; i < list.length(); i++)
			{
				JSONObject item = (JSONObject)list.get(i);
				JSONObject asset = item.getJSONObject("asset");

				String sInternalId = ProxyAssetType.getID(ics, asset.optString("type"), asset.optString("id"));
				AssetId internalId = null;
				if (sInternalId != null)
				{
					internalId = new AssetIdImpl(asset.optString("type"), Long.valueOf(sInternalId));
				}
				if (internalId == null)
				{
				    int maxNameLength = 64;
				    String name = (item.optString("name").length() < maxNameLength)
				            ? item.optString("name")
				            : item.optString("name").substring(0, maxNameLength);
					Session sess = SessionFactory.getSession();
					AssetDataManager assetDataManager = (AssetDataManager) sess.getManager(AssetDataManager.class.getName());
					MutableAssetData assetData = assetDataManager.newAssetData(asset.optString("type"), "");
					assetData.getAttributeData("name").setData(name);
					assetData.getAttributeData("externalid").setData(asset.optString("id"));
					assetData.getAttributeData("Publist").setData(Arrays.asList(ics.GetVar("cgSiteName")));
					assetDataManager.insert(Arrays.<AssetData>asList(assetData));
					internalId = assetData.getAssetId();
				}
				asset.put("id", String.valueOf(internalId.getId()));
				
				item.put("fwlink", true);
				
				JSONObject result = new JSONObject();
				result.put("displayData", item.getJSONArray("displayData"));
				resultList.put(item);
			}					
		}
		
		JSONObject store = new JSONObject();
		store.put("identifier", json.optString("identifier", "id"));
		store.put("numRows", Integer.parseInt(json.optString("numRows", "0")));
		store.put("items", resultList);
		request.setAttribute("results", store);	
	}
}
catch (Exception e)
{
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%>
</cs:ftcs>




