<%@ page contentType="text/html; charset=UTF-8" 
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" 
%><%@ taglib prefix="soap" uri="futuretense_cs/soap.tld" 
%><%@ taglib prefix="misc" uri="futuretense_cs/misc.tld"
%><%//
// WebServices/Asset/AssetLoadJSP
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
%><cs:ftcs><ics:if condition="<%=!(Boolean.valueOf(ics.GetProperty(ftMessage.csXmlHeaderAutoStreamProp)).booleanValue())%>"><ics:then><ics:getproperty name="<%=ftMessage.csXmlHeaderProp%>"/></ics:then></ics:if><soap:message uri="http://divine.com/someuri/" ns="s">

<%-- Operation : ASSET.LOAD  
     Inputs : required - TYPE,OBJECTID
              optional - FIELD,VALUE
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
            <asset:scatter name='thisAsset'
                prefix='prefix'
                exclude='<%=( ics.GetVar("EXCLUDE")!= null && ics.GetVar("EXCLUDE").equalsIgnoreCase("true"))%>'
                fieldlist='<%=ics.GetVar("FIELDLIST")%>'/>
            <ics:if condition='<%=ics.GetErrno()==0%>'>
            <ics:then>
                <asset:exportinxsdschema name='thisAsset' prefix='prefix' namespace='s' output='assetXML' 
                    pubid='<%=ics.GetVar("SITEID")%>' subtype='<%=ics.GetVar("SUBTYPE")%>'/>
                    <ics:if condition='<%=ics.GetErrno()==0%>'>
                    <ics:then>
                        <ics:setvar name='gotLoadedAsset' value='true'/>
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

            <ics:if condition='<%=( ics.GetVar("gotLoadedAsset")!= null && ics.GetVar("gotLoadedAsset").equalsIgnoreCase("true") && ics.GetVar("GETCHILDREN")!= null && ics.GetVar("GETCHILDREN").equalsIgnoreCase("true"))%>'>
            <ics:then>
                <asset:children name='thisAsset' list='outlist' 
                    code='<%=ics.GetVar("CODE")%>' 
                    objecttype='<%=ics.GetVar("CHILDTYPE")%>' 
                    objectid='<%=ics.GetVar("CHILDID")%>' 
                    order='<%=ics.GetVar("ORDER")%>'/>
                    
        
                <ics:if condition='<%=ics.GetErrno()==0%>'>
                <ics:then>
                    <ics:setvar name='gotChildList' value='true'/>
                        <misc:listtoxml list='outlist' namespace='s' varname='listXML'/>
                        
                </ics:then>
                <ics:else>
                    <ics:if condition='<%=ics.GetErrno()==-111%>'>
                    <ics:then>
                        <ics:setvar name='gotChildList' value='true'/>
                    </ics:then>
                    <ics:else>
                        <soap:fault code='server' string='<%=ics.GetVar("errno")%>' actor='<%=ics.GetVar("errdetail1")%>'/>
                    </ics:else>
                    </ics:if>
                </ics:else>
                </ics:if>
            </ics:then>
            </ics:if>
            <ics:if condition='<%=( ics.GetVar("gotLoadedAsset")!= null && ics.GetVar("gotLoadedAsset").equalsIgnoreCase("true"))%>'>
            <ics:then>

                <soap:body tagname="getAssetLoadOut">
                    <assetLoad xsi:type="s:loadedAsset">
                        <ics:getvar name='assetXML'/>
                    </assetLoad>
    
                    <ics:if condition='<%=( ics.GetVar("gotChildList")!= null && ics.GetVar("gotChildList").equalsIgnoreCase("true") && ics.GetVar("listXML")!= null)%>'>
                    <ics:then>
                        <listOUT xsi:type="s:iList">
                            <ics:getvar name='listXML'/>
                        </listOUT>
                    </ics:then>
                    </ics:if>

                </soap:body>

            </ics:then>
            </ics:if>
        </ics:then>
        <ics:else>
            <soap:fault code='server' string='<%=ics.GetVar("errno")%>' actor='<%=ics.GetVar("errdetail1")%>'/>
        </ics:else>
        </ics:if>

        



</soap:message>




</cs:ftcs>