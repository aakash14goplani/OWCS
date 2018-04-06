<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%//
// Skins.jsp 
//
// INPUT
//
// OUTPUT
//%>
<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.net.URLDecoder"%>
<cs:ftcs>


<%
String fieldname=ics.GetVar("AssetType")+":"+ics.GetVar("fieldname");
%>

<!-- Get a list of skins whose ownerid  = 'id' of curent device group and whose enabled='y' -->
<asset:list type="Device" list="skinlist" order="name" excludevoided="true" field1="enabled" value1="Y" field2="ownerid" value2='<%=ics.GetVar("id")%>' /> 	  
<ics:if condition='<%=ics.GetErrno() == 0%>'>
<ics:then>
  <ics:listloop listname="skinlist">
           <ics:listget listname="skinlist" fieldname="name" output="skinname" />
			<string:stream value='<%=ics.GetVar("skinname")%>' />
			<br/>
   </ics:listloop>
</ics:then>
<ics:else>
<xlat:stream key="dvin/UI/MobilitySolution/NoSkinAssociated" />
<ics:setvar name="noskins" value="true" />
</ics:else>
</ics:if>
			
<input type="hidden" id='<%=fieldname%>' name='<%=fieldname%>'>
</cs:ftcs>