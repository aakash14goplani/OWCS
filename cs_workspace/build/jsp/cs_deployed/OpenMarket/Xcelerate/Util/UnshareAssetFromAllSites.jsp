<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%//
// OpenMarket/Xcelerate/Util/UnshareAssetFromAllSites
//
// INPUT
//
// OUTPUT

// INPUT - save. 
//         save="true" -- If optional parameter 'save' is true, this element unshares and saves asset as well. Actual unsharing of asset takes place only after saving it.
//         save="false" or no value means that responsibility for saving this asset lies to the calling element, while this element only sets params for
//         sunsharing asset from all sites.
// 

//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="org.apache.commons.logging.Log,org.apache.commons.logging.LogFactory" %>
<cs:ftcs>

<%
Log log = LogFactory.getLog("com.fatwire.logging.cs.mobility");
%>
<asset:load name="theCurrentAsset" type='<%=ics.GetVar("AssetType")%>' objectid='<%=ics.GetVar("id")%>' editable="true"/>
<asset:sites name="theCurrentAsset" list="sitelist" />
<ics:listloop listname="sitelist">
<ics:listget listname="sitelist" fieldname="id" output="siteid" />
<asset:removesite name="theCurrentAsset" pubid='<%=ics.GetVar("siteid")%>' />
</ics:listloop>

<ics:if condition='<%=ics.GetErrno() == 0%>'>
	<ics:then>
	<ics:if condition='<%="true".equalsIgnoreCase(ics.GetVar("save"))%>'>
	<ics:then>
	<asset:save name="theCurrentAsset" />
	<ics:if condition='<%=ics.GetErrno() == 0%>'>
		<ics:then>
				<% log.info("***********************Device Groups: "+ics.GetVar("id")+" un-shared from all sites.");		%>
		</ics:then>
		<ics:else>
				<% log.error("***********************Device Groups: "+ics.GetVar("id")+" un-sharing from all sites failed. . Error no: "+ics.GetErrno()+" ***************");		%>
		</ics:else>
	</ics:if>
	</ics:then>
	</ics:if>
 </ics:then>
</ics:if>

</cs:ftcs>