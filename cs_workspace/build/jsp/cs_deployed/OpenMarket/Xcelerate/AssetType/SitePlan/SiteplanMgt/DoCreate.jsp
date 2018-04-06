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
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld" %>

<%@ page import="java.util.*"%>
<%@ page import="COM.FutureTense.Interfaces.*"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Util.ftErrors"%>
<%@ page import="com.openmarket.directory.*"%>
<%@ page import="com.openmarket.xcelerate.site.SitePlanNode" %>

<cs:ftcs>
 
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<HTML>
<HEAD>
	<TITLE><xlat:stream key="dvin/UI/AddSitePlan" /></TITLE>
</HEAD>
<BODY>
	<div class="width-outer-70">  
		<asset:create name="newSiteplanAsset" type="SitePlan" />
		<asset:set name="newSiteplanAsset" field="name" value='<%=ics.GetVar("name")%>' />
		<asset:set name="newSiteplanAsset" field="description" value='<%=ics.GetVar("description")%>' />
		
		<ics:callelement element="OpenMarket/Xcelerate/AssetType/SitePlan/PreUpdate" >
			<ics:argument name="name" value='<%=ics.GetVar("name")%>' />
			<ics:argument name="updatetype" value="new" />
		</ics:callelement>
		<ics:if condition='<%=!"true".equals(ics.GetVar("isDuplicate"))%>'>
		<ics:then>
			<asset:addsite name="newSiteplanAsset" pubid='<%=ics.GetVar("pubid")%>' />
			<ics:if condition='<%=null != ics.GetVar("DGList")%>' >
			<ics:then>
				<asset:set name="newSiteplanAsset" field="devicegroups" value='<%=ics.GetVar("DGList") %>' />
			</ics:then>
			</ics:if>
			<asset:save name="newSiteplanAsset"/>
			<ics:if condition='<%=0!=ics.GetErrno()%>'>
			<ics:then>
				<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/ShowError">
					<ics:argument name="error" value="EnterAssetFailed"/>
					<ics:argument name="AssetType" value="SitePlan"/>
				</ics:callelement>
			</ics:then>
			<ics:else>
				<asset:getsitenode name="newSiteplanAsset" output="nid"/>
				<siteplan:load name="editedSitePlanAsset" nodeid='<%=ics.GetVar("nid")%>'/>	
				<ics:sql sql="select nrank from SitePlanTree where otype = 'SitePlan' and ncode != 'Void' order by nrank desc" listname="nranks" table="SitePlanTree"/>
				<ics:listget listname="nranks" fieldname="nrank" output="maxnrank"/>
				<%
					SitePlanNode editedSitePlanNode = (SitePlanNode) ics.GetObj("editedSitePlanAsset");
					editedSitePlanNode.SetNodeRank(Integer.parseInt(ics.GetVar("maxnrank")) + 1);
				%>
				<siteplan:save name="editedSitePlanAsset" />
				<asset:get name="newSiteplanAsset" field="id" output="id" />
	
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
						<ics:argument name="msgtext" value='<%=ics.GetVar("_XLAT_") %>'/>
						<ics:argument name="severity" value="info"/>
					</ics:callelement>
				</ics:else>
				</ics:if>
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
		
		<property:get param="xcelerate.treeType" inifile="futuretense_xcel.ini" varname="proptreetype"/>
		<ics:callelement element='<%="OpenMarket/Xcelerate/UIFramework/UpdateTree" + ics.GetVar("proptreetype") %>' >
			<ics:argument name="__TreeRefreshKeys__" value="Self:MobilitySitePlan"/>
		</ics:callelement>
		
		<render:callelement elementname='OpenMarket/Xcelerate/AssetType/SitePlan/AdminForm'>
			<render:argument name="tool" value="SiteplanMgt" />
			<render:argument name="form" value="Home" />
			<render:argument name="pubid" value='<%=ics.GetVar("pubid")%>' />
		</render:callelement>
	</div>
</BODY>
</HTML>

</cs:ftcs>

