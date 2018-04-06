<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld"
%><%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="locale" uri="futuretense_cs/locale1.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ page import="COM.FutureTense.Interfaces.*" %><cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/StandardVariables" />
<html>
<head>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/LoadDojo" />
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/StandardHeader" />
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/SetStylesheet" />
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
		<asset:load type='<%=ics.GetVar("type") %>' objectid='<%=ics.GetVar("id") %>' name="theCurrentAsset"/>
		<asset:scatter name="theCurrentAsset" prefix="ContentDetails" />
		<asset:getassettype name="theCurrentAsset" outname="at"/>
		<assettype:get name="at" field="description" output="at:description"/>
		

		<table class="width-outer-70" style="padding-top: 35px;">
		<tr>
			<td><span class="title-text"><string:stream variable="at:description" />: </span><span class="title-value-text"><string:stream variable="ContentDetails:name"/></span></td>
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
					<td class="form-inset"><string:stream variable="ContentDetails:name"/></td>
				</tr>
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
                                <tr>
					<td class="form-label-text"><xlat:stream key="UI/UC1/Layout/Tags"/>:</td>
					<td><img height="1" width="5" src="<ics:getvar name="cs_imagedir" />/graphics/common/screen/dotclear.gif" /></td>
					<td class="form-inset">
                                            <ics:callelement element="OpenMarket/Gator/AttributeTypes/TagBox">
                                                <ics:argument name="inputName" value='fwtags'/>
                                                <ics:argument name="tagValue" value='<%=ics.GetVar("fwtags")%>'/>
                                                <ics:argument name="inputSize" value='32'/>
                                                <ics:argument name="readOnly" value='true'/>
                                                <ics:argument name="showCloseButton" value='false'/>
                                                <ics:argument name="inputMaxlength" value='<%=ics.GetVar("sizeofnamefield")%>'/>
                                                <ics:argument name="applyDefaultFormStyle" value='<%=ics.GetVar("defaultFormStyle")%>' />
                                            </ics:callelement>
                                        </td>
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