<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld" %>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/OrderSiteplan
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
<satellite:form>

<ics:if condition='<%="front".equals(ics.GetVar("formtype"))%>'>
<ics:then>

	<ics:callelement element="OpenMarket/Xcelerate/Actions/AssetMgt/OrderSiteplanTile">
		<ics:argument name="editrank" value="true"/>
	</ics:callelement>
	
	<INPUT type="hidden" name="formtype" value="post" />
	<INPUT type="hidden" name="pubid" value='<%=ics.GetVar("pubid") %>' />
	<INPUT type="hidden" name="pagename" value="OpenMarket/Xcelerate/Actions/OrderSiteplan" />

</ics:then>
</ics:if>

<ics:if condition='<%="post".equals(ics.GetVar("formtype"))%>' >
<ics:then>
	<asset:list type="SitePlan" excludevoided="true" list="siteplanlist" pubid='<%=ics.GetVar("pubid") %>' />
	<ics:if condition='<%=null != ics.GetList("siteplanlist") && ics.GetList("siteplanlist").hasData()%>'>
	<ics:then>
		<ics:listloop listname="siteplanlist">
			<ics:listget listname="siteplanlist" fieldname="id" output="sid" />
			<siteplan:root list="PubRoot" objectid='<%=ics.GetVar("pubid") %>' /> 
			<ics:listget listname="PubRoot" fieldname="nid" output="nid" />
			<siteplan:load name="pubNode" nodeid='<%=ics.GetVar("nid")%>'/>
			<ics:getvar name='<%="Rank-" + ics.GetVar("sid")%>' output="nrank" />
			<siteplan:place name="pubNode" childid='<%=ics.GetVar("sid") %>' type="SitePlan" rank='<%=ics.GetVar("nrank") %>' />
			<siteplan:save name="pubNode" />
		</ics:listloop>
		
		<ics:callelement element="OpenMarket/Xcelerate/Actions/AssetMgt/OrderSiteplanTile">
			<ics:argument name="editrank" value="false"/>
		</ics:callelement>
		
		<property:get param="xcelerate.treeType" inifile="futuretense_xcel.ini" varname="proptreetype"/>
		<ics:callelement element='<%="OpenMarket/Xcelerate/UIFramework/UpdateTree" + ics.GetVar("proptreetype") %>' >
			<ics:argument name="__TreeRefreshKeys__" value="Self:MobilitySitePlan"/>
		</ics:callelement>
	</ics:then>
	</ics:if>
</ics:then>
</ics:if>

</satellite:form>
</cs:ftcs>