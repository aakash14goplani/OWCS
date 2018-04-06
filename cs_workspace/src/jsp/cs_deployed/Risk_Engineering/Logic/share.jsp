<%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><% 
/******************************************************************************************************************************
   *    Element Name        :  Risk_Engineering/Logic/share 
   *    Author              :  Aakash Goplani 
   *    Creation Date       :  (21/04/2017) 
   *    Description         :  Element that shares assets of particular asset type from one site to another.
   *    Input Parameters    :  Variables required by this Element 
   *                            1. c
   *							2. cid (comma seperated)
   *							3. run (true/false)
   *    Output              :  	1. Display errors if any
   *							2. each assets in id : name format
   *							3. Total number of successfully shared assets
 *****************************************************************************************************************************/
%><cs:ftcs>
	<ics:if condition='<%=ics.GetVar("seid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry" />
		</ics:then>
	</ics:if>
	<ics:if condition='<%=ics.GetVar("eid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement" />
		</ics:then>
	</ics:if><%
	try{
		String assetType = ics.GetVar("c");
		String assetIdList = (Utilities.goodString(ics.GetVar("cid"))) ? ics.GetVar("cid") : "";
		String run = ics.GetVar("run");
		String query = "";
		int countBeforeSharing = 0, countAfterSharing = 0;
		String source_pubid = "1374098698899"/*from site*/, destination_pubid = "1492586991364";/*to site*/
		if( Utilities.goodString(assetType) ){
			if(assetIdList != null){
				assetIdList = assetIdList.replaceAll("\\W", ","); //replace all special characters if present in url with ',' as assetId list should be comma seperated 
				String where_clause = "asset.status != 'VO' and ap.assetid = asset.id and ap.pubid = " + source_pubid + " and ap.assetid not in (select ap2.assetid from AssetPublication ap2 where ap2.pubid=" + destination_pubid + ")";
				String and_clause = " and to_char(asset.updateddate, 'mm-yyyy') = '06-2017'";
				where_clause = where_clause + and_clause;
				query = (Utilities.goodString(assetIdList)) ? 
				"select asset.id, asset.name from " + assetType + " asset, AssetPublication ap where " + where_clause + " and asset.id in(" + assetIdList + ")" :
				"select asset.id, asset.name from " + assetType + " asset, AssetPublication ap where " + where_clause;
				out.println("Query : " + query + "<br/><br/>Sharable Assets : <br/><br/>");
				%><%-- execute sql if assetid and/or assettype are provided --%>					
				<ics:clearerrno/>
				<ics:sql sql='<%=query %>' table='<%=assetType + ",AssetPublication"%>' listname="pubid_list"/>
				<ics:if condition='<%=ics.GetList("pubid_list")!=null && ics.GetList("pubid_list").hasData()%>'>
					<ics:then>
						<%-- count assets before sharing --%>
						<ics:listget fieldname="#numRows" listname="pubid_list" output="before"/><%
						countBeforeSharing += (Utilities.goodString(ics.GetVar("before"))) ? Integer.valueOf(ics.GetVar("before")) : 0; 
						%><ics:listloop listname="pubid_list">
					    	<ics:listget listname="pubid_list" fieldname="id" output="asset_id"/>
					    	<ics:listget listname="pubid_list" fieldname="name" output="asset_name"/>
					    	<ics:getvar name="asset_id"/> : <ics:getvar name="asset_name"/><br/><br/>
					    	<ics:if condition='<%="true".equalsIgnoreCase(run) %>'>
					    		<ics:then>
					    			<asset:load name="publishAsset" type='<%=assetType %>' objectid='<%=ics.GetVar("asset_id") %>'/>
	            					<asset:share name="publishAsset" publist='<%=source_pubid + ";" + destination_pubid %>'/>
	            					<%out.println("Asset Share called"); %>
					        	</ics:then>
					        </ics:if>
					     </ics:listloop>		     
					</ics:then>
				</ics:if><%
				if(ics.GetErrno() != 0)
					out.println("Error Code : " + ics.GetErrno() + "<br/><br/>");
				%><%-- count assets after sharing --%>
				<ics:sql sql='<%=query %>' table='<%=assetType + ",AssetPublication"%>' listname="pubid_list"/>
				<ics:if condition='<%=ics.GetList("pubid_list")!=null && ics.GetList("pubid_list").hasData()%>'>
					<ics:then>
						<ics:listget fieldname="#numRows" listname="pubid_list" output="after"/><%
						countAfterSharing += (Utilities.goodString(ics.GetVar("after"))) ? Integer.valueOf(ics.GetVar("after")) : 0; 
					%></ics:then>
				</ics:if><%
			}
			out.println("Total number of successfully shared assets : " + (countBeforeSharing - countAfterSharing));
		}
		else{
			out.println("Error : AssetType not specified!");
		}
	}
	catch(Exception e){
		out.println("Error : " + e.getMessage());
	}
 %></cs:ftcs>