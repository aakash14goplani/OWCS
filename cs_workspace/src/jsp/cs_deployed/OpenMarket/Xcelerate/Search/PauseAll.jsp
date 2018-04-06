<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Search/PauseAll
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
<%@ page import="com.fatwire.search.util.AssetIndexSourceConfigHandler" %>
<%@ page import="com.fatwire.search.source.*" %>
<cs:ftcs>

<!-- user code here -->
<%
    AssetIndexSourceConfigImpl aConfig = new AssetIndexSourceConfigImpl( ics );
    AssetIndexSourceMetadata metadata = (AssetIndexSourceMetadata) aConfig.getConfiguration( IndexSourceProperties.GLOBAL );
    AssetIndexSourceConfigHandler handler = new AssetIndexSourceConfigHandler( ics );
    handler.disableAll(metadata);
%>
</cs:ftcs>