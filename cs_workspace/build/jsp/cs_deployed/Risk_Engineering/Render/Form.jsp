<%@page import="java.util.Map"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"%>
<%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"%>
<%@ page import="COM.FutureTense.Interfaces.*,
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
			<meta http-equiv='cache-control' content='no-cache'>
			<meta http-equiv='expires' content='0'>
			<meta http-equiv='pragma' content='no-cache'>
			<link href="Risk_Engineering\bootstrap\css\bootstrap.min.css" rel="stylesheet">
			<style type="text/css">
				body{
					background-color: aliceblue; 
				}
				.custom-div{
					background-color: burlywood;
					margin: 3px;
					padding: 6px;
					word-break: break-word;
				}
			</style>
		</head>
		<body class="container">
			<div class="row form-horizontal">
				<satellite:form>
					<div class="form-group">
						<label class="control-label">Age: <input type="number" name="age1" class="form-control"/>
						</label>
					</div>
					<div class="form-group">
						Gender: 
						<label class="control-label"><input type="checkbox" name="male1" class="form-control"  value="male"/>Male</label>
						<label class="control-label"><input type="checkbox" name="female1" class="form-control" value="female" />Female</label>
						<label class="control-label"><input type="checkbox" name="others1" class="form-control" value="others" />Others</label>
					</div>
					<div class="form-group">
						<input type="hidden" name="pagename" value="Risk_Engineering/Recommendation" />
						<input type="hidden" name="c" value="Page" />
						<input type="hidden" name="cid" value="1374098704618" />
					</div>
					<div class="form-group">
						<input type="submit" class="btn btn-default" value="GO" />
					</div>
				</satellite:form>
			</div>
		</body>
	</html>
</cs:ftcs>