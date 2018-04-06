<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld" %>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" %>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>

<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>

<%@ page import="com.fatwire.services.*"%>
<%@ page import="com.fatwire.assetapi.data.*"%>
<%@ page import="com.fatwire.system.*"%>
<%@ page import="com.fatwire.services.util.*"%>
<%@ page import="com.fatwire.services.ServicesManager"%>
<%@ page import="com.fatwire.cs.ui.framework.LocalizedMessages"%>
<%@ page import="com.fatwire.cs.ui.framework.UIException"%>
<%@ page import="com.fatwire.services.beans.asset.AssetSaveStatusBean"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="java.util.*"%>
<%//
// UI/Actions/Tree/PasteSiteNavigationAction
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.*"%>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Util.ftMessage,java.util.regex.*,java.util.*"%>
<%@ page import="com.openmarket.xcelerate.site.SitePlanNode" %>
<%@ page import="com.fatwire.mobility.util.MobilityUtils" %>
<%@ page import="com.fatwire.mobility.util.MobilityUtils.PasteSiteNavigationState" %>
<cs:ftcs>
<%
	PasteSiteNavigationState result = PasteSiteNavigationState.SUCCESS;
%>
<ics:clearerrno />
<ics:if condition='<%="true".equals(ics.GetVar("confirm"))%>'>
<ics:then>
<%
	result = MobilityUtils.pasteSiteNavigation(ics, ics.GetVar("AssetType"), ics.GetVar("ID"), ics.GetVar("destinationType"), ics.GetVar("destinationId"));
%>
	<ics:if condition='!"ucform".equalsIgnoreCase(ics.GetVar("cs_environment"))' >
	<ics:then>
		<property:get param="xcelerate.treeType" inifile="futuretense_xcel.ini" varname="proptreetype"/>
		<ics:setvar name="showSiteTree" value='<%=ics.GetSSVar("showSiteTree")%>'/>
		<ics:setvar name="__REFRESHUNPLACED__" value="Self:UnplacedPages"/>
		<ics:if condition='<%=ics.IsElement("OpenMarket/Xcelerate/UIFramework/UpdateTree" + ics.GetVar("proptreetype"))%>'>
			<ics:then>
	  			<ics:callelement element='<%="OpenMarket/Xcelerate/UIFramework/UpdateTree" + ics.GetVar("proptreetype")%>'>
					<ics:argument name="__TreeRefreshKeys__" value='<%=ics.GetVar("__REFRESHUNPLACED__")%>'/>
				</ics:callelement>		
			</ics:then>
		</ics:if>
	</ics:then>
	</ics:if>
	
</ics:then>
<ics:else>
	<satellite:form>
		<asset:load name="pageAsset" type='<%=ics.GetVar("AssetType")%>' objectid='<%=ics.GetVar("ID")%>'  />
		<asset:get name="pageAsset" field="name" output="assetname" />
		<INPUT type="HIDDEN" name="AssetType" value='<%=ics.GetVar("AssetType")%>' />
		<INPUT type="HIDDEN" name="ID" value='<%=ics.GetVar("ID")%>'/>
		<INPUT type="HIDDEN" name="confirm" value="true"/>
		<INPUT type="HIDDEN" name="pagename" value="OpenMarket/Xcelerate/Actions/CopySiteNavigationFront"/>
		<script>
			var result = confirm("Are you sure you want to copy site navigation from <%=ics.GetVar("assetname")%>?");
			if(result == true)
				this.document.forms[0].submit();
		</script>
	</satellite:form>
</ics:else>
</ics:if>
	
<%
	request.setAttribute("result", result);
%>

</cs:ftcs>