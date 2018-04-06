<%@ page contentType="text/html; charset=UTF-8" 
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld" 
%><%@ taglib prefix="soap" uri="futuretense_cs/soap.tld" 
%><%@ taglib prefix="misc" uri="futuretense_cs/misc.tld" 
%><%//
// WebServices/SitePlan/SPGetChildrenJSP
// Note that the xml header must be streamed before any other
// character, including whitespace. Do not insert any text
// that will be streamed to the response before the xml header.
//
// INPUT
//
// OUTPUT
//%><%@ page import="COM.FutureTense.Interfaces.FTValList" 
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%@ page import="COM.FutureTense.Interfaces.IList" 
%><%@ page import="COM.FutureTense.Interfaces.Utilities" 
%><%@ page import="COM.FutureTense.Util.ftErrors" 
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><cs:ftcs><ics:if condition="<%=!(Boolean.valueOf(ics.GetProperty(ftMessage.csXmlHeaderAutoStreamProp)).booleanValue())%>"><ics:then><ics:getproperty name="cs.xmlHeader"/></ics:then></ics:if><soap:message uri="http://divine.com/someuri/" ns="s">

<%-- Operation : SITEPLAN.GETCHILDREN  
     Inputs : required - NODEID
              optional - CODE,CHILDTYPE,CHILDID,ORDER
     OUTPUT : list containing children nodes
     ERRORS : possible errnos and err mesgs
--%>



       
        
        <siteplan:load name='siteplannode' nodeid='<%=ics.GetVar("NODEID")%>'/>
        <ics:if condition='<%=ics.GetErrno()==0%>'>
        <ics:then>
            <siteplan:children name='siteplannode' list='outlist' 
                code='<%=ics.GetVar("CODE")%>'
                order='<%=ics.GetVar("ORDER")%>'
                objectid='<%=ics.GetVar("CHILDID")%>'
                objecttype='<%=ics.GetVar("CHILDTYPE")%>'/>
            <ics:if condition='<%=ics.GetErrno()==0%>'>
            <ics:then>
                <soap:body tagname="getListOut">
                    <misc:listtoxml list='outlist' namespace='s' varname='listXML'/>
                    <listOUT xsi:type="s:iList">
                        <ics:getvar name='listXML'/>
                    </listOUT>
                </soap:body>
            </ics:then>
            <ics:else>
                <soap:fault code='server' string='<%=ics.GetVar("errno")%>' actor='<%=ics.GetVar("errdetail1")%>'/>
            </ics:else>
            </ics:if>
        </ics:then>
        <ics:else>
            <soap:fault code='server' string='<%=ics.GetVar("errno")%>' actor='<%=ics.GetVar("errdetail1")%>'/>
        </ics:else>
        </ics:if>



</soap:message>

</cs:ftcs>