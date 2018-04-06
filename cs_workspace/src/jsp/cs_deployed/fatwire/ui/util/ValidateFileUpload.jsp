<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// fatwire/ui/util/ValidateFileUpload
// This element provides a hook to add the custom logic to 
// validate the uploaded files.

// Don't modify this element. Write your code inside CustomElements
// CustomElements/fatwire/ui/util/ValidateFileUpload and it will be 
// automatically picked up.

// INPUT
// fileBytes as byte[]
// fileName as String

//
// OUTPUT
// fileValidated true or false
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<%
byte[] fileBytes = null;
String filename = ics.GetVar("fileName");

if(ics.GetObj("fileBytes") != null)
	fileBytes = (byte[])ics.GetObj("fileBytes");
// You have the bytes now for the uploaded file
// Write the file validaion logic here 
// to validate the uploaded data

// Perform the file validation and set the return value here.
// Change this only if you are a new validation
ics.SetVar("fileValidated","true");
%>
</cs:ftcs>