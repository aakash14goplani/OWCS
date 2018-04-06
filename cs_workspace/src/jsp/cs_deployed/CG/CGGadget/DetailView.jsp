<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@taglib prefix="assettype" uri="futuretense_cs/assettype.tld"%>
<%@taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld"%>
<%@taglib prefix="string" uri="futuretense_cs/string.tld"%>
<%@taglib prefix="locale" uri="futuretense_cs/locale1.tld"%>
<%@taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@page import="COM.FutureTense.Interfaces.*"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.net.URL"%>
<%@page import="org.apache.commons.io.IOUtils"%>
<%@page import="org.codehaus.jettison.json.JSONArray"%>
<%@page import="org.codehaus.jettison.json.JSONObject"%>
<cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/StandardVariables" />
<html>
<head>
	<script>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/StandardHeader" />
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/LoadDojo" />
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/SetStylesheet" />
	</script>
</head>
	<body>
		<ics:if condition='<%=Utilities.goodString(ics.GetSSVar("locale")) %>'>
		<ics:then>
			<locale:create varname="LocaleName" localename='<%=ics.GetSSVar("locale") %>'/>
			<dateformat:create name="_FormatDate_" datestyle="full" timestyle="full" locale="LocaleName" timezoneid='<%=ics.GetSSVar("time.zone") %>'/>
		</ics:then>
		<ics:else>
			<dateformat:create name="_FormatDate_" datestyle="full" timestyle="full" timezoneid='<%=ics.GetSSVar("time.zone") %>'/>
		</ics:else>
		</ics:if>
		
		<ics:setvar name="assetname" value="theCurrentAsset" />
		<asset:load type='<%=ics.GetVar("type")%>' objectid='<%=ics.GetVar("id")%>' name="theCurrentAsset"/>
		<asset:scatter name="theCurrentAsset" prefix="ContentDetails" />
		<asset:getassettype name="theCurrentAsset" outname="at"/>
		<assettype:get name="at" field="description" output="at:description"/>
<%
ics.SetVar("cgId", ics.GetVar("id"));
ics.SetVar("cgAssetType", ics.GetVar("type"));
%>
<ics:callelement element="CG/GetPermission"/>
<ics:callelement element="CG/GetMultiTicket"/>
<ics:callelement element="CG/GetParameters"/>
<%
String title = ics.GetVar("ContentDetails:name");
try
{
	if (ics.GetVar("user-access-is-granted") != null)
	{
	    String detailUrl = ics.GetVar("cgManagementUrl") + "/rest/sites/detail/CGGadget"
	     	  	+ "?site_id=" + ics.GetVar("cgSiteName")
	        	+ "&locale=" + ics.GetVar("cgLocale")
	        	+ "&id=" + URLEncoder.encode(ics.GetVar("ContentDetails:externalid"))
		    	+ "&gateway=true"
    			+ "&multiticket=" + ics.GetVar("cgMultiTicket");
  		URL url = new URL(detailUrl);
		InputStream is = url.openStream();
      	String str = IOUtils.toString(is, "UTF-8");
		JSONObject resp = new JSONObject(str);
	
		if (resp.optString("status").equals("success"))
		{
			title = resp.optString("title");
		}
	}
}
catch(Exception e){}
%>	
		<table class="width-outer-70" style="padding-top: 35px;">
		<tr>
			<td><span class="title-text"><string:stream variable="at:description" />: </span><span class="title-value-text"><%=title%></span></td>
		</tr>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
			<ics:argument name="SpaceBelow" value="No"/>
		</ics:callelement>
		<tr>
			<td>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/Common/Name"/>:</td>
					<td><img height="1" width="5" src="<ics:getvar name="cs_imagedir" />/graphics/common/screen/dotclear.gif" /></td>
					<td class="form-inset"><%=title%></td>
				</tr>
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/AT/Common/ID"/>:</td>
					<td></td>
					<td class="form-inset"><string:stream variable="ContentDetails:id"/></td>
				</tr>
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/FlexibleAssets/FlexAssets/ExternalItemId"/>:</td>
					<td></td>
					<td class="form-inset"><string:stream variable="ContentDetails:externalid"/></td>
				</tr>
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Created"/>:</td>
					<td></td>
					<td class="form-inset">
						<dateformat:getdatetime name="_FormatDate_" value='<%=ics.GetVar("ContentDetails:createddate") %>' valuetype="jdbcdate" varname="ContentDetails:createddate"/>
						<xlat:stream key="dvin/UI/ContentDetailscreateddatebycreatedby"/>
					</td>
				</tr>
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Modified"/>:</td>
					<td></td>
					<td class="form-inset">
						<dateformat:getdatetime name="_FormatDate_" value='<%=ics.GetVar("ContentDetails:updateddate") %>' valuetype="jdbcdate" varname="ContentDetails:updateddate"/>
					<xlat:stream key="dvin/UI/ContentDetailsupdateddatebyupdatedby"/></td>
				</tr>
			</table>
		</td>
	</tr>
	</table>
	</body>
</html>
</cs:ftcs>
