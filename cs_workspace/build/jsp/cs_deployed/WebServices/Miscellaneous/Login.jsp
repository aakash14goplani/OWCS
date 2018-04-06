<%@ page contentType="text/html; charset=UTF-8" 
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" 
%><%@ taglib prefix="soap" uri="futuretense_cs/soap.tld" 
%><%@ taglib prefix="user" uri="futuretense_cs/user.tld" 
%><%//
// WebServices/Miscellaneous/Login
// Note that the xml header must be streamed before any other
// character, including whitespace. Do not insert any text
// that will be streamed to the response before the xml header.
//
// log a user in
//
// INPUT: 
// required: authusername, authpassword
// optional: none
//
// OUTPUT:
// result - either true of false
//
// FAULT:
// none
//
//%><%@ page import="COM.FutureTense.Interfaces.FTValList" 
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%@ page import="COM.FutureTense.Interfaces.IList" 
%><%@ page import="COM.FutureTense.Interfaces.Utilities" 
%><%@ page import="COM.FutureTense.Util.ftErrors" 
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><cs:ftcs><ics:if condition="<%=!(Boolean.valueOf(ics.GetProperty(ftMessage.csXmlHeaderAutoStreamProp)).booleanValue())%>"><ics:then><ics:getproperty name="cs.xmlHeader"/></ics:then></ics:if>
<soap:message uri="http://divine.com/someuri/" ns="fwcs">
	<user:login 
		username='<%=ics.GetVar("authusername")%>' 
		password='<%=ics.GetVar("authpassword")%>' />
	<ics:if condition='<%=ics.GetErrno()==0%>'>
	<ics:then>
		<soap:body tagname="result">
			<result xsi:type="xsd:string"><%=ftMessage.successStr%></result>
		</soap:body>
	</ics:then>
	<ics:else>
		<soap:body tagname="result">
			<result xsi:type="xsd:string"><%=ftMessage.failureStr%></result>
		</soap:body>
	</ics:else>
	</ics:if>
</soap:message>
</cs:ftcs>