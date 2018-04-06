<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%//
// FutureTense/Apps/AdminForms/SiteplanMgt/DoDelete
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
 
<asset:load name="deleteSiteplanAsset" type="SitePlan" field="id" value='<%=ics.GetVar("spid")%>' editable="true"/>

<asset:load name="spAsset" type="SitePlan" objectid='<%=ics.GetVar("spid") %>' />
<asset:getsitenode name="spAsset" output="siteplanNodeId" />
<ics:sql sql='<%="select oid from SitePlanTree where otype=\'Page\' and nparentid=\'" + ics.GetVar("siteplanNodeId") + "\'"%>' listname="slist" table="SitePlanTree" />
<ics:if condition='<%=0!=ics.GetList("slist").numRows()%>'>
<ics:then>
	<siteplan:root list="PubRoot" objectid='<%=ics.GetVar("pubid") %>' />
	<ics:listget listname="PubRoot" fieldname="nid" output="PubRootnid" />
	<ics:listloop listname="slist">
		<ics:listget listname="slist" fieldname="oid" output="sid" />
		<ics:catalogmanager>
			<ics:argument name="ftcmd" value="updaterow" />
			<ics:argument name="tablename" value="SitePlanTree" />
			<ics:argument name="tablekey" value="oid" />
			<ics:argument name="tablekeyvalue" value='<%=ics.GetVar("sid")%>' />
			<ics:argument name="nparentid" value='<%=ics.GetVar("PubRootnid")%>' />
			<ics:argument name="ncode" value='UnPlaced' />
		</ics:catalogmanager>
	</ics:listloop>
</ics:then>
</ics:if>

<asset:void name="deleteSiteplanAsset" />

<ics:if condition='<%=0!=ics.GetErrno()%>'>
<ics:then>
	<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/ShowError">
		<ics:argument name="error" value="DeleteFailed"/>
		<ics:argument name="AssetType" value="SitePlan"/>
	</ics:callelement>
</ics:then>
<ics:else>
	<div class="width-outer-70">
	<xlat:lookup key="dvin/UI/MobilitySolution/Siteplan/SiteplanDeleted" varname="_XLAT_" />
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="msgtext" value='<%=ics.GetVar("_XLAT_") %>'/>
		<ics:argument name="severity" value="info"/>
	</ics:callelement>
	
		<render:callelement elementname='OpenMarket/Xcelerate/AssetType/SitePlan/AdminForm'>
			<render:argument name="tool" value="SiteplanMgt" />
			<render:argument name="form" value="Home" />
			<render:argument name="pubid" value='<%=ics.GetVar("pubid")%>' />
		</render:callelement>
	</div>
</ics:else>
</ics:if>

<property:get param="xcelerate.treeType" inifile="futuretense_xcel.ini" varname="proptreetype"/>
<ics:callelement element='<%="OpenMarket/Xcelerate/UIFramework/UpdateTree" + ics.GetVar("proptreetype") %>' >
	<ics:argument name="__TreeRefreshKeys__" value="Self:MobilitySitePlan"/>
</ics:callelement>

</cs:ftcs>