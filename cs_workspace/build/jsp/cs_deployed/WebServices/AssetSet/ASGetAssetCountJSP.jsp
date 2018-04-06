<%@ page contentType="text/html; charset=UTF-8"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="soap" uri="futuretense_cs/soap.tld"
%><%//
// WebServices/AssetSet/ASGetAssetCountJSP
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

<%-- Operation : ASSETSET.GETASSETCOUNT
     Inputs : required - ASSETS or SEARCHSTATE
              optional - ASSETTYPES.LOCALE
     OUTPUT : count of assets
     ERRORS : possible errnos and err mesgs
--%>





        <%-- create the assetset in whatever manner --%>
        <ics:callelement element="WebServices/AssetSet/createAssetSetJSP"/>
        
        <ics:if condition='<%=ics.GetErrno()==0%>'>
        <ics:then>
            <assetset:getassetcount name='thisassetset' varname='assetCount'
                list='<%=(ics.GetList("LIST")!=null)?"LIST":null%>'/>
            <ics:if condition='<%=ics.GetErrno()==0%>'>
            <ics:then>
                <soap:body tagname="getStringOut">
                    <stringOut xsi:type="xsd:string"><ics:getvar name='assetCount'/></stringOut>
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