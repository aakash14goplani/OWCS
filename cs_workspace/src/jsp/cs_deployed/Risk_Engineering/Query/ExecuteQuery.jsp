<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><cs:ftcs>
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
	<link rel="stylesheet" type="text/css" href="Risk_Engineering/bootstrap/css/bootstrap.min.css">
	<div class="container">
		<ics:clearerrno/>
		<ics:sql table="Publication" listname="rePubIdList" sql="select id from Publication where name='Risk_Engineering'" 
		limit="1" />
		<ics:if condition='<%=ics.GetErrno() == 0 %>'>
			<ics:then>
				<ics:listget fieldname="id" listname="rePubIdList" output="rePubId"/>
			</ics:then>
		</ics:if>
		<ics:clearerrno/>
		<ics:sql table="Publication" listname="agPubIdList" sql="select id from Publication where name='TheHartfordCom'" 
		limit="1" />
		<ics:if condition='<%=ics.GetErrno() == 0 %>'>
			<ics:then>
				<ics:listget fieldname="id" listname="agPubIdList" output="agPubId"/>
			</ics:then>
		</ics:if><% 
			String assetType = "CSElement", assetId = "1374098712454";
			
			String idInSiteA = "select assetid from AssetPublication where pubid=" + ics.GetVar("rePubId") + 
			"and assettype='" + assetType + "'";
			
			String idInSiteB = "select assetid from AssetPublication where pubid=" + ics.GetVar("agPubId")  + 
			"and assettype='" + assetType + "'";
			
			String uncommonAssets = "select assetid from AssetPublication where pubid=" + ics.GetVar("rePubId") + 
			"and assetid not in (select assetid from AssetPublication where pubid=" + ics.GetVar("agPubId") + ")" + 
			"and assettype='" + assetType + "'";
			
			String commonAssets = "select assetid from AssetPublication where pubid=" + ics.GetVar("rePubId") + 
			"and assetid in (select assetid from AssetPublication where pubid=" + ics.GetVar("agPubId") + ")" + 
			"and assettype='" + assetType + "'";
		%><div class="row"><ics:sql table="AssetPublication" listname="siteAList" sql='<%=idInSiteA %>' />
		<ics:sql table="AssetPublication" listname="siteBList" sql='<%=idInSiteB %>' />
		<ics:if condition='<%=null != ics.GetList("siteAList") && ics.GetList("siteAList").hasData() %>'>
			<ics:then>
				<div class="col-lg-3">
				Total Rows returned for Site A : <ics:listget fieldname="#numRows" listname="siteAList"/>, with pubid : 
				<ics:getvar name="rePubId"/><br/>
				<ics:listloop listname="siteAList">
					<ics:listget fieldname="assetid" listname="siteAList"/><br/>
				</ics:listloop>
				</div>			
			</ics:then>
		</ics:if>
		<ics:if condition='<%=null != ics.GetList("siteBList") && ics.GetList("siteBList").hasData() %>'>
			<ics:then>
				<div class="col-lg-3">
				Total Rows returned for Site B : <ics:listget fieldname="#numRows" listname="siteBList"/>, with pubid : 
				<ics:getvar name="agPubId"/><br/>
				<ics:listloop listname="siteBList">
					<ics:listget fieldname="assetid" listname="siteBList"/><br/>
				</ics:listloop>	
				</div>		
			</ics:then>
		</ics:if>
		<ics:sql table="AssetPublication" listname="uncommonAssetsList" sql='<%=uncommonAssets %>' />
		<ics:if condition='<%=null != ics.GetList("uncommonAssetsList") && ics.GetList("uncommonAssetsList").hasData() %>'>
			<ics:then>
				<div class="col-lg-3">
				Total Rows returned for UnCommon Assets : <ics:listget fieldname="#numRows" listname="uncommonAssetsList"/>
				<br/>
				<ics:listloop listname="uncommonAssetsList">
					<ics:listget fieldname="assetid" listname="uncommonAssetsList"/><br/>
				</ics:listloop>	
				</div>		
			</ics:then>
		</ics:if>
		<ics:sql table="AssetPublication" listname="commonAssetsList" sql='<%=commonAssets %>' />
		<ics:if condition='<%=null != ics.GetList("commonAssetsList") && ics.GetList("commonAssetsList").hasData() %>'>
			<ics:then>
				<div class="col-lg-3">
				Total Rows returned for Common Assets : <ics:listget fieldname="#numRows" listname="commonAssetsList"/>
				<br/>
				<ics:listloop listname="commonAssetsList">
					<ics:listget fieldname="assetid" listname="commonAssetsList"/><br/>
				</ics:listloop>	
				</div>		
			</ics:then>
		</ics:if>
		</div><%
			String source_pubid = ics.GetVar("rePubId"), destination_pubid = ics.GetVar("agPubId");
			
			String oldQuery = "select asset.id, asset.name from " + assetType + " asset, AssetPublication ap " +
			"where asset.status != 'VO' and asset.id = ap.assetid and ap.pubid = " + source_pubid;
			
			String newQueryType = "select asset.id, asset.name from " + assetType + " asset, AssetPublication ap " +
			"where asset.status != 'VO' and asset.id = ap.assetid and ap.pubid = " + source_pubid + " and ap.assetid" + 
			" not in (select ap2.assetid from AssetPublication ap2 where ap2.pubid=" + destination_pubid + ")";
			
			String oldQueryId = "select asset.id, asset.name from " + assetType + " asset, AssetPublication ap where" +
			" asset.status != 'VO' and asset.id = " + assetId + " and ap.assetid = " + assetId + " and ap.pubid = " 
			+ source_pubid;
			
			String newQueryId = "select asset.id, asset.name from " + assetType + " asset, AssetPublication ap " +
			"where asset.status != 'VO' and asset.id = " + assetId + " and ap.pubid = " + source_pubid + " and ap.assetid" + 
			" not in (select ap2.assetid from AssetPublication ap2 where ap2.pubid=" + destination_pubid + ") and " +
			"ap.assetid=" + assetId;
		%><ics:sql table='<%=assetType + ",AssetPublication" %>' listname="oldQueryList" sql='<%=oldQuery %>' />
		<ics:sql table='<%=assetType + ",AssetPublication" %>' listname="newQueryList" sql='<%=newQueryType %>' />
		<ics:sql table='<%=assetType + ",AssetPublication" %>' listname="oldQueryList2" sql='<%=oldQueryId %>' />
		<ics:sql table='<%=assetType + ",AssetPublication" %>' listname="newQueryList2" sql='<%=newQueryId %>' />
		<br/><br/><div class="row">
		<ics:if condition='<%=null != ics.GetList("oldQueryList") && ics.GetList("oldQueryList").hasData() %>'>
			<ics:then>
				<div class="col-lg-3">
				Total Rows returned for oldQuery : <ics:listget fieldname="#numRows" listname="oldQueryList"/><br/>
				<ics:listloop listname="oldQueryList">
					<ics:listget fieldname="id" listname="oldQueryList"/> : 
					<ics:listget fieldname="name" listname="oldQueryList"/><br/>
				</ics:listloop>
				</div>			
			</ics:then>
		</ics:if>
		<ics:if condition='<%=null != ics.GetList("newQueryList") && ics.GetList("newQueryList").hasData() %>'>
			<ics:then>
				<div class="col-lg-3">
				Total Rows returned for newQuery : <ics:listget fieldname="#numRows" listname="newQueryList"/><br/>
				<ics:listloop listname="newQueryList">
					<ics:listget fieldname="id" listname="newQueryList"/> : 
					<ics:listget fieldname="name" listname="newQueryList"/><br/>
				</ics:listloop>	
				</div>		
			</ics:then>
		</ics:if>
		<ics:if condition='<%=null != ics.GetList("oldQueryList2") && ics.GetList("oldQueryList2").hasData() %>'>
			<ics:then>
				<div class="col-lg-3">
				Total Rows returned for oldQuery2 : <ics:listget fieldname="#numRows" listname="oldQueryList2"/><br/>
				<ics:listloop listname="oldQueryList2">
					<ics:listget fieldname="id" listname="oldQueryList2"/> : 
					<ics:listget fieldname="name" listname="oldQueryList2"/><br/>
				</ics:listloop>
				</div>			
			</ics:then>
		</ics:if>
		<ics:if condition='<%=null != ics.GetList("newQueryList2") && ics.GetList("newQueryList2").hasData() %>'>
			<ics:then>
				<div class="col-lg-3">
				Total Rows returned for newQuery2 : <ics:listget fieldname="#numRows" listname="newQueryList2"/><br/>
				<ics:listloop listname="newQueryList2">
					<ics:listget fieldname="id" listname="newQueryList2"/> : 
					<ics:listget fieldname="name" listname="newQueryList2"/><br/>
				</ics:listloop>	
				</div>		
			</ics:then>
		</ics:if>
		</div>
	</div>
</cs:ftcs>