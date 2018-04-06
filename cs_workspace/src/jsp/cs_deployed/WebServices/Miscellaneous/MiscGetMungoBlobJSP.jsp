<%@ page contentType="text/html; charset=UTF-8"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="blobservice" uri="futuretense_cs/blobservice.tld" 
%><%@ taglib prefix="soap" uri="futuretense_cs/soap.tld" 
%><%@ taglib prefix="misc" uri="futuretense_cs/misc.tld" 
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld" 
%><%//
// WebServices/Miscellaneous/MiscGetMungoBlobJSP
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
%><cs:ftcs><soap:message uri="http://divine.com/someuri/" ns="s">

<%-- Operation : MISCELLANEOUS.GETMUNGOBLOB  
     Inputs : required - BLOBKEY
     OUTPUT : the blob
     ERRORS : possible errnos and err mesgs
--%>


 <render:unknowndeps/>

    

      
        <blobservice:getidcolumn varname='idColumn'/>
        <blobservice:gettablename varname='tableName'/>
        <blobservice:geturlcolumn varname='urlColumn'/>
        <blobservice:readdata id='<%=ics.GetVar("BLOBKEY")%>'
                      listvarname="bloblist"/>

         
        <ics:if condition='<%=ics.GetErrno()==0%>'>
        <ics:then>
            <misc:base64encode list='bloblist' column='urldata' varname='blobOut'/>
            <ics:if condition='<%=ics.GetErrno()==0%>'>
            <ics:then>
                <soap:body tagname="getBlobOut">
                    <blobOUT xsi:type="xsd:base64Binary">
                    <ics:getvar name='blobOut'/>
                    </blobOUT>
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