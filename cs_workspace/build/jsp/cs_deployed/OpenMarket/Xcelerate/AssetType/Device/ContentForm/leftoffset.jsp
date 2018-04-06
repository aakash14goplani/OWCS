<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/Device/ContentForm/leftoffset
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
<STYLE type="text/css">
.dimErrorField{
background-color: #f66;
}
</STYLE>

<body onload="showSkinImages('<%=ics.GetVar("urlblobserver")%>')">
<INPUT TYPE="text" NAME='<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>' ID='<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>' SIZE="6" VALUE='<%=ics.GetVar("fieldvalue")%>' onkeyup="valueChanged(event,'<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>','<%=ics.GetVar("urlblobserver")%>')"  /><xlat:lookup key="dvin/UI/MobilitySolution/LeftOffSetInstructionMsg" varname="alttext"/>
</body>
</cs:ftcs>