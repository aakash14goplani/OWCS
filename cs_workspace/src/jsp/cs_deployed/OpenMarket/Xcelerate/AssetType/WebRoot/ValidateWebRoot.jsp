<%@page import="com.fatwire.assetapi.data.AssetData"%>
<%@page import="com.fatwire.assetapi.query.SimpleQuery"%>
<%@page import="com.fatwire.assetapi.query.Query"%>
<%@page import="com.fatwire.assetapi.query.OpTypeEnum"%>
<%@page import="com.fatwire.assetapi.query.ConditionFactory"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.fatwire.assetapi.query.Condition"%>
<%@page import="com.fatwire.assetapi.data.AssetDataManagerImpl"%>
<%@page import="com.fatwire.assetapi.data.AssetDataManager"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/WebRoot/ValidateWebRoot
//
// INPUT
//
// OUTPUT
//%>

<cs:ftcs>
<xlat:lookup varname="webrootalreadyexistswithsamehostname" key="UI/Forms/WebRootAlreadyExistsWithSameHostName"/>
<xlat:lookup varname="webrootalreadyexistswithsamerooturlname" key="UI/Forms/WebRootAlreadyExistsWithSameRootURL"/>

<%
	String hostname = ics.GetVar("hostname");
	String rooturl = ics.GetVar("rooturl");
	String id = ics.GetVar("id");
	String message ="";
	boolean exists = false;
	AssetDataManager adm = new AssetDataManagerImpl(ics);
	if(StringUtils.isNotEmpty(hostname))
	{
		Condition c = ConditionFactory.createCondition("name", OpTypeEnum.EQUALS, hostname);
		Query query = new SimpleQuery("WebRoot", null , c, null);
		Iterable<AssetData> data = adm.read(query);
		if (data != null && data.iterator().hasNext()) {
			AssetData assetdata = data.iterator().next();
			if(StringUtils.isEmpty(id)  || (StringUtils.isNotEmpty(id) && !id.equals(String.valueOf(assetdata.getAssetId().getId()))))
			{
				exists = true;
				message = ics.GetVar("webrootalreadyexistswithsamehostname");
			}	
		}
	}	
	if(StringUtils.isNotEmpty(rooturl))
	{
		Condition c = ConditionFactory.createCondition("rooturl", OpTypeEnum.EQUALS, rooturl);
		Query query = new SimpleQuery("WebRoot", null , c, null);
		Iterable<AssetData> data = adm.read(query);
		if (data != null && data.iterator().hasNext()) {
			AssetData assetdata = data.iterator().next();
			if(StringUtils.isEmpty(id)  || (StringUtils.isNotEmpty(id) && !id.equals(String.valueOf(assetdata.getAssetId().getId()))))
			{
				exists = true;
				message = ics.GetVar("webrootalreadyexistswithsamerooturlname");
			}	
		}
	}	
%>
	{"status":"<%=exists ?"error" : "success" %>",
	"message":"<%=exists ? message : ""%>"}
</cs:ftcs>