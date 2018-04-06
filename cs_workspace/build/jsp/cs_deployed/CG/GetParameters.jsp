<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@page import="org.codehaus.jettison.json.JSONObject"%>
<%@page import="org.codehaus.jettison.json.JSONArray"%>
<%@page import="java.lang.Math"%>
<%@page import="java.net.*"%>
<%@page import="java.util.*"%>
<%@page import="com.fatwire.system.*"%>
<%@page import="com.fatwire.assetapi.common.*"%>
<%@page import="com.fatwire.assetapi.data.*"%>
<%@page import="com.fatwire.assetapi.query.*"%>
<%@page import="com.openmarket.xcelerate.asset.*"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<cs:ftcs>
<xlat:lookup key="CG/ServiceIsUnavailable" escape="true" varname="serviceIsUnavailable"/>
<%
ics.SetVar("cgManagementUrl", ics.GetProperty("cg.management.url", "futuretense_xcel.ini", true));
ics.SetVar("cgProductionUrl", ics.GetProperty("cg.production.url", "futuretense_xcel.ini", true));

if (StringUtils.isNotEmpty(ics.GetSSVar("PublicationName")))
{
	ics.SetVar("cgSiteName", ics.GetSSVar("PublicationName"));
}
else if (StringUtils.isNotEmpty(ics.GetVar("site")))
{
	ics.SetVar("cgSiteName", ics.GetVar("site"));
}

ics.SetVar("cgLocale", ics.GetSSVar("locale"));

//get parent widget from browse URL
ics.SetVar("cgParentWidget", "");

if (StringUtils.isNotEmpty(ics.GetVar("browseUrl")))
{	
	String browseUrlQuery = URLDecoder.decode(ics.GetVar("browseUrl"), "UTF-8");

	URL browserUrl = new URL(browseUrlQuery);

	String [] params = browserUrl.getQuery().split("&");  

	for (String param : params)  
	{  
		String name = param.split("=")[0];
		if ("parent_widget".equals(name))
		{          
	 		String value = param.split("=")[1];
			ics.SetVar("cgParentWidget", value);
			break;
		}
	}
}

if (StringUtils.isNotEmpty(ics.GetVar("cgId")) && StringUtils.isNotEmpty(ics.GetVar("cgAssetType")))
{
	Session sess = SessionFactory.getSession();
	AssetDataManager assetDataManager = (AssetDataManager) sess.getManager(AssetDataManager.class.getName());
	AssetId assetId = null;
	AssetData assetData = null;
	//FIXME get correct id instead of increment
	assetId = new AssetIdImpl(ics.GetVar("cgAssetType"), Long.valueOf(ics.GetVar("cgId")));
	assetData = assetDataManager.readAttributes(assetId, Arrays.<String>asList("externalid"));
					
	if (assetData != null)
	{	
		AttributeData attributeData = assetData.getAttributeData("externalid");
		String internalId  = (String) attributeData.getData();
		String [] parts = internalId.split(":");
		if (parts != null)
		{
			int c = 0;
			int length = parts.length;
			if (length > c) ics.SetVar("cgId", parts[c++]);
			if (length > c) ics.SetVar("cgUid", parts[c++]);
			if (length > c) ics.SetVar("cgAssetType", parts[c++]);
			if (length > c) ics.SetVar("cgTagName", parts[c++]);
			if (length > c) ics.SetVar("cgTagVersion", parts[c++]);
			if (length > c) ics.SetVar("cgTitle", parts[c++]);
			if (length > c) ics.SetVar("cgPreviewImg", parts[c++]);
			if (length > c) ics.SetVar("cgThumbnailImg", parts[c++]);
		}
		
		String serviceIsAnavailable = ics.GetVar("serviceIsUnavailable");
		serviceIsAnavailable = serviceIsAnavailable.replace("{0}", ics.GetVar("cgTitle"));
		ics.SetVar("cgServiceIsAnavailable", serviceIsAnavailable);
		
		// sets settings 
		JSONObject slotSettingsJson = new JSONObject();
		slotSettingsJson.put("site_id", ics.GetVar("cgSiteName"));
		// set deafult settings for dashboard
		if ("gadgets_dashboard".equals(ics.GetVar("cgTagName")))
		{
			slotSettingsJson.put("dash_type", "user_dash");
			slotSettingsJson.put("min_height", "500");
		}
		if (StringUtils.isNotEmpty(ics.GetVar("cgTagParameters")))
		{
			String params = URLDecoder.decode(ics.GetVar("cgTagParameters"), "UTF-8");
			if( ! params.startsWith("{"))
			{
				params = "{" + params;
			}
			if( ! params.endsWith("}"))
			{
				params = params + "}";
			}
			JSONObject settingsJson = new JSONObject(params);
			JSONArray names = settingsJson.names();
			for (int i = 0; i < names.length(); i++)
			{
				String name = names.optString(i);
				slotSettingsJson.put(name, settingsJson.optString(name));
			}
		}
		if (StringUtils.isNotEmpty(ics.GetVar("cgSettings")))
		{
			JSONObject settingsJson = new JSONObject(ics.GetVar("cgSettings"));
			JSONArray names = settingsJson.names();
			for (int i = 0; i < names.length(); i++)
			{
				String name = names.optString(i);
				slotSettingsJson.put(name, settingsJson.optString(name));
			}
		}
		
		if (StringUtils.isNotEmpty(ics.GetVar("cgResourceId")))
		{
			slotSettingsJson.put("resource_id", ics.GetVar("cgResourceId"));
		}
		if (StringUtils.isNotEmpty(slotSettingsJson.optString("resource_id")))
		{
			ics.SetVar("cgResourceId", slotSettingsJson.optString("resource_id"));
		}
		
		ics.SetVar("cgTagParameters", slotSettingsJson.toString().replace("{", "").replace("}",""));

		ics.SetVar("cgFullTagName", ics.GetVar("cgTagName"));

		ics.SetVar("cgContentTypeParameter", "");
		
		HashMap<String, String[]> relationTags = new HashMap<String, String[]>();
		relationTags.put("wsdk.rating_stars", new String[]{"wsdk.ratings","rating_type","stars"}); 
		relationTags.put("wsdk.rating_thumbs", new String[]{"wsdk.ratings","rating_type","thumbs"}); 
		relationTags.put("wsdk.rating_likeit", new String[]{"wsdk.ratings","rating_type","like_it"}); 
		relationTags.put("wsdk.rating_recommend", new String[]{"wsdk.ratings","rating_type","recommend"}); 
		relationTags.put("wsdk.topics_recently_commented", new String[]{"wsdk.topics","content_type","recently_commented"}); 
		relationTags.put("wsdk.topics_most_commented", new String[]{"wsdk.topics","content_type","most_commented"}); 
		relationTags.put("wsdk.topics_most_reviewed", new String[]{"wsdk.topics","content_type","most_reviewed"}); 
		relationTags.put("wsdk.topics_recently_reviewed", new String[]{"wsdk.topics","content_type","recently_reviewed"}); 
		relationTags.put("wsdk.topics_top_ranked", new String[]{"wsdk.topics","content_type","top_ranked"}); 
		relationTags.put("wsdk.topics_most_rated", new String[]{"wsdk.topics","content_type","most_rated"}); 
		relationTags.put("wsdk.topics_recently_rated", new String[]{"wsdk.topics","content_type","recently_rated"});
		
		String [] attrs = relationTags.get(ics.GetVar("cgTagName"));
		if (attrs != null)
		{
			ics.SetVar("cgTagName", attrs[0]);
			ics.SetVar("cgContentTypeParameter", "," + attrs[1] + ":'" + attrs[2] + "'");
		}

		// get widget name
		HashMap<String, String> widgets = new HashMap<String, String>();
		widgets.put("wsdk.comments", "wsdk.comments.biz.RecordsWidget");
		widgets.put("comments-summary", "comments_summary.v0_1.CommentsSummaryWidget");
		widgets.put("wsdk.reviews", "wsdk.reviews.biz.RecordsWidget");
		widgets.put("reviews-summary", "cos.reviews_summary.v0_1.ReviewsSummaryWidget");
		widgets.put("wsdk.reviews_average", "wsdk.reviews_average.biz.Widget");
		widgets.put("wsdk.ratings", "wsdk.ratings.biz.Widget");
		widgets.put("wsdk.ratings_average", "wsdk.ratings_average.biz.Widget");
		widgets.put("polls", "poll.v1_0.PollWidget");
		widgets.put("polls.summary", "poll.v1_0.PollSummaryWidget");
		widgets.put("wsdk.session", "wsdk.session.biz.Widget");
		widgets.put("gadgets_dashboard", "gas.dash.v0_1.DashWidget");
		widgets.put("gadgets_dashboard-single_gadget", "gas.dash.v0_1.singleGadget.core.SingleGadgetWidget");
		widgets.put("wsdk.topics", "wsdk.topics.biz.Widget");
		
		ics.SetVar("cgWidgetName", widgets.get(ics.GetVar("cgTagName")));
		
		String scripts = "wsdk.sites_integration";
		for (String key: widgets.keySet())
		{
			if (key.indexOf("poll") > -1) key = "poll";
			if (key.indexOf("gadget") > -1) key = "gadgets_dashboard";
			scripts += ":" + key;
		}
		ics.SetVar("cgScripts", scripts);

		// get script name
		ics.SetVar("cgScriptName", ics.GetVar("cgTagName"));
		
		if ("CGPoll".equals(ics.GetVar("cgAssetType")))
		{
		    ics.SetVar("cgScriptName", "poll");
		}
		else if ("CGGadget".equals(ics.GetVar("cgAssetType")))
		{
			ics.SetVar("cgScriptName", "gadgets_dashboard");
		}
	}
}
%>
</cs:ftcs>