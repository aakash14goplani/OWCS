<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><cs:ftcs>

<script>

function checkfields () {
	
	var obj = document.forms[0];
	var regex = /^[a-zA-Z0-9_]{1,}$/;

	if (obj.elements['assettype'].value.search(regex) == -1) {
        alert('<xlat:stream key="dvin/Assetmaker/SpecifyValidName" escape="true" encode="false"/>');
		return false;
	}
	if (obj.elements['desc'].value.search(/\S/) == -1) {
		alert('<xlat:stream key="dvin/UI/Admin/Error/mustspecifydescriptionassettype" escape="true" encode="false"/>');
		return false;
    }
	if (obj.elements['plural'].value.search(/\S/) == -1) {
        alert('<xlat:stream key="dvin/ProxyAssets/EnterPluralforProxyAsset" escape="true" encode="false"/>');
		return false;
	}
    
    
    return true;
}

</script>

<input type="hidden" name="pagename" value="OpenMarket/Xcelerate/Admin/ProxyAssetMakerPost"/>

<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
<tr>
<td>
	<span class="title-text"><xlat:stream key="dvin/ProxyAssets/AddNewProxyAssetType"/></span>
</td>
</tr>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>

<table class="width-outer-50" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td>
		<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text">
					<span class="alert-color">*</span><xlat:stream key="dvin/AT/Common/Name"/>:
				</td>
				<td class="form-inset">
					<input type="text" size="32" maxlength="32" name="assettype" value=""/>
				</td>
			</tr>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text">
					<span class="alert-color">*</span><xlat:stream key="dvin/AT/Common/Description"/>:
				</td>
				<td class="form-inset">
					<input type="text" size="32" maxlength="255" name="desc" value=""/>
				</td>
			</tr>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text">
					<span class="alert-color">*</span><xlat:stream key="dvin/UI/Admin/PluralForm"/>:
				</td>
				<td class="form-inset">
					<input type="text" size="32" maxlength="255" name="plural" value=""/>
				</td>
			</tr>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar"/>
			<tr>
				<td class="form-label-text"></td>
				<td class="form-inset">
					<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Admin/ProxyAssetMakerFront" outstring="AssetTypeURL">
						<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
						<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
						<satellite:argument name="action" value="list"/>
					</satellite:link>
					<a href="<ics:getvar name="AssetTypeURL" />">
						<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton">
							<ics:argument name="buttonkey" value="dvin/UI/Cancel"/>
						</ics:callelement>
					</a>
					<xlat:lookup key="dvin/UI/Save" varname="_XLAT_" escape="true"/>
					<a href="javascript:void(0);" onClick="if(checkfields()){document.forms['AppForm'].submit(); return false;}" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true;">
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton">
						<ics:argument name="buttonkey" value="dvin/UI/Save"/>
					</ics:callelement>
					</a>
				</td>
			</tr>
		</table>
	</td></tr>
</table>
</cs:ftcs>