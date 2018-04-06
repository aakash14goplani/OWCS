<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors"
%><%@ page import="java.io.BufferedReader,
					java.io.IOException,
					java.io.InputStreamReader,
					java.io.DataInputStream,
					java.io.File,
					java.nio.file.*,
					java.net.HttpURLConnection,
					java.net.MalformedURLException,
					java.net.URL"
%><cs:ftcs><%-- /Demo_Template

INPUT

OUTPUT

--%>
<%-- Record dependencies for the Template --%>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'>
	<ics:then>
		<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
	</ics:then>
</ics:if>

<%
	String assetType = ics.GetVar("c");
	String assetId = ics.GetVar("cid");
	String site = ics.GetVar("site");
	String baseURI = "http://localhost:9080/cs/REST";
	
	/*
		Asset Type : 
		1. All Asset Types : /types : Reads all the asset types of system (G)
		2. Selected Asset Types : /types/{assettype} (GPD)
		3. Site-Enabled Asset Types : /sites/{sitename}/types (G)
		
		Asset :
		1. Selected Asset, Selected Site : /sites/{sitename}/types/{assettype}/assets/{id} (CURD)
	*/
	
	String allAsset = baseURI+"/types";
	String selectedAssetTypes = allAsset+"/"+assetType;
	String siteEnabledAsset = baseURI+"/sites/"+site+"/types";
	String selectedAssetSelectedSite = siteEnabledAsset+"/"+assetType+"/assets/"+assetId;
	
	out.println("Asset Type : "+assetType);
	out.println("<br />Asset Id : "+assetId);
	out.println("<br />Site : "+site);
	out.println("<br />Base URI : "+baseURI);
	out.println("<br />All Asset Type : "+allAsset);
	out.println("<br />Selected Asset Types : "+selectedAssetTypes);
	out.println("<br />Site-Enabled Asset Types : "+siteEnabledAsset);
	out.println("<br />Selected Asset, Selected Site : "+selectedAssetSelectedSite);
	
	try {
		URL url = new URL(siteEnabledAsset);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("GET");
		conn.setRequestProperty("Accept", "application/json");

		if (conn.getResponseCode() != 200) {
			ics.LogMsg("Status other than 200!!! : ");
			throw new RuntimeException("Failed : HTTP error code : "+ conn.getResponseCode());
		}
		
		ics.LogMsg("Status is 200!!! : ");
		ics.LogMsg("Response Code : "+conn.getResponseCode());

		BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
		
		//JSONObject json = new JSONObject();

		/*String output;
		out.println("Output from Server .... <br />");
		ics.LogMsg("Output from Server .... ");
		while ((output = br.readLine()) != null) {
			out.println(output);
			ics.LogMsg("Output : "+output);
		}*/
		
		String command = "curl -i -H "+"\"Accept: application/json\""+" -X GET "+
		"\"http://localhost:9080/cs/REST/resources/v1/aggregates/Demo/Demo_C/1374098684469\"";
		String outputString = "";
		out.println("<br/>Command : "+command+"<br/>");
		
		Process curlProc;
		out.println("<br/>Before : <br/>");	    
	    curlProc = Runtime.getRuntime().exec(command);	
	    out.println("<br/>After : <br/>");
	    DataInputStream curlIn = new DataInputStream(curlProc.getInputStream());
	
	    while ((outputString = curlIn.readLine()) != null) {
	    	out.println(outputString);
	        ics.LogMsg("Curl Output : "+outputString);
	    }
	        
		conn.disconnect();

	  } catch (Exception e) {
	  	out.println(e);
	  	ics.LogMsg("Exception : "+e);
	  }
 %>


</cs:ftcs>