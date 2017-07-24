<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
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
			<link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css" rel="stylesheet">
			<title>Enter Details</title>
		</head>
		<body>
			<div class="container">
				<satellite:form>
					<div class="row">
						<div class="col-md-4">Enter Age</div>
						<div class="col-md-8">
							<input type="number" name="age" />
						</div>
					</div>					
					<div class="row">
						<div class="col-md-4">Enter Gender</div>
						<div class="col-md-8">
							Male : <input type="radio" name="male" value="male" /><br/>
							Female : <input type="radio" name="female" value="female" /><br/>
							Other : <input type="radio" name="other" value="other" />
						</div>
					</div>						
					<div class="row">
						<input type="hidden" name="pagename" value="Snehal_Website/recommendation" />
						<input type="hidden" name="rid" value="1374098708970" />
					</div>						
					<div class="row">
						<input type="submit" class="btn btn-default" value="Load Recommendation" />
					</div>						
				</satellite:form>
			</div>
		</body>
	</html>
</cs:ftcs>
