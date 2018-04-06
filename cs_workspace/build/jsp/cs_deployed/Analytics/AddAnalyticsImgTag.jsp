<%@page import="java.security.MessageDigest"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%//
// fatwire/Analytics/AddAnalyticsImgTag
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="javax.servlet.*" session="false"%> 
<%@ page import="java.util.*,com.fatwire.analytics.cstracking.*" session="false"%> 
<%@ page import="com.fatwire.analytics.cstracking.AnalyticsTrackingProxy" session="false"%>

<cs:ftcs>

<property:get param="analytics.enabled" inifile="futuretense_xcel.ini" varname="analyticsEnabled"/>
<%
	// Just go away quietly if analytics is not enabled. This is redundant because most routines
	// do their own check but check here just in case someone forgot. 
	String enabled = ics.GetVar("analyticsEnabled");
	if( enabled == null || !enabled.equalsIgnoreCase("true") ) {
		return;
	}

	// Pickup variables that are used by the logic within this element. These may be
	// modified and are eventually passed on to the tracking code generator(s)
	String objid     = ics.GetVar("cid");
	String objname   = ics.GetVar("pagename");
	String objtype   = ics.GetVar("c");
	String recid     = ics.GetVar("recid");
	String recname   = "";
	String segmentid = "";
	String segname   = ""; 
	
	if ( objname == null || objname.length() < 1 ) {
		// When objname is not defined then derive the object name automagically. This takes care
		// of the situation where the minimum number of parameters are supplied (not including pagename).
		%>
		<asset:list type='<%= objtype %>' list="mymissingasset" field1="id" value1='<%= objid%>'/>
		<ics:listloop listname="mymissingasset">
			<ics:listget listname="mymissingasset" fieldname="name" output="missingassetname"/>
		</ics:listloop>
		<%
		if ( (objname = ics.GetVar("missingassetname")) == null ) { 
			objname = "unknown";
		}
	}

	if ( objtype.equalsIgnoreCase("RECASKED") || objtype.equalsIgnoreCase("RECLISTED") ) {
		// Engage already built the segment id list so just get what was passed in the call. 
		segmentid = ics.GetVar("segmentidlist");
		recname = objname; 	
	}
	else {
		if (recid != null) {
			int counter = 0;
			%>
			<commercecontext:getsegments listvarname="segmentlist"/>
			<%
			int listsizeSeg = ics.GetList("segmentlist").numRows();
			%>
			<ics:if condition='<%= ics.GetList("segmentlist") != null && ics.GetList("segmentlist").hasData() %>'>
				<ics:then>
					<ics:listloop listname="segmentlist">
						<ics:listget listname="segmentlist" fieldname="assetid" output="segid"/>
						<%
						counter++;
						// Note: multiple segments are not supported in Falcon and upwards but the
						// code is left in place just in case it is never needed again. 
						segmentid = segmentid + ics.GetVar("segid");
						if (counter != listsizeSeg) {
							segmentid = segmentid + ",";
						}
						%>
					</ics:listloop>
				</ics:then>
			</ics:if>
			<%
			// When no segment was found: default to segment 0
			if (counter == 0) {
				segmentid = "0";
			}
		}
	}
	
	// If there a segment and it is not segment 0 then get the segment name
	if ( segmentid.length() > 0 && !segmentid.equals("0") ) {
		// If there are multiple segments here then just get the name for the 
		// first in the list. 
		String[] segments = segmentid.split(","); 
		String firstSegment = segments[0]; 
		%>	
		<asset:load name="mysegment" type="Segments" objectid="<%= firstSegment%>" />
		<asset:get  name="mysegment" field="name" output="segmentname" />
		<%
		segname = ics.GetVar("segmentname"); 
	}
	
	// If there is a recommendation then get its name
	if ( recid != null ) {
		%>
		<asset:load name="myrecommend" type="AdvCols" objectid="<%= recid%>" />
		<asset:get  name="myrecommend" field="name" output="recommendname" />
		<%
		recname = ics.GetVar("recommendname");
		%>
		<asset:list type='<%= objtype %>' list="myasset" field1="id" value1='<%= objid%>'/>
		<ics:if condition='<%= ics.GetList("myasset") != null && ics.GetList("myasset").hasData() %>'>
			<ics:then>
				<ics:listloop listname="myasset">
					<ics:listget listname="myasset" fieldname="name" output="assetname"/>
				</ics:listloop>
			</ics:then>
		</ics:if>
		<%
		String xobjname = ics.GetVar("assetname");
		if ( xobjname != null ) {
			objname = xobjname; 
		}
	}

	// Access the servlet context and pickup inipath parameter. This is needed so the 
	// content server ini parameters for analytics can be retrieved and cached. This 
	// minimizes the instruction path length for getting these static values over many
	// tracking requests. 
	ServletContext ctx = getServletContext();
	String inipath = ctx.getInitParameter("inipath"); 
	
	// Get reference to implementation proxy. If it is not initialized that will be done
	// behind the scenes and all implementation classes loaded. 
	AnalyticsTrackingProxy proxy = AnalyticsTrackingProxy.getAnalyticsTrackingProxy(inipath);	
	
	// Build the input parameter map. This contains all the standard arguments to be
	// passed to the tracking code implementation(s). 
	HashMap<String,String> inpParams = new HashMap<String,String>(); 

	// Note that each implementation should look for input parameters based on the
	// names used to populate the map.
	String sessionId = request.getSession(true).getId().replaceAll(" ","");
	
	// Generate a fake session id which will be unique for a particular user session
	// to be passed inside the get request.
	MessageDigest digest = MessageDigest.getInstance("SHA-256");
	digest.update(sessionId.getBytes());
	byte[] shaCheckSum = digest.digest();
	StringBuffer sessionIdBuffer = new StringBuffer();
	for(int bytesCount = 0; bytesCount < shaCheckSum.length; bytesCount++)
	{
		sessionIdBuffer.append(Integer.toHexString(0xFF & shaCheckSum[bytesCount]));
	}
	sessionId = sessionIdBuffer.toString();
	
	inpParams.put("sessionid", sessionId);
	inpParams.put("segid", segmentid);
	inpParams.put("segname", segname);
	inpParams.put("recid", recid); 
	inpParams.put("recname", recname); 
	inpParams.put("objid", objid);
	inpParams.put("objurl", ics.GetVar("objUrl"));	
	inpParams.put("objtype", objtype); 
	inpParams.put("objname", objname);
	inpParams.put("sitename", ics.GetVar("site")); 
	inpParams.put("referer", request.getHeader("Referer"));
	inpParams.put("objlistid", ics.GetVar("objlistid"));
	inpParams.put("objlisttype", ics.GetVar("objlisttype"));
	inpParams.put("objlistname", ics.GetVar("objlistname")); 

	// Get combined optional parameters for all implementations. These are call parameters 
	// that are optional and used by the specific implementations. 
	ArrayList<String> optParams = proxy.getOptionalParameters();
	
	// Merge any optional parameters. If the parameter does not exist then there
	// is nothing to add to the map. 
	for (String key : optParams ) {
		String value = ics.GetVar(key); 
		if ( value != null ) {
			inpParams.put(key, value); 
		}
	}
	
	// Generate the tracking sequences. All implementations are called in order of
	// inifile specification and the returned string contains all generated statements. 
	String tracking = proxy.generateTrackingCode(inpParams);
	%>
<%= tracking %>	
</cs:ftcs>
