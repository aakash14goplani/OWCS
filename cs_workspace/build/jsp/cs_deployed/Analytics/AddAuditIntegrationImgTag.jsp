<%@page import="java.security.MessageDigest"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%//
// fatwire/Analytics/AddAuditIntegrationImgTag
// Create/Edit/Delete Analytics Audit Integration. This is used within ContentServer so therefore we do not
// need <noscript> sensor. It's called from PostUpdate elements of assettypes. An image beacon is used to invoke
// the analytics sensor. 
//
// INPUT
//
// OUTPUT
//%>

<cs:ftcs>
<property:get param="analytics.enabled" inifile="futuretense_xcel.ini" varname="analyticsEnabled"/>
<property:get param="analytics.datacaptureurl" inifile="futuretense_xcel.ini" varname="datacaptureurl"/>

<%
    //Double checking analytics enabled property for safety incase this element needs to be called else where.
    String enabled = ics.GetVar("analyticsEnabled");
    if(!enabled.equalsIgnoreCase("true"))
    {
        return;
    }

    String TsessionID = request.getSession(true).getId();
    //Why do we need this here?
    TsessionID = TsessionID.replaceAll(" ", "");
    
	// Generate a fake session id which will be unique for a particular user session
	// to be passed inside the get request.
	MessageDigest digest = MessageDigest.getInstance("SHA-256");
	digest.update(TsessionID.getBytes());
	byte[] shaCheckSum = digest.digest();
	StringBuffer sessionIdBuffer = new StringBuffer();
	for(int bytesCount = 0; bytesCount < shaCheckSum.length; bytesCount++)
	{
		sessionIdBuffer.append(Integer.toHexString(0xFF & shaCheckSum[bytesCount]));
	}
	TsessionID = sessionIdBuffer.toString();
	
    String id = "";
    String optype = "";
    String objtype = ics.GetVar("AssetType");
    String UobjType = objtype.toUpperCase();

    String statisticSensorPath = ics.GetVar("datacaptureurl");

    //From session variables
    String csuserid = ics.GetSSVar("username");
    String siteName = ics.GetSSVar("PublicationName");

    //Retrieve asset related variables
    id = ics.GetVar("id");
    optype = ics.GetVar("updatetype");
    
    if(optype != null && optype.trim().length() > 0)
    {	
	    if(optype.equals("delete"))
	    {
	       ics.SetVar("assetname", ics.GetVar("name")); //for Delete, the assetname is stored in different variable.
	    }
	    else
	    {
	%>
	       <asset:list type='<%= objtype %>' list="myasset" field1="id" value1='<%= id%>'/>
	        <ics:listloop listname="myasset">
	        <ics:listget listname="myasset" fieldname="name" output="assetname"/>
	       </ics:listloop>
	<%
	    }
	  //script to invoke analytics sensor
	%>
	    <script type="text/javascript">
	     <!--
	        var jsParam = '';
	        if(self.StatPixelParamFromPage) {jsParam=StatPixelParamFromPage;};
	        var size = 'n/a';
	        var puri = '';
	        var nav = navigator.appName;
	        var agent = navigator.userAgent;
	        var objValue = '';
	        var ref = document.referrer;
	        var write = (navigator.appName=='Netscape' && (navigator.appVersion.charAt(0)=='2' || navigator.appVersion.charAt(0)=='3')) ? false:true;
	        if (write==true) {
	           size = screen.width + "x" + screen.height;
	           objValue= encodeURIComponent('<%= ics.GetVar("assetname") %>');
	           puri = '?siteName=<%= siteName %>&objType=<%= UobjType %>&objID=<%= id %>&objName=' +objValue+'&sessionID=<%= TsessionID %>&Referer='+ref.replace(/&/g, "[amp]")+'&nav='+nav+'&agent='+agent+'&size='+size+'&js=true'+jsParam+'&optype=<%= optype %>&csuserid=<%=csuserid%>';
	           pixel = new Image();
	 	       pixel.src = "<%= statisticSensorPath %>" + puri;
	        }
	     //-->
	    </script>
	<%
    	}
	%>
</cs:ftcs>


