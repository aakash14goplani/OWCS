<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>

<%@ page import="com.openmarket.gator.nvobject.*"%>

<cs:ftcs>

	<ics:callelement element="OpenMarket/Xcelerate/AssetType/Segments/SaveRulesetTuples">
		<ics:argument name="Prefix" value="Segments"/>
	</ics:callelement>

	<script type="text/javascript">
		var isEditMode=false;
		var isContributorMode = <%= "ucform".equals(ics.GetVar("cs_environment")) %>;
	</script>

	<xlat:lookup key="UI/Forms/Content" varname="tabContent"/>
	<xlat:lookup key="UI/Forms/Marketing" varname="tabMarketing"/>
	<xlat:lookup key="UI/Forms/Detail" varname="tabDetail"/>

<div dojoType="dijit.layout.BorderContainer" class="bordercontainer">

	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ActionsBar">
		<ics:argument name="Screen" value="Inspect"/>
		<ics:argument name="NoPreview" value="true"/>
	</ics:callelement>

<div dojoType="dijit.layout.ContentPane" region="center">
<div dojoType="dijit.layout.TabContainer" class="formstabs formsTabContainer" style="width:100%;height:100%">

	<ics:callelement element="OpenMarket/Xcelerate/Util/RetainSelectedTab">
		<ics:argument name="tabContent" value='<%=ics.GetVar("tabContent")%>' />
		<ics:argument name="elementType" value="JSP" />
	</ics:callelement>

	<div dojoType="dijit.layout.ContentPane" title="<%=ics.GetVar("tabContent")%>"  selected="true">

	<table border="0" cellpadding="0" cellspacing="0" class="width70BottomExMargin">
		
	<!-- Segment page title with asset name -->
	<tr>
		<td>
			<span class="title-text"><xlat:stream key="dvin/AT/Segments/InspectSegment"/>: </span>
			<span class="title-value-text"><string:stream variable="ContentDetails:name"/></span>
		</td>
	</tr>
		
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
		<ics:argument name="SpaceBelow" value="No"/>
	</ics:callelement>
		
	<!-- Segment  inspection form -->
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0">
				<!-- The beginning of Group 1 -->
				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Name"/>:</td>
					<td><img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
					<td class="form-inset"><string:stream variable="ContentDetails:name"/></td>
				</tr>
			
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
				
				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Description"/>:</td>
					<td><img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
					<td class="form-inset"><string:stream variable="ContentDetails:description"/></td>
				</tr>
							
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
				
				<tr>
					<td class="form-label-text"><xlat:stream key="dvin/AT/Common/ID"/>:</td>
					<td></td>
					<td class="form-inset"><string:stream variable="id"/></td>
				</tr>
				
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
				
				<tr>
					<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/ShowStatusCode"/>
				</tr>

				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/form/InspectAssetStartEndDate"/>
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
				
                <tr>
                   	<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Created"/>:</td>
                   	<td></td>
                   	<td class="form-inset">
              		<dateformat:getdatetime name="_FormatDate_" value='<%=ics.GetVar("ContentDetails:createddate")%>' valuetype="jdbcdate"  varname="ContentDetails:createddate"/>
                   	<xlat:stream key="dvin/UI/ContentDetailscreateddatebycreatedby"/></td>
               	</tr>

                <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>

                <tr>
                   	<td class="form-label-text"><xlat:stream key="dvin/AT/Common/Modified"/>:</td>
                   	<td></td>
                   	<td class="form-inset">
                    <dateformat:getdatetime name="_FormatDate_" value='<%=ics.GetVar("ContentDetails:updateddate")%>' valuetype="jdbcdate"  varname="ContentDetails:updateddate"/>
                    <xlat:stream key="dvin/UI/ContentDetailsupdateddatebyupdatedby"/></td>
               </tr>
               
			</table>
		</td>
		</tr>
		
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar"/>
		<tr>
			<td><img height="10" width="1" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
		</tr>

		</table>
	</div>
	
	<div dojoType="dijit.layout.ContentPane" title="<%=ics.GetVar("tabDetail")%>">

	<ics:setvar name="SegRuleSetHint" value=""/>
	<ics:callelement element="OpenMarket/Xcelerate/AssetType/Segments/CoFSetVar"/>

	<!-- Load data for this specific Segment and some general supporting material -->
	<ics:callelement element="OpenMarket/Xcelerate/AssetType/Segments/ContentFormLoadData"/>

	<!-- Load Javascript to Render (and support Edit and Save of) the Segment data -->
	<ics:callelement element="OpenMarket/Xcelerate/AssetType/Segments/ContentFormJavascript"/>
	
	<table border="0" cellpadding="0" cellspacing="0" class="width-outer-90">

    <td><span class="title-text"><xlat:stream key="dvin/AT/Segments/FilteringCriteria"/></span></td>
	
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
		<ics:argument name="SpaceBelow" value="Yes"/>
	</ics:callelement>
	
	<tr><td>
		<div id="ruleSetDiv" class="segRuleSet">Rendered Ruleset Goes Here!</div>
		<input type="hidden" name="SegRuleSetMapHint" value="" />
	</td></tr>
	
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar" />
	
	<tr>
		<td><img height="10" width="1" src='<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>'/></td>
	</tr>
		
	</table>
	</div>

</div>
</div>
</div>
</cs:ftcs>
