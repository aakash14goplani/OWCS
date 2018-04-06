<%@ page contentType="text/html; charset=UTF-8" 
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" 
%><%@ taglib prefix="soap" uri="futuretense_cs/soap.tld" 
%><%//
// WebServices/Asset/AssetGetSiteParentJSP
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

<%-- Operation : ASSET.GETSITEPARENT  
     Inputs : required - TYPE,OBJECTID
              optional - FIELD,VALUE,EXCLUDE,FIELDLIST,PUBID,SUBTYPE
     OUTPUT : structure containing loaded asset
     ERRORS : possible errnos and err mesgs
--%>



    

      
        <asset:load name='thisAsset'
            type='<%=ics.GetVar("TYPE")%>' 
            objectid='<%=ics.GetVar("OBJECTID")%>' 
            field='<%=ics.GetVar("FIELD")%>'
            value='<%=ics.GetVar("VALUE")%>'/>
            

        <ics:if condition='<%=ics.GetErrno()==0%>'>
        <ics:then>
            <asset:siteparent name="thisAsset" outname='parent'/>
            
            <ics:if condition='<%=ics.GetErrno()==0%>'>
            <ics:then>
                <asset:scatter name='parent'
                    prefix='prefix'
                    exclude='<%=( ics.GetVar("EXCLUDE")!= null && ics.GetVar("EXCLUDE").equalsIgnoreCase("true"))%>'
                    fieldlist='<%=ics.GetVar("FIELDLIST")%>'/>
                <ics:if condition='<%=ics.GetErrno()==0%>'>
                <ics:then>
                    <asset:exportinxsdschema name='parent' prefix='prefix' namespace='s' output='assetXML' 
                        pubid='<%=ics.GetVar("SITEID")%>' subtype='<%=ics.GetVar("SUBTYPE")%>'/>
                        <ics:if condition='<%=ics.GetErrno()==0%>'>
                        <ics:then>
                            <soap:body tagname="getAssetLoadOut">
                                <assetLoad xsi:type="s:loadedAsset">
                                    <ics:getvar name='assetXML'/>
                                </assetLoad>        
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