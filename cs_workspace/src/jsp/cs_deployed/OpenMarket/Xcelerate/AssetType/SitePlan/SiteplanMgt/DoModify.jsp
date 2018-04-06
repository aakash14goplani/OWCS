<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="dir" uri="futuretense_cs/dir.tld" %>
<%@ taglib prefix="name" uri="futuretense_cs/name.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>

<%@ page import="java.util.*"%>
<%@ page import="COM.FutureTense.Interfaces.*"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Util.ftErrors"%>
<%@ page import="com.openmarket.directory.*"%>

<cs:ftcs>
 
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<HTML>
<HEAD>
	<TITLE><xlat:stream key="dvin/UI/ModifySitePlan" /></TITLE>
</HEAD>
<BODY>
	<div class="width-outer-70"> 
		<asset:load name="newSiteplanAsset" type="SitePlan" field="id" value='<%=ics.GetVar("spid")%>' editable="true"/>
		<asset:set name="newSiteplanAsset" field="name" value='<%=ics.GetVar("name")%>' />
		<asset:set name="newSiteplanAsset" field="description" value='<%=ics.GetVar("description")%>' />
		
		<ics:callelement element="OpenMarket/Xcelerate/AssetType/SitePlan/PreUpdate" >
			<ics:argument name="name" value='<%=ics.GetVar("name")%>' />
			<ics:argument name="updatetype" value="edit" />
		</ics:callelement>
		<ics:if condition='<%="true"!=ics.GetVar("isDuplicate")%>'>
		<ics:then>
			<asset:addsite name="newSiteplanAsset" pubid='<%=ics.GetVar("pubid")%>' />
			<asset:set name="newSiteplanAsset" field="devicegroups" value='<%=ics.GetVar("DGList") %>' />
			<!-- force status to ED -->
			<asset:set name="newSiteplanAsset" field="status" value="ED"/>
			<asset:save name="newSiteplanAsset"/>
			<ics:if condition='<%=0!=ics.GetErrno()%>'>
			<ics:then>
				<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/ShowError">
					<ics:argument name="error" value="EnterAssetFailed"/>
					<ics:argument name="AssetType" value="SitePlan"/>
				</ics:callelement>
			</ics:then>
			<ics:else>
				<xlat:lookup key="dvin/UI/MobilitySolution/Siteplan/SiteplanSaved" varname="_XLAT_" />
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
					<ics:argument name="msgtext" value='<%=ics.GetVar("_XLAT_") %>' />
					<ics:argument name="severity" value="info"/>
				</ics:callelement>
			</ics:else>
			</ics:if>
		</ics:then>
		<ics:else>
			<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/ShowError">
				<ics:argument name="errno" value="-12075" />
				<ics:argument name="error" value="EnterAssetFailed"/>
				<ics:argument name="AssetType" value="SitePlan"/>
			</ics:callelement>
		</ics:else>
		</ics:if>
		
		<render:callelement elementname='OpenMarket/Xcelerate/AssetType/SitePlan/AdminForm'>
			<render:argument name="tool" value="SiteplanMgt" />
			<render:argument name="form" value="Home" />
			<render:argument name="pubid" value='<%=ics.GetVar("pubid")%>' />
		</render:callelement>
	</div>
</BODY>
</HTML>

</cs:ftcs>

