<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
 <%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// FutureTense/Apps/AdminForms/UserMgt/CreateRequiredParams
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="COM.FutureTense.Interfaces.*"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Util.ftErrors"%>
<%@ page import="com.openmarket.directory.*"%>
<cs:ftcs>

<ics:getproperty name="requiredPeopleAttrs" file="dir.ini" output="requiredPeopleAttrs"/>
<%
    String requiredPeopleAttrs= ics.GetVar("requiredPeopleAttrs");
    StringTokenizer attpairs = new StringTokenizer(requiredPeopleAttrs, "&");
    boolean bFirst = true;
    while (attpairs.hasMoreTokens())
    {
        String attpair = attpairs.nextToken();
        StringTokenizer attvalues = new StringTokenizer(attpair, "=");
        
        String attName = null;
        String attUI = null;
        try
        {
            attName = java.net.URLDecoder.decode(attvalues.nextToken());
            attUI = java.net.URLDecoder.decode(attvalues.nextToken());
        }
        catch (Exception e) {}
        
        if ( (attName != null) && (attUI != null) )
        {
            if (bFirst)
            {
                bFirst = false;
%>
    <TR><TD COLSPAN="3"><HR></TD></TR>
    <TR>
    	<TD align="left" NOWRAP="true" COLSPAN="3">
    		<FONT FACE="Arial, Helvetica" SIZE="2"><B>
            <xlat:stream key="dvin/UI/CSAdminForms/RequiredUserAttributes"/>
    			
    		</B></FONT>
    	</TD>
    </TR>
<%
            }
%>
    <TR>
        <TD align="right" NOWRAP="true">
            <FONT FACE="Arial, Helvetica" SIZE="-1">
    			<%=attUI%>
            </FONT>
        </TD>
        <TD align="left">
            <FONT FACE="Arial, Helvetica">
                <INPUT TYPE="text" NAME="<%=attName%>" SIZE="32" VALUE=""/>
            </FONT>
    	</TD>
    	<TD>
    		<FONT FACE="Arial, Helvetica" SIZE="-2" COLOR="#6666cc">
            
            <xlat:stream key="dvin/UI/CSAdminForms/RequiredInBraces"/>
    		   
    		</FONT>
    	</TD>
    </TR>
<%
        }
    }
%>

</cs:ftcs>
