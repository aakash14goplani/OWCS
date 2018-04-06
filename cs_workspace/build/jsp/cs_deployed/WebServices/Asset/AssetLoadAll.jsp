<%@ page contentType="text/html; charset=UTF-8" 
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" 
%><%@ taglib prefix="soap" uri="futuretense_cs/soap.tld" 
%><%@ taglib prefix="misc" uri="futuretense_cs/misc.tld"
%><%
// Note that the xml header must be streamed before any other
// character, including whitespace. Do not insert any text
// that will be streamed to the response before the xml header.
%><%--
    Element: WebServices/Asset/AssetLoadAll
    Operation: ASSET.LOADALL
    INPUT: TYPE, SUBTYPE, (IDS || (LIST, IDFIELD)), 
           [DEPTYPE], [EXCLUDE], [FIELDLIST], [SITEID],
           [GETCHILDREN], [CODE],[CHILDTYPE], [CHILDID], [ORDER]
    OUTPUT: structure containing array of objects that contain loaded assets and 
            an ilist of the children
    ERRORS: ASSET.LOADALL and ASSET.GETCHILDREN errnos may be returned
--%><%@ page import="COM.FutureTense.Interfaces.FTValList" 
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%@ page import="COM.FutureTense.Interfaces.IList" 
%><%@ page import="COM.FutureTense.Interfaces.Utilities" 
%><%@ page import="COM.FutureTense.Util.ftErrors" 
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@ page import="java.util.*"
%><cs:ftcs><ics:if condition="<%=!(Boolean.valueOf(ics.GetProperty(ftMessage.csXmlHeaderAutoStreamProp)).booleanValue())%>"><ics:then><ics:getproperty name="cs.xmlHeader"/></ics:then></ics:if><%try{%><soap:message uri="http://divine.com/someuri/" ns="s">
<%
boolean debug = ics.xmlDebug();
if (debug)
{
	StringBuffer bf = new StringBuffer("WebServices/Asset/AssetLoadAll: Relevant input params:");
	bf.append("\n\t").append("TYPE=").append(ics.GetVar("TYPE"));
	bf.append("\n\t").append("SUBTYPE=").append(ics.GetVar("SUBTYPE"));
	bf.append("\n\t").append("IDS=").append(ics.GetVar("IDS"));
	bf.append("\n\t").append("LIST is ").append(ics.GetList("LIST").hasData()? "not empty" : "empty");
	bf.append("\n\t").append("IDFIELD=").append(ics.GetVar("IDFIELD"));
	bf.append("\n\t").append("DEPTYPE=").append(ics.GetVar("DEPTYPE"));
	bf.append("\n\t").append("EXCLUDE=").append(ics.GetVar("EXCLUDE"));
	bf.append("\n\t").append("FIELDLIST=").append(ics.GetVar("FIELDLIST"));
	bf.append("\n\t").append("SITEID=").append(ics.GetVar("SITEID"));
	bf.append("\n\t").append("GETCHILDREN=").append(ics.GetVar("GETCHILDREN"));
	bf.append("\n\t").append("CODE=").append(ics.GetVar("CODE"));
	bf.append("\n\t").append("CHILDTYPE=").append(ics.GetVar("CHILDTYPE"));
	bf.append("\n\t").append("CHILDID=").append(ics.GetVar("CHILDID"));
	bf.append("\n\t").append("ORDER=").append(ics.GetVar("ORDER"));
	ics.LogMsg(bf.toString());
}
%>
<asset:loadall
     prefix='loadall:'
     type='<%=ics.GetVar("TYPE")%>'
     list='<%=ics.GetVar("LIST")==null? null: "LIST"%>'
     idfield='<%=ics.GetVar("IDFIELD")%>'
     ids='<%=ics.GetVar("IDS")%>'
     deptype='<%=ics.GetVar("DEPTYPE")%>'
     />
<%
if (debug) ics.LogMsg("WebServices/Asset/AssetLoadAll: Finished asset.loadall  errno="+ics.GetErrno());
// get the number of rows found
int numFound = 0;
// if no matching rows found, -10003 is returned
if (ics.GetErrno() == -10003)
{
    ics.ClearErrno();
}
else if (ics.GetErrno() >=0)
{
    try {
        numFound = Integer.parseInt(ics.GetVar("loadall:Total"));
    } catch (Exception e) {
        ics.SetErrno(ftErrors.exceptionerr);
        ics.SetVar("errdetail","Exception getting number of assets returned by asset.loadall (total returned is: "+ics.GetVar("loadall:Total")+")");
    }
}
if (debug) ics.LogMsg("WebServices/Asset/AssetLoadAll loaded " + numFound + " assets.");
%>
<ics:if condition='<%=ics.GetErrno()>=0%>'>
<ics:then>
    <%
    boolean bSoapFault = false;
    // Keep track of all the data we're going to stream out.  We can't stream
    // anything out until we're sure there were no errors because you can only
    // stream out either legal body content or a single soap fault.
    StringBuffer bodyContent = new StringBuffer();
    
    for (int i = 0; (!bSoapFault && numFound!=0 && i<numFound); i++)
    {
    	String sCurrentAsset = "loadall:"+i;
        String sCurrentAssetPrefix = sCurrentAsset+":asset:";
        boolean bGotLoadedAsset = false;
        boolean bGotChildList = false;
        if (debug) ics.LogMsg("WebServices/Asset/AssetLoadAll: about to call asset.scatter.  errno=" + ics.GetErrno());
        %>
        <%-- scatter the asset --%>
        <asset:scatter name='<%=sCurrentAsset%>'
            prefix='<%=sCurrentAssetPrefix%>'
            exclude='<%=ftMessage.truestr.equalsIgnoreCase(ics.GetVar("EXCLUDE"))%>'
            fieldlist='<%=ics.GetVar("FIELDLIST")%>'/>
        <%
        if (debug) ics.LogMsg("WebServices/Asset/AssetLoadAll: after asset.scatter, errno="+ics.GetErrno());
        %>
        <%-- dump it to xml in a variable --%>
        <ics:if condition='<%=ics.GetErrno()==0%>'>
        <ics:then>
            <asset:exportinxsdschema name='<%=sCurrentAsset%>' prefix='<%=sCurrentAssetPrefix%>' namespace='s' output='assetXML' 
                pubid='<%=ics.GetVar("SITEID")%>' subtype='<%=ics.GetVar("SUBTYPE")%>'/>
            <ics:if condition='<%=ics.GetErrno()==0%>'>
            <ics:then>
                <%
                bGotLoadedAsset = true;
                %>
            </ics:then>
            <ics:else>
                <%
                bSoapFault = true;
                if (debug) ics.LogMsg("WebServices/Asset/AssetLoadAll: Failure exporting asset to XML.  errno=" + ics.GetErrno());
                %>
                <soap:fault code='server' string='<%=ics.GetVar("errno")%>' actor='<%=ics.GetVar("errdetail1")%>'/>
            </ics:else>
            </ics:if>
        </ics:then>
        <ics:else>
            <%
            bSoapFault = true;
            if (debug) ics.LogMsg("WebServices/Asset/AssetLoadAll: Failure scattering asset.  errno=" + ics.GetErrno());
            
            %>
            <soap:fault code='server' string='<%=ics.GetVar("errno")%>' actor='<%=ics.GetVar("errdetail1")%>'/>
        </ics:else>
        </ics:if>
        
        <%-- get children if requested --%>
        <ics:if condition='<%=(!bSoapFault && bGotLoadedAsset && ftMessage.truestr.equalsIgnoreCase(ics.GetVar("GETCHILDREN")) )%>'>
        <ics:then>
            <asset:children name='<%=sCurrentAsset%>' list='outlist' 
                code='<%=ics.GetVar("CODE")%>' 
                objecttype='<%=ics.GetVar("CHILDTYPE")%>' 
                objectid='<%=ics.GetVar("CHILDID")%>' 
                order='<%=ics.GetVar("ORDER")%>'/>
            <ics:if condition='<%=ics.GetErrno()==0%>'>
            <ics:then>
                <%
                bGotChildList = true;
                %>
                <misc:listtoxml list='outlist' namespace='s' varname='listXML'/>
            </ics:then>
            <ics:else>
                <ics:if condition='<%=ics.GetErrno()==-111%>'>
                <ics:then>
                    <%
                    bGotChildList = true;
                    %>
                </ics:then>
                <ics:else>
                    <%
                    bSoapFault = true;
                    if (debug) ics.LogMsg("WebServices/Asset/AssetLoadAll: failure getting children of assets.  errno=" + ics.GetErrno());
                    %>
                    <soap:fault code='server' string='<%=ics.GetVar("errno")%>' actor='<%=ics.GetVar("errdetail1")%>'/>
                </ics:else>
                </ics:if>
            </ics:else>
            </ics:if>
            <%
            // clean up
            ics.RegisterList("outlist",null);
            ics.ClearErrno();
            %>
        </ics:then>
        </ics:if>
        
        <%-- construct the response for this asset --%>
        <ics:if condition='<%=!bSoapFault && bGotLoadedAsset%>'>
        <ics:then>
            <%
            bodyContent.append('\n');
            
            // the wrapper over the two components
            bodyContent.append("<loadedAssetAndChildren xsi:type=\"s:assetWithChildren\">").append('\n');
            
            // the asset itself
            bodyContent.append('\t').append("<assetData xsi:type=\"s:loadedAsset\">").append('\n');
            bodyContent.append('\t').append('\t').append(ics.GetVar("assetXML")).append('\n');
            bodyContent.append('\t').append("</assetData>").append('\n');
            // attempt to free some resources
            ics.RemoveVar("assetXML");
            ics.SetObj(sCurrentAsset,null);
            // to do: free all variables with the prefix
            
            // children if any
            String listXML = ics.GetVar("listXML");
            if (bGotChildList && listXML!=null)
            {
                bodyContent.append('\t').append("<assetChildren xsi:type=\"s:iList\">").append('\n');
                bodyContent.append('\t').append('\t').append(listXML).append('\n');
                bodyContent.append('\t').append("</assetChildren>").append('\n');
            }
            // attempt to free some resources
            ics.RemoveVar("listXML");
            
            // close the wrapper
            bodyContent.append("</loadedAssetAndChildren>").append('\n');
            %>
        </ics:then>
        </ics:if>
        <%
    } // loop through all found assets
    %>
    
    <%-- stream the body response for all assets --%>
    <%    
    if (!bSoapFault)
    {
    	%>
    	<soap:body tagname="getAssetLoadAllOut">
    	    <assetLoadAllOUT xsi:type="s:arrayOfAssetsWithChildren">
    	        <%=bodyContent.append('\n').toString()%>
    	    </assetLoadAllOUT>
    	</soap:body>
    	<%
    }
    %>
</ics:then>
<ics:else>
	<soap:fault code='server' string='<%=ics.GetVar("errno")%>' actor='<%=ics.GetVar("errdetail1")%>' />
</ics:else>
</ics:if>
<%
if (debug) ics.LogMsg("WebServices/Asset/AssetLoadAll: Done. errno="+ics.GetErrno());
%>
</soap:message><%}catch(Exception e) {%>exception!<%=e.toString()%><%}%></cs:ftcs>