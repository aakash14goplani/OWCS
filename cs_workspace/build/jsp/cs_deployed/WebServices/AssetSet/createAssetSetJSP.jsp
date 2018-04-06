<%@ page contentType="text/html; charset=UTF-8"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="misc" uri="futuretense_cs/misc.tld"
%><%//
// WebServices/AssetSet/createAssetSetJSP
//
// INPUT
//
// OUTPUT
//%><%@ page import="java.util.Locale"
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@ page import="com.openmarket.basic.interfaces.LocaleFactory"
%><cs:ftcs>
<%
   String localeString = ics.GetVar("LOCALE");
    		    	if(localeString != null)
    		    	{
    		    	    int commaIndex = localeString.indexOf("_");
    		    	    Locale localeObj = LocaleFactory.getLocale(localeString.substring(commaIndex + 1),
					            localeString.substring(0,commaIndex));
		                if(localeObj != null)
                             ics.SetObj("LOCALEOBJ",localeObj);
	                }
%>

<ics:if condition='<%=ics.GetList("ASSETS")!=null && ics.GetList("ASSETS").hasData()%>'>
<ics:then>
    <%-- using a list of assets --%>
    <assetset:setlistedassets name='thisassetset' 
        assets='ASSETS'
        assettypes='ASSETTYPESLIST'
        locale='<%=(ics.GetObj("LOCALEOBJ")!=null)?"LOCALEOBJ":null%>'
        deptype='exists'/>
</ics:then>
<ics:else>
    <%-- using a searchstate --%>
                        

                    <assetset:setsearchedassets name='thisassetset'
                        constraint='<%=(ics.GetObj("SEARCHSTATE")!=null)?"SEARCHSTATE":null%>'
                        assettypes='<%=ics.GetVar("ASSETTYPES")%>'
                        locale='<%=(ics.GetObj("LOCALEOBJ")!=null)?"LOCALEOBJ":null%>'
                        deptype='exists'/>
</ics:else>
</ics:if>
</cs:ftcs>