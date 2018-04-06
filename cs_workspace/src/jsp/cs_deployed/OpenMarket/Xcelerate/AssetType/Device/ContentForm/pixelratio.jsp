<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/DeviceImage/ContentForm/leftoffset
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

<INPUT TYPE="text" NAME='<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>' ID='<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>' SIZE="6" VALUE='<%=ics.GetVar("fieldvalue")%>' maxlength="10"/>
<xlat:lookup key="fatwire/admin/DeviceImage/PixelRatioInstructionMsg" varname="alttext"/><IMG style="vertical-align: middle; margin-left: 10px;" SRC='<%=ics.GetVar("cs_imagedir")+"/graphics/common/icon/help_new.png"%>' ALT='<%=ics.GetVar("alttext")%>'  TITLE='<%=ics.GetVar("alttext")%>' />
</body>
</cs:ftcs>