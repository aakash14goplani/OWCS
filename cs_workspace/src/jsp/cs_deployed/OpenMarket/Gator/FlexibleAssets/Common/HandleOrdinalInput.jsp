<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/FlexibleAssets/Common/HandleOrdinalInput
//
// Modified on 2/18/2008 to removed nonfunctional ordinal fields in accordance to Bug #16173.
// Modified on 6/23/2005 to provide the ability for attaching ordinal information to
// multi-value blob attributes and provide the javascript for checking input.
// IsNumber is a function that is provided in 
// OpenMarket\Gator\FlexibleAssets\Common\ContentForm1JavaScripts.xml
// @author: Chunhe
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
<ics:if condition='<%=ics.GetVar("EditingStyle").equals("multiple-ordered")%>'>
<ics:then>
<%
    String sCurrentOrdinalInput = "cs_"+ics.GetVar("AttrName")+"_ordinal_"+ics.GetCounter("TCounter");
    String sCurrentOrdinal = ics.GetVar(sCurrentOrdinalInput);
    if (!Utilities.goodString(sCurrentOrdinal)) {
        sCurrentOrdinal = ics.GetVar("ContentDetails:Attribute_"+ics.GetVar("AttrName")+":"+String.valueOf(ics.GetCounter("TCounter")-1)+":ordinal");
        if (!Utilities.goodString(sCurrentOrdinal)) {
            sCurrentOrdinal = String.valueOf(ics.GetCounter("TCounter"));
        }
    } 
    %>
    <input type="hidden" name="<%=sCurrentOrdinalInput%>" value="<%=Float.valueOf(sCurrentOrdinal).intValue()%>"/>
</ics:then>
</ics:if>

</cs:ftcs>