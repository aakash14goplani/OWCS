<%@ page contentType="text/html; charset=UTF-8" 
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" 
%><%@ taglib prefix="soap" uri="futuretense_cs/soap.tld" 
%><%@ taglib prefix="misc" uri="futuretense_cs/misc.tld" 
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld" 
%><%//
// WebServices/Asset/AssetListJSP
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

<%-- Operation : ASSET.LIST  
     Inputs : required - TYPE
              optional - ORDER,FIELD1-9,VALUE1-9
     OUTPUT : list containing listed assets
     ERRORS : possible errnos and err mesgs
--%>



 <render:unknowndeps/>
    

      
        <asset:list 
            type='<%=ics.GetVar("TYPE")%>' 
            list='outlist' 
            order='<%=ics.GetVar("ORDER")%>'
            pubid='<%=ics.GetVar("SITEID")%>'
            excludevoided='<%=!( ics.GetVar("EXCLUDEVOIDED")!= null && ics.GetVar("EXCLUDEVOIDED").equalsIgnoreCase("false"))%>'
            field1='<%=ics.GetVar("FIELD1")%>' 
            value1='<%=ics.GetVar("VALUE1")%>'
            field2='<%=ics.GetVar("FIELD2")%>' 
            value2='<%=ics.GetVar("VALUE2")%>'
            field3='<%=ics.GetVar("FIELD3")%>'
            value3='<%=ics.GetVar("VALUE3")%>'
            field4='<%=ics.GetVar("FIELD4")%>' 
            value4='<%=ics.GetVar("VALUE4")%>'
            field5='<%=ics.GetVar("FIELD5")%>' 
            value5='<%=ics.GetVar("VALUE5")%>'
            field6='<%=ics.GetVar("FIELD6")%>' 
            value6='<%=ics.GetVar("VALUE6")%>'
            field7='<%=ics.GetVar("FIELD7")%>' 
            value7='<%=ics.GetVar("VALUE7")%>'
            field8='<%=ics.GetVar("FIELD8")%>' 
            value8='<%=ics.GetVar("VALUE8")%>'
            field9='<%=ics.GetVar("FIELD9")%>' 
            value9='<%=ics.GetVar("VALUE9")%>'/>

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
        

        



</soap:message>


        

</cs:ftcs>