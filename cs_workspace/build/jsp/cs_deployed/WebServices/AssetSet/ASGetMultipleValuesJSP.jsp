<%@ page contentType="text/html; charset=UTF-8"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld" 
%><%@ taglib prefix="soap" uri="futuretense_cs/soap.tld" 
%><%@ taglib prefix="misc" uri="futuretense_cs/misc.tld" 
%><%//
// WebServices/AssetSet/ASGetMultipleValuesJSP
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

<%-- Operation : ASSETSET.GETMULTIPLEVALUES  
     Inputs : required - LIST, ASSETS or SEARCHSTATE
              optional - BYASSET,LIST,ASSETTYPES.LOCALE
     OUTPUT : list containing multiple list of attribute values
     ERRORS : possible errnos and err mesgs
--%>



    

        <%-- create the assetset in whatever manner --%>
        <ics:callelement element="WebServices/AssetSet/createAssetSetJSP"/>
        
        <ics:if condition='<%=ics.GetErrno()==0%>'>
        <ics:then>
            <ics:if condition='<%=ics.GetVar("BYASSET")==null%>'>
            <ics:then>
                <ics:setvar name='BYASSET' value='false'/>    
            </ics:then>
            </ics:if>
            <assetset:getmultiplevalues name='thisassetset'  
                list='LIST'
                byasset='<%=ics.GetVar("BYASSET")%>'
                prefix='<%=ics.GetVar("PREFIX")%>'/>
            <ics:if condition='<%=ics.GetErrno()==0%>'>
            <ics:then>
                <soap:body tagname="getMultipleValuesOut">
                    <multiList xsi:type="s:multipleIList">
                        <ics:if condition='<%=ics.GetVar("BYASSET").equalsIgnoreCase("true")%>'>
                        <ics:then>
                            <ics:if condition='<%=ics.GetList("ASSETSORTLIST")!=null%>'>
                            <ics:then>
                                <assetset:getassetlist name='thisassetset' listvarname='assetlist' list='ASSETSORTLIST'/>
                            </ics:then>
                            <ics:else>
                                <assetset:getassetlist name='thisassetset' listvarname='assetlist'/>
                            </ics:else>
                            </ics:if>
                            <ics:if condition='<%=ics.GetList("assetlist",false)!=null && ics.GetList("assetlist",false).hasData()%>'>
                            <ics:then>
                                    <listName  xsi:type="soapenc:Array" soapenc:arrayType="xsd:string[]">
                                    <ics:listloop listname="assetlist">
                                        <ics:listget listname="assetlist" fieldname="assetid" output="assetid"/>
                                        <ics:listloop listname='LIST'>
                                            <ics:listget listname='LIST' fieldname='attributename' output='attrname'/>
                                            <item xsi:type="xsd:string">
                                                <%=ics.GetVar("PREFIX")%>:<%=ics.GetVar("assetid")%>:<%=ics.GetVar("attrname")%>
                                            </item>
                                        </ics:listloop>
                                    </ics:listloop>
                                    </listName>
                                    <list  xsi:type="soapenc:Array" soapenc:arrayType="s:iList[]">
                                    <ics:listloop listname="assetlist">
                                        <ics:listget listname="assetlist" fieldname="assetid" output="assetid"/>
                                        <ics:listloop listname='LIST'>
                                            <ics:listget listname='LIST' fieldname='attributename' output='attrname'/>
                                            <ics:if condition='<%=ics.GetList(ics.GetVar("PREFIX")+":"+ ics.GetVar("assetid") +":"+ ics.GetVar("attrname"),false)!=null && ics.GetList(ics.GetVar("PREFIX")+":"+ ics.GetVar("assetid") +":"+ ics.GetVar("attrname"),false).hasData()%>'>
                                            <ics:then>
                                                <misc:listtoxml list='<%=ics.GetVar("PREFIX")+":"+ ics.GetVar("assetid") +":"+ ics.GetVar("attrname")%>' namespace='s' varname='listXML'/>
                                            </ics:then>
                                            </ics:if>
                                            <item xsi:type="s:iList">
                                                <ics:if condition='<%=ics.GetVar("listXML")!=null%>'>
                                                <ics:then>
                                                    <ics:getvar name='listXML'/>
                                                </ics:then>
                                                <ics:else>
                                                    <ics:getvar name='dummyVariable'/>
                                                </ics:else>
                                                </ics:if>
                                            </item>
                                            <ics:removevar name='listXML'/>    
                                        </ics:listloop>
                                    </ics:listloop>
                                    </list>
                            </ics:then>
                            </ics:if>
                        </ics:then>
                        <ics:else>                          
                            <listName  xsi:type="soapenc:Array" soapenc:arrayType="xsd:string[]">
                            <ics:listloop listname='LIST'>
                                <ics:listget listname='LIST' fieldname='attributename' output='attrname'/>
                                <item xsi:type="xsd:string">
                                    <%=ics.GetVar("PREFIX")%>:<%=ics.GetVar("attrname")%>
                                </item>
                            </ics:listloop>
                            </listName>
                            <list  xsi:type="soapenc:Array" soapenc:arrayType="s:iList[]">
                            <ics:listloop listname='LIST'>
                                <ics:listget listname='LIST' fieldname='attributename' output='attrname'/>
                                <ics:if condition='<%=ics.GetList(ics.GetVar("PREFIX")+":" + ics.GetVar("attrname"),false)!=null && ics.GetList(ics.GetVar("PREFIX")+":" + ics.GetVar("attrname"),false).hasData()%>'>
                                <ics:then>
                                    <misc:listtoxml list='<%=ics.GetVar("PREFIX")+":" + ics.GetVar("attrname")%>' namespace='s' varname='listXML'/>
                                </ics:then>
                                </ics:if>
                                <item xsi:type="s:iList">
                                    <ics:if condition='<%=ics.GetVar("listXML")!=null%>'>
                                    <ics:then>
                                        <ics:getvar name='listXML'/>
                                    </ics:then>
                                    <ics:else>
                                        <ics:getvar name='dummyVariable'/>
                                    </ics:else>
                                    </ics:if>
                                </item>
                                <ics:removevar name='listXML'/>    
                            </ics:listloop>
                            </list>
                        </ics:else>
                        </ics:if>
                    </multiList>
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