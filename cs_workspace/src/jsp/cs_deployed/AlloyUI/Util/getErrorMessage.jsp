<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%//
// AlloyUI/Util/getErrorMessage
// This template is used to retrieve error messages stored in XML elements (OpenMarket/Xcelerate/Errors)
// When a service encounters an error it should return either an errormessage or a reference to the error element
// to be called. This class is just used to retrieve the corresponding error  message
// INPUT: element name, sElem
//
// OUTPUT: error message, sErrorMessage
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.fatwire.cs.ui.exception.service.ServiceErrorRetriever"%>

<cs:ftcs>

<!-- We selectively pass some parameters to the called template. This list is empirically determined. More may be needed -->
<render:getpageurl pagename="AlloyUI/Util/XMLErrorWrapper" outstr="theURL">
	<render:argument name="sElementName" value='<%=ics.GetVar("sElementName")%>' />
	<!-- The following two session variables need to be repopulated in the new http request for correct results
	This list is again empirically determined -->
	<render:argument name="PublicationName" value='<%=ics.GetSSVar("PublicationName")%>' />
	<render:argument name="Locale" value='<%=ics.GetSSVar("Locale")%>' />
	<%
		String sAssetType = ics.GetVar("AssetType");
		if( (null != sAssetType) && (!sAssetType.equals("")) )
		{
	%>
			<render:argument name="AssetType" value='<%=sAssetType %>' />
	<%
		}

		String sID = ics.GetVar("id");
		if( (null != sID) && (!sID.equals("")) )
		{
	%>
			<render:argument name="id" value='<%=sID %>' />
	<%
		}

		String sErrno = ics.GetVar("errno");
		if( (null != sErrno) && (!sErrno.equals("")) )
		{
	%>
			<render:argument name="errno" value='<%=sErrno %>' />
	<%
		}

		String sErrorDetails = ics.GetVar("errordetails");
		if( (null != sErrorDetails) && (!sErrorDetails.equals("")) )
		{
	%>
			<render:argument name="errordetails" value='<%=sErrorDetails %>' />
	<%
		}

		String sChildType = ics.GetVar("childtype");
		if( (null != sChildType) && (!sChildType.equals("")) )
		{
	%>
			<render:argument name="childtype" value='<%=sChildType %>' />
	<%
		}

		String sChildID = ics.GetVar("childid");
		if( (null != sChildID) && (!sChildID.equals("")) )
		{
	%>
			<render:argument name="childid" value='<%=sChildID %>' />
	<%
		}

		String sSaveErrorno = ics.GetVar("saveerrorno");
		if( (null != sSaveErrorno) && (!sSaveErrorno.equals("")) )
		{
	%>
			<render:argument name="saveerrorno" value='<%=sSaveErrorno %>' />
	<%
		}

		String sErrorAssetName = ics.GetVar("errorassetname");
		if( (null != sErrorAssetName) && (!sErrorAssetName.equals("")) )
		{
	%>
			<render:argument name="errorassetname" value='<%=sErrorAssetName %>' />
	<%
		}

		String sLockedBy = ics.GetVar("lockedby");
		if( (null != sLockedBy) && (!sLockedBy.equals("")) )
		{
	%>
			<render:argument name="lockedby" value='<%=sLockedBy %>' />
	<%
		}

		String sErrDetail1 = ics.GetVar("errdetail1");
		if( (null != sErrDetail1) && (!sErrDetail1.equals("")) )
		{
	%>
			<render:argument name="errdetail1" value='<%=sErrDetail1 %>' />
	<%
		}

		String sDelegateUser = ics.GetVar("delegateuser");
		if( (null != sDelegateUser) && (!sDelegateUser.equals("")) )
		{
	%>
			<render:argument name="delegateuser" value='<%=sDelegateUser %>' />
	<%
		}
		
		String sDenialReason = ics.GetVar("denialreason");
		if( (null != sDenialReason) && (!sDenialReason.equals("")) )
		{
	%>
			<render:argument name="denialreason" value='<%=sDenialReason %>' />
	<%
		}
		String sfunctionName = ics.GetVar("functionname");
		if( (null != sfunctionName) && (!sfunctionName.equals("")) )
		{
		%>
			<render:argument name="functionname" value='<%=sfunctionName %>' />
		<%
		}		
	%>
</render:getpageurl>

<%
	String sHost = request.getServerName();
	int sPort = request.getServerPort();
	String sErrorMessage = "";//ServiceErrorRetriever.getResultfromURL(ics.GetVar("theURL"), sHost, sPort);
%>

<ics:setvar name="sAlloyErrorMessage" value='<%=sErrorMessage%>' />

</cs:ftcs>