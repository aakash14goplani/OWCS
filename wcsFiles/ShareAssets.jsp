<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<cs:ftcs>
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
<%
	try{
		String assetType = ics.GetVar("c");
		String assetIdList = ics.GetVar("cid");
		String run = ics.GetVar("run");
		String query = "";
		String source_pubid = "1374098698899", destination_pubid = "1492586991364";
		if(assetType != null && !"".equals(assetType)){
			String totalAssets = "select COUNT(*) as total from AssetPublication where assettype = '" + assetType + "' and pubid = " + destination_pubid;
			if(assetIdList != null && !"".equals(assetIdList)){
				for(String assetId : assetIdList.split(",")){
					query = "select asset.id, asset.name from " + assetType + " asset, AssetPublication ap where asset.status != 'VO' and asset.id = " + assetId + " and ap.assetid = " + assetId + " and ap.pubid = " + source_pubid;
%>
					<!-- count assets before sharing -->
					<ics:sql sql='<%=totalAssets %>' table="AssetPublication" listname="shared_list"/>				
					<ics:if condition='<%=ics.GetList("shared_list")!=null && ics.GetList("shared_list").hasData()%>'>
						<ics:then>
							<ics:listloop listname="shared_list">
						    <ics:listget listname="shared_list" fieldname="total" output="before"/>
						    </ics:listloop>		     
						</ics:then>
					</ics:if>
					<!-- execute sql if assetid and assettype bot are provided -->					
					<ics:clearerrno/>
					<ics:sql sql='<%=query %>' table='<%=assetType %>' listname="pubid_list"/>
					<ics:if condition='<%=ics.GetList("pubid_list")!=null && ics.GetList("pubid_list").hasData()%>'>
						<ics:then>
							<ics:listloop listname="pubid_list">
						    	<ics:listget listname="pubid_list" fieldname="id" output="asset_id"/>
						    	<ics:listget listname="pubid_list" fieldname="name" output="asset_name"/>
						    	<ics:getvar name="asset_id"/> : <ics:getvar name="asset_name"/><br/><br/>
						    	<ics:if condition='<%="true".equalsIgnoreCase(run) %>'>
						    		<ics:then>
						    			<asset:load name="publishAsset" type='<%=assetType %>' objectid='<%=ics.GetVar("asset_id") %>'/>
		            					<asset:share name="publishAsset" publist='<%=source_pubid + ";" + destination_pubid %>'/>
						        	</ics:then>
						        </ics:if>
						     </ics:listloop>		     
						</ics:then>
					</ics:if>
					Error : <ics:geterrno/><br/><br/>
<%
				}
			}
			else{
				query = "select asset.id, asset.name from " + assetType + " asset, AssetPublication ap where asset.status != 'VO' and asset.id = ap.assetid and ap.pubid = " + source_pubid;
%>
				<!-- count assets before sharing -->
				<ics:sql sql='<%=totalAssets %>' table="AssetPublication" listname="shared_list"/>				
				<ics:if condition='<%=ics.GetList("shared_list")!=null && ics.GetList("shared_list").hasData()%>'>
					<ics:then>
						<ics:listloop listname="shared_list">
					    <ics:listget listname="shared_list" fieldname="total" output="before"/><br/>
					    </ics:listloop>		     
					</ics:then>
				</ics:if>
				<!-- execute sql if only assettype is provided -->
				<ics:clearerrno/>
				<ics:sql sql='<%=query %>' table='<%=assetType %>' listname="pubid_list"/>
				<ics:if condition='<%=ics.GetList("pubid_list")!=null && ics.GetList("pubid_list").hasData()%>'>
					<ics:then>
						<ics:listloop listname="pubid_list">
					    	<ics:listget listname="pubid_list" fieldname="id" output="asset_id"/>
					    	<ics:listget listname="pubid_list" fieldname="name" output="asset_name"/>
					    	<ics:getvar name="asset_id"/> : <ics:getvar name="asset_name"/><br/>
					    	<ics:if condition='<%="true".equalsIgnoreCase(run) %>'>
						    	<ics:then>
						    		<asset:load name="publishAsset" type='<%=assetType %>' objectid='<%=ics.GetVar("asset_id") %>'/>
		            				<asset:share name="publishAsset" publist='<%=source_pubid + ";" + destination_pubid %>'/>
						       	</ics:then>
						    </ics:if>        
					     </ics:listloop>		     
					</ics:then>
				</ics:if>
				Error : <ics:geterrno/><br/><br/>
<%
			}
%>
				<!-- count assets after sharing -->
				<ics:clearerrno/>
				<ics:sql sql='<%=totalAssets %>' table="AssetPublication" listname="shared_list"/>				
				<ics:if condition='<%=ics.GetList("shared_list")!=null && ics.GetList("shared_list").hasData()%>'>
					<ics:then>
						<ics:listloop listname="shared_list">
							<ics:listget listname="shared_list" fieldname="total" output="after"/><br/>
						</ics:listloop>		     
					</ics:then>
				</ics:if>
<%
			int before = Integer.valueOf(ics.GetVar("before"));
			int after = Integer.valueOf(ics.GetVar("after"));
			out.println("Total # of successfully shared assets : " + (after - before));
		}
		else{
			out.println("Error : AssetType not specified!");
		}
	}
	catch(Exception e){
		out.println("Error : " + e.getMessage());
	}
 %>
</cs:ftcs>