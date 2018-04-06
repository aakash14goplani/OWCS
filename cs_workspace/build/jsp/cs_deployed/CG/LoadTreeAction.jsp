<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@page import="com.fatwire.assetapi.data.ExternalResourceMap" %>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.io.InputStream" %>
<%@page import="java.net.URL" %>
<%@page import="org.apache.commons.io.IOUtils" %>
<%@page import="org.codehaus.jettison.json.JSONArray" %>
<%@page import="org.codehaus.jettison.json.JSONObject" %>
<%@page import="com.fatwire.services.beans.entity.TreeNodeBean" %>
<%@page import="com.fatwire.cs.ui.framework.UIException" %>
<%@page import="java.util.*" %>
<%@page import="com.fatwire.system.*"%>
<%@page import="com.fatwire.assetapi.data.*"%>
<%@page import="com.fatwire.assetapi.query.*"%>
<%@page import="com.openmarket.xcelerate.asset.*"%>
<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%@taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<cs:ftcs>
<xlat:lookup key="CG/AccessDenied" escape="true" varname="accessDenied"/>
<ics:callelement element="CG/GetPermission"/>
<ics:callelement element="CG/GetMultiTicket"/>
<ics:callelement element="CG/GetParameters"/>
<%
try
{
	List<TreeNodeBean> treeList = new ArrayList<TreeNodeBean>();
	if (ics.GetVar("user-access-is-granted") != null)
	{
		String loadUrl = (String)request.getParameter("loadUrl");
      	URL url = "init".equals(loadUrl)
		    	? new URL(ics.GetVar("cgManagementUrl") + "/rest/sites/tree/CGWidget"
		     	  	+ "?site_id=" + ics.GetVar("cgSiteName")
		        	+ "&locale=" + ics.GetVar("cgLocale")
		        	+ "&start=" + ((ics.GetVar("start")!=null)?ics.GetVar("start"):"0")
			    	+ "&count=" + ((ics.GetVar("count")!=null)?ics.GetVar("count"):"10")
			    	+ "&sort=" + ((ics.GetVar("sort")!=null)?ics.GetVar("sort"):"")
		    		+ "&searchText=" +  URLEncoder.encode(((ics.GetVar("searchText")!=null)?ics.GetVar("searchText"):""))
					+ "&gateway=true"
        			+ "&multiticket=" + ics.GetVar("cgMultiTicket"))
		    	: new URL(loadUrl);
    
	    InputStream is = url.openStream();
      	String str = IOUtils.toString(is, "UTF-8");
	    JSONObject resp = new JSONObject(str);
	
		if (resp.optString("status").equals("success"))
		{
			JSONArray items = resp.optJSONArray("items");
			if(null == items)
			{
				items = new JSONArray();
				items.put(resp.getJSONObject("items"));
			}
		
			Session sess = SessionFactory.getSession();
			AssetDataManager assetDataManager = (AssetDataManager) sess.getManager(AssetDataManager.class.getName());

    		
			for (int i = 0; i < items.length(); i++)
			{
				JSONObject obj = items.getJSONObject(i);
				TreeNodeBean bean = new TreeNodeBean();
				bean.setName(obj.optString("name"));
				bean.setNodeId(obj.optString("nodeId"));
				bean.setNodeType(obj.optString("nodeType"));
				bean.setLoadUrl(obj.optString("loadUrl"));
				bean.setIconUrl(obj.optString("iconUrl"));
				if (obj.optString("children").equals("true"))
				{
					bean.setChildren(obj.optString("children"));
				}
				bean.setId(obj.optString("id"));
				bean.setType(obj.optString("type"));
				bean.setAssetType(obj.optString("assetType"));
				bean.setSubtype(obj.optString("subtype"));
				bean.setOkFunctions(obj.optString("OkFunctions"));
				bean.setExecuteFunction(obj.optString("executeFunction"));
				bean.setOkAction(obj.optString("okAction"));
				bean.setBrowseUrl(obj.optString("browseUrl"));
			
				treeList.add(bean);
				
				String sInternalId = ProxyAssetType.getID(ics, bean.getAssetType(), bean.getId());
				AssetId internalId = null;
				if (sInternalId != null)
				{
					internalId = new AssetIdImpl(bean.getAssetType(), Long.valueOf(sInternalId));
				}
				if (internalId == null)
				{
				    int maxNameLength = 64;
				    String name = (bean.getName().length() < maxNameLength)
				            ? bean.getName()
				            : bean.getName().substring(0, maxNameLength);
					MutableAssetData assetData = assetDataManager.newAssetData(bean.getAssetType(), "");
					assetData.getAttributeData("name").setData(name);
					assetData.getAttributeData("externalid").setData(bean.getId());
					assetData.getAttributeData("Publist").setData(Arrays.asList(ics.GetVar("cgSiteName")));
					assetDataManager.insert(Arrays.<AssetData>asList(assetData));
					internalId = assetData.getAssetId();
				}
				bean.setId(String.valueOf(internalId.getId()));
			}
		}
		else
		{
			TreeNodeBean bean = new TreeNodeBean();
	       	bean.setName(resp.optString("message"));
      	  	bean.setNodeId("errorMessageId");
			treeList.add(bean);
		}
	}
	else
	{
		TreeNodeBean bean = new TreeNodeBean();
        	bean.setName(ics.GetVar("accessDenied"));
        	bean.setNodeId("errorMessageId");
		treeList.add(bean);
	}
	
	request.setAttribute("nodeList", treeList);
}
catch(Exception e)
{
    UIException uie = new UIException(e);
    request.setAttribute(UIException._UI_EXCEPTION_, uie);
    throw uie;
}

%>
</cs:ftcs>
