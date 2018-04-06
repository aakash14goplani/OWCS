<%@ page contentType="text/html; charset=UTF-8" 
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld" 
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" 
%><%@ taglib prefix="soap" uri="futuretense_cs/soap.tld" 
%><%@ taglib prefix="misc" uri="futuretense_cs/misc.tld" 
%><%//
// WebServices/SitePlan/SPGetPropertiesJSP
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

<%-- Operation : SITEPLAN.GETPROPERTIES 
     Inputs : required - NODEID
     OUTPUT : list containing properties of nodes
     ERRORS : possible errnos and err mesgs
--%>



     
        
        <siteplan:load name='siteplannode' nodeid='<%=ics.GetVar("NODEID")%>'/>
        <ics:if condition='<%=ics.GetErrno()==0%>'>
        <ics:then>
            <% ics.SetVar("SGet", "0"); %>
            <siteplan:get name='siteplannode' field='nid'/>
                <% if(ics.GetErrno()!=0)ics.SetVar("SGet",ics.GetErrno()); %>
            <siteplan:get name='siteplannode' field='nparentid'/>
                <% if(ics.GetErrno()!=0)ics.SetVar("SGet",ics.GetErrno()); %>
            <siteplan:get name='siteplannode' field='nrank'/>
                <% if(ics.GetErrno()!=0)ics.SetVar("SGet",ics.GetErrno()); %>
            <siteplan:get name='siteplannode' field='otype'/>
                <% if(ics.GetErrno()!=0)ics.SetVar("SGet",ics.GetErrno()); %>
            <siteplan:get name='siteplannode' field='oid'/>
                <% if(ics.GetErrno()!=0)ics.SetVar("SGet",ics.GetErrno()); %>
            <siteplan:get name='siteplannode' field='oversion'/>
                <% if(ics.GetErrno()!=0)ics.SetVar("SGet",ics.GetErrno()); %>
            <siteplan:get name='siteplannode' field='ncode'/>
                <% if(ics.GetErrno()!=0)ics.SetVar("SGet",ics.GetErrno()); %>
            <ics:if condition='<%=ics.GetVar("SGet").equals("0")%>'>
            <ics:then>
                <listobject:create name='listobj' columns='nid,nparentid,nrank,otype,oid,oversion,ncode'/>
                <listobject:addrow name='listobj'>
                    <listobject:argument name='nid' value='<%=ics.GetVar("nid")%>'/>
                    <listobject:argument name='nparentid' value='<%=ics.GetVar("nparentid")%>'/>
                    <listobject:argument name='nrank' value='<%=ics.GetVar("nrank")%>'/>
                    <listobject:argument name='otype' value='<%=ics.GetVar("otype")%>'/>
                    <listobject:argument name='oid' value='<%=ics.GetVar("oid")%>'/>
                    <listobject:argument name='oversion' value='<%=ics.GetVar("oversion")%>'/>
                    <listobject:argument name='ncode' value='<%=ics.GetVar("ncode")%>'/>
                </listobject:addrow>
                <listobject:tolist name="listobj" listvarname="outlist"/>
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
                <% ics.SetErrno(new Integer(ics.GetVar("SGet")).intValue()); %>
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