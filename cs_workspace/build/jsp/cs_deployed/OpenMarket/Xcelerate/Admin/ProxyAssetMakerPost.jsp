<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="object" uri="futuretense_cs/object.tld"
%><%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld"
%><%@ taglib prefix="property" uri="futuretense_cs/property.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs>
<ics:setvar name="assettype" value='<%=ics.GetVar("assettype") %>'/>
<ics:selectto table="AssetType" what="assettype" listname="AD" where="assettype"/>
<ics:if condition='<%=ics.GetErrno() == 0 %>'>
	<ics:then>
		<xlat:lookup key="dvin/Assetmaker/AssetTypeExists" varname="_XLAT_" evalall="false"/>
		<div class="width-outer-70">
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
			<ics:argument name="severity" value="error"/>
			<ics:argument name="msgtext" value="Variables._XLAT_"/>
		</ics:callelement>
		</div> 
		<ics:callelement element="OpenMarket/Xcelerate/Admin/ProxyAssetMakerFront">
			<ics:argument name="action" value="new" />
		</ics:callelement>
	</ics:then>
	<ics:else>
	<%
	    com.openmarket.xcelerate.util.ProxyUtils.createProxyAssetType(ics, ics.GetVar("assettype"), ics.GetVar("desc"), ics.GetVar("plural") );
	%>
		<ics:if condition='<%=ics.GetErrno() == 0 %>'>
			<ics:then>
				<object:install	classname="com.openmarket.xcelerate.asset.ProxyAssetType"
								arg1='<%=ics.GetVar("assettype") %>'
								acl="Browser,SiteGod,xceleditor,xceladmin"
								dir=""
								track="false" />
			</ics:then>
			<ics:else>
					<xlat:lookup key="dvin/ProxyAsset/AssetTypeSaveFailed" varname="_XLAT_" evalall="false"/>
					<div class="width-outer-70">
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
						<ics:argument name="severity" value="error"/>
						<ics:argument name="msgtext" value="Variables._XLAT_"/>
					</ics:callelement>
					</div>
			</ics:else>
		</ics:if>
		<ics:if condition='<%=ics.GetErrno() == 0 %>'>
			<ics:then>
				<ics:callelement element="OpenMarket/Xcelerate/Admin/AssetTypeFront">
					<ics:argument name="action" value="details"/>
					<ics:argument name="assettype" value='<%=ics.GetVar("assettype") %>' />
				</ics:callelement>
				<property:get param="xcelerate.treeType" inifile="futuretense_xcel.ini" varname="proptreetype"/>
				<ics:setvar name="element" value='<%="OpenMarket/Xcelerate/UIFramework/UpdateTree" + ics.GetVar("proptreetype")%>' />
				<ics:if condition='<%=ics.IsElement(ics.GetVar("element"))%>'>
					<ics:then>
						<ics:callelement element='<%=ics.GetVar("element") %>'>
							<ics:argument name="__TreeRefreshKeys__" value="Self:AssetTypes;Self:ProxyAssetMaker"/>
						</ics:callelement>
					</ics:then>
				</ics:if>
			</ics:then>
			<ics:else>
				<xlat:lookup key="dvin/ProxyAsset/AssetTypeInstallFailed" varname="_XLAT_" evalall="false"/>
				<div class="width-outer-70">
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
					<ics:argument name="severity" value="error"/>
					<ics:argument name="msgtext" value="Variables._XLAT_"/>
				</ics:callelement>
				</div>
				<assettype:delete name="theAssetType"/>
				<ics:callelement element="OpenMarket/Xcelerate/Admin/ProxyAssetMakerFront">
					<ics:argument name="action" value="new" />
				</ics:callelement>
			</ics:else>
		</ics:if>
	</ics:else>
</ics:if>
</cs:ftcs>
