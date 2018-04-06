<%@ page contentType="text/html; charset=UTF-8" 
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="soap" uri="futuretense_cs/soap.tld" 
%><%@ taglib prefix="misc" uri="futuretense_cs/misc.tld" 
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld" 
%><%//
// WebServices/Miscellaneous/MiscGetBlobJSP
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

<%-- Operation : MISCELLANEOUS.GETBLOB  
     Inputs : required - BLOBKEY,BLOBWHERE,BLOBCOL,BLOBTABLE
              optional - BLOBHEADER
     OUTPUT : the blob
     ERRORS : possible errnos and err mesgs
--%>



    
 <render:unknowndeps/>

      
        <ics:setvar name='<%=ics.GetVar("BLOBKEY")%>' value='<%=ics.GetVar("BLOBWHERE")%>'/>
        <ics:selectto table='<%=ics.GetVar("BLOBTABLE")%>' what='<%=ics.GetVar("BLOBCOL")%>'
        	 where='<%=ics.GetVar("BLOBKEY")%>' listname='bloblist' />

         
        <ics:if condition='<%=ics.GetErrno()==0%>'>
        <ics:then>
            <misc:base64encode list='bloblist' column='<%=ics.GetVar("BLOBCOL")%>' varname='blobOut'/>
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