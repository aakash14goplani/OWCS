<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%--
- fatwire/insitetemplating/stub/ControlPanel
-
- INPUT
-
- OUTPUT
--%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><cs:ftcs><%
String cgipath = ics.GetProperty("ft.cgipath");
%>
<table width="100%" valign="top" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">        
<tr>
    <td colspan="3" class="control">
        <div id="divTabButtons">&nbsp;</div>
        <div id="divTabFrame">
            <ics:callelement element="fatwire/insitetemplating/advancedTab">
                <ics:argument name="site" value='<%=ics.GetSSVar("PublicationName")%>'/>
            </ics:callelement>
        </div>
    </td>
</tr>
<tr class="controlheader">
    <td class="header" valign="top" height="6" colspan="3">
        <span class="headertext">Search Results</span>          
    </td>
</tr>
<tr>
    <td colspan="3">
        <div id="searchOuterResultList" class="search" >&nbsp;</div>
    </td>
</tr> 
<tr>
    <td colspan="3">
        <div id="searchOuter" class="search" >&nbsp;</div>
    </td>
</tr>
<tr>
    <td colspan="3" class="header">Status: <span id="ControlStatusBox" class="control">&nbsp;</span></td>
</tr>
<tr>
    <td align="right" colspan="3" height="8"></td></tr>
<tr valign="middle" >
    <td align="right"></td>
    <td align="center">                                    
        <input type="button" value="Save" onclick="javascript:save();">
    </td>
    <td></td>
</tr>
</table>

</cs:ftcs>