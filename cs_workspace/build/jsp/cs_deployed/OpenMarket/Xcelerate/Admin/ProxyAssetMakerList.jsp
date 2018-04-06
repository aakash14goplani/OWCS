<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><cs:ftcs>
<c:set var="gradsrc" value='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/grad.gif"%>' />
<c:set var="cs_env" value='<%=ics.GetVar("cs_environment") %>' />
<c:set var="cs_formmode" value='<%=ics.GetVar("cs_formmode") %>' />
<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr>
		<td><span class="title-text"><xlat:stream key="dvin/UI/ProxyAssetType"/></span></td>
	</tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>

<assettype:list list="assetTypes">
	<ics:argument name="logic" value="com.openmarket.xcelerate.asset.ProxyAssetType" />
</assettype:list>

<table border="0" cellspacing="0" cellpadding="0" class="width-outer-50">
<tr>
	<td></td>
	<td class="tile-dark" height="1">
		<img width="1" height="1" src="<ics:getvar name="cs_imagedir" />/graphics/common/screen/dotclear.gif" />
	</td>
	<td></td>
</tr>
<tr>
	<td class="tile-dark" valign="top" width="1" nowrap="nowrap"><br /></td>
	<td>
		<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
		<tr><td colspan="9" class="tile-highlight"><img width="1" height="1" src="<ics:getvar name="cs_imagedir" />/graphics/common/screen/dotclear.gif" /></td></tr>
		<tr>
			<td class="tile-a" background="${gradsrc}">&nbsp;</td>
			<td class="tile-b" background="${gradsrc}">&nbsp;</td>
			<td class="tile-b" background="${gradsrc}">&nbsp;</td>
			<td class="tile-b" background="${gradsrc}">
				<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Admin/ProxyAssetMakerFront" outstring="urlassetmakerfront">
					<satellite:argument name="cs_environment" value="${cs_env}"/>
					<satellite:argument name="cs_formmode" value="${cs_formmode}"/>
					<satellite:argument name="action" value="list"/>
				</satellite:link>
				<a href="Variables.urlassetmakerfront"><div class="new-table-title"><xlat:stream key="dvin/UI/AssetType"/></div></a>
			</td>
			<td class="tile-b" background="${gradsrc}">&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td class="tile-b" background="${gradsrc}">
				<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Admin/ProxyAssetMakerFront" outstring="urlassetmakerfront">
					<satellite:argument name="cs_environment" value="${cs_env}"/>
					<satellite:argument name="cs_formmode" value="${cs_formmode}"/>
					<satellite:argument name="action" value="list"/>
					<satellite:argument name="orderby" value="description"/>
				</satellite:link>
				<a href="Variables.urlassetmakerfront"><div class="new-table-title"><xlat:stream key="dvin/Common/Description"/></div></a>
			</td>
			<td class="tile-b" background="${gradsrc}">&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td class="tile-b" background="${gradsrc}">
				<div class="new-table-title"><xlat:stream key="dvin/Common/Type"/></div>
			</td>
			<td class="tile-c" background="${gradsrc}">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="9" class="tile-dark"><img width="1" height="1" src="<ics:getvar name="cs_imagedir" />/graphics/common/screen/dotclear.gif"/></td>
		</tr>
		<%-- Loop over all search results. --%>
		<ics:setvar name="rowStyle" value="tile-row-normal"/>
		<ics:setvar name="separatorLine" value="0"/>
		<ics:listloop listname="assetTypes">
			<ics:listget listname="assetTypes" fieldname="assettype" output="assettype" />
			<ics:listget listname="assetTypes" fieldname="logic" output="logic" />
			<asset:getassettypeproperties type='<%=ics.GetVar("assettype") %>' />
			
			<ics:setvar name="separatorLine" value="1"/>
			<tr class="<ics:getvar name="rowStyle" />">
				<td><br /></td>
				<td valign="top" nowrap="nowrap" align="left">
					<xlat:lookup key="dvin/Common/Inspect" varname="_XLAT_" escape="true"/>
					<xlat:lookup key="dvin/UI/Admin/InspectThisAssetType" varname="_alt_"/>
					<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Admin/AssetTypeFront" outstring="urlassettypefront">
						<satellite:argument name="cs_environment" value="${cs_env}"/>
						<satellite:argument name="cs_formmode" value="${cs_formmode}"/>
						<satellite:argument name="action" value="details"/>
						<satellite:argument name="assettype" value='<%=ics.GetVar("assettype") %>'/>
					</satellite:link>
					<a href="<ics:getvar name='urlassettypefront' />" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true">
						<img height="14" width="14" hspace="2" vspace="4" src="<ics:getvar name="cs_imagedir" />/graphics/common/icon/iconInspectContent.gif"  border="0" alt="<%=ics.GetVar("_alt_") %>" title="<%=ics.GetVar("_alt_") %>" />
					</a>
					<xlat:lookup key="dvin/Common/Edit" varname="_XLAT_" escape="true"/>
					<xlat:lookup key="dvin/UI/Admin/EditThisAssetType" varname="_alt_"/>
					<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Admin/AssetTypeFront" outstring="urlassettypefront">
						<satellite:argument name="cs_environment" value="${cs_env}"/>
						<satellite:argument name="cs_formmode" value="Variables.cs_formmode"/>
						<satellite:argument name="action" value="edit"/>
						<satellite:argument name="assettype" value='<%=ics.GetVar("assettype") %>'/>
					</satellite:link>
					<a href="<ics:getvar name='urlassettypefront' />" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true">
						<img height="14" width="14" hspace="2" vspace="4" src="<ics:getvar name="cs_imagedir"/>/graphics/common/icon/iconEditContent.gif"  border="0" alt="<%=ics.GetVar("_alt_") %>" title="<%=ics.GetVar("_alt_") %>" />
					</a>
					<xlat:lookup key="dvin/Common/Delete" varname="_XLAT_" escape="true"/>
					<xlat:lookup key="dvin/UI/Admin/DeleteThisAssetType" varname="_alt_"/>
					<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Admin/AssetTypeFront" outstring="urlassettypefront">
						<satellite:argument name="cs_environment" value="${cs_env}"/>
						<satellite:argument name="cs_formmode" value="${cs_formmode}"/>
						<satellite:argument name="action" value="confirmdelete"/>
						<satellite:argument name="assettype" value='<%=ics.GetVar("assettype")%>'/>
					</satellite:link>
					<a href="<ics:getvar name='urlassettypefront' />" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true">
						<img height="14" width="14" hspace="2" vspace="4" src="<ics:getvar name="cs_imagedir" />/graphics/common/icon/iconDeleteContent.gif"  border="0" alt="<%=ics.GetVar("_alt_") %>" title="<%=ics.GetVar("_alt_") %>"/>
					</a>
				</td>
				<td><br/></td>
				<td valign="top" nowrap="nowrap" align="left">
					<div class="small-text-inset">
						<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Admin/AssetTypeFront" outstring="urlassettypefront">
							<satellite:argument name="cs_environment" value="${cs_env}"/>
							<satellite:argument name="cs_formmode" value="${cs_formmode}"/>
							<satellite:argument name="action" value="details"/>
							<satellite:argument name="assettype" value='<%=ics.GetVar("assettype")%>'/>
						</satellite:link>
						<a href="<ics:getvar name='urlassettypefront' />"><string:stream variable="assettype"/></a>
					</div>
				</td>
				<td><br/></td>
				<td valign="top" align="left">
					<div class="small-text-inset">
						<string:stream list="assettypes" column="description"/>
					</div>
				</td>
				<td><br /></td>
				<td valign="top" align="left">
					<div class="small-text-inset">
						<ics:callelement element="OpenMarket/Xcelerate/Admin/Util/ShowAssetTypeKind">
							<ics:argument name="assettype" value='<%=ics.GetVar("assettype") %>'/>
							<ics:argument name="logic" value='<%=ics.GetVar("logic") %>' />
						</ics:callelement>
					</div>
				</td>
				<td><br/></td>
			</tr>
			<ics:if condition='<%="tile-row-normal".equals(ics.GetVar("rowStyle"))%>'>
			<ics:then><ics:setvar name="rowStyle" value="tile-row-highlight"/></ics:then>
			<ics:else><ics:setvar name="rowStyle" value="tile-row-normal"/></ics:else>
			</ics:if>
		</ics:listloop>
		</table>
	</td>
	<td class="tile-dark" valign="top" width="1" nowrap="nowrap"><br /></td>
</tr>
<tr>
	<td colspan="3" class="tile-dark" valign="top" height="1"><img width="1" height="1" src="<ics:getvar name="cs_imagedir" />/graphics/common/screen/dotclear.gif" /></td>
</tr>
<tr>
	<td></td>
	<td background="<ics:getvar name="cs_imagedir" />/graphics/common/screen/shadow.gif"><img width="1" height="5" src="<ics:getvar name="cs_imagedir" />/graphics/common/screen/dotclear.gif"/></td>
	<td></td>
</tr>
</table>

<table class="width-outer-70">
<tr><td>
	<xlat:lookup key="dvin/ProxyAssets/AddNewProxyAssetType" varname="_XLAT_" escape="true"/>
	<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Admin/ProxyAssetMakerFront" outstring="addFlexURL">
		<satellite:argument name="cs_environment" value="${cs_env}"/>
		<satellite:argument name="cs_formmode" value="${cs_formmode}"/>
		<satellite:argument name="action" value="new"/>
	</satellite:link>
	<a href="<ics:getvar name="addFlexURL" />" onmouseover="window.status='<%=ics.GetVar("_XLAT_") %>';return true;" onmouseout="window.status='';return true;">
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton">
		<ics:argument name="buttonkey" value="dvin/ProxyAssets/AddNewProxyAssetType"/>
	</ics:callelement>
	</a>
</td></tr>
</table>
</cs:ftcs>