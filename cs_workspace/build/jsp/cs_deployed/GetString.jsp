<%@page import="java.util.Map"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   COM.FutureTense.Util.ftErrors"
%>
<cs:ftcs>
	<%-- Record dependencies for the SiteEntry and the CSElement --%>
	<ics:if condition='<%=ics.GetVar("seid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry" />
		</ics:then>
	</ics:if>
	<ics:if condition='<%=ics.GetVar("eid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement" />
		</ics:then>
	</ics:if>
<html>
	<head>
		<link href="Risk_Engineering\bootstrap\css\bootstrap.min.css" rel="stylesheet">
	</head>
	<body>
		<table class="table table-bordered table-hover table-responsive">
			<thead>
				<tr>
					<th>KEY</th>
      				<th>VALUE</th>
      			</tr>
			</thead>
			<tbody>
<%
	for(int index = 1; index <= 2; index++){
		if(index == 1){
%>
			<ics:sql sql="select * from HIG_MultiMedia_C" listname="multimediaAssetsList" table="HIG_MultiMedia_C" />
<%
			IList multimediaAssetList = ics.GetList("multimediaAssetsList");
			String assetType = "HIG_MultiMedia_C";
			for(int i = 1; i<= multimediaAssetList.numRows(); i++){
				multimediaAssetList.moveTo(i);
				String assetId = multimediaAssetList.getValue("id");
				FTValList inList = new FTValList();
				inList.put("cid",assetId);
				inList.put("c",assetType);
				if(assetId != null && assetType != null)
					ics.CallElement("Risk_Engineering/Logic/LoadAssetInfoEJ", inList);	
				else
					ics.LogMsg("Null Asset Id / Type passed in Load Asset to Call Get Asset from GetString");
				Map<String, String> temp = (Map<String, String>)ics.getAttribute("attributeMap");
				for (Map.Entry<String, String> entry : temp.entrySet()) {
				    String key = entry.getKey().substring(entry.getKey().indexOf(':')+1);
				    String value = entry.getValue();
%>
					<tr>
						<td><%=key %></td>
						<td><%=value %></td>
					</tr> 
<%
				    //out.println("Key : "+key+", Value : "+value+"<br/>");
				}		
			}			
		}
		if(index == 2){
%>
			<ics:sql sql="select * from HIG_ComponentWidget_C" listname="componentAssetsList" table="HIG_ComponentWidget_C" />
<%
			IList componentAssetsList = ics.GetList("componentAssetsList");
			String assetType = "HIG_ComponentWidget_C";
			for(int i = 1; i<= componentAssetsList.numRows(); i++){
				componentAssetsList.moveTo(i);
				String assetId = componentAssetsList.getValue("id");
				FTValList inList = new FTValList();
				inList.put("cid",assetId);
				inList.put("c",assetType);
				if(assetId != null && assetType != null)
					ics.CallElement("Risk_Engineering/Logic/LoadAssetInfoEJ", inList);	
				else
					ics.LogMsg("Null Asset Id / Type passed in Load Asset to Call Get Asset from GetString");
				Map<String,String> temp2 = (Map<String, String>)ics.getAttribute("attributeMap");
				for (Map.Entry<String, String> entry : temp2.entrySet()) {
				    String key2 = entry.getKey().substring(entry.getKey().indexOf(':')+1);
				    String value2 = entry.getValue();
%>
					<tr>
						<td><%=key2 %></td>
						<td><%=value2 %></td>
					</tr>
<%
				    //out.println("Key : "+key2+", Value : "+value2);
				}		
			}	
		}
	}
 %>
 			</tbody>
 		</table>
	</body>	
</html>
</cs:ftcs>