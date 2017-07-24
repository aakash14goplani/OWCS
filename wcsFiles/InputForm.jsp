<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
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
			<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
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
							Male : <input type="radio" name="gender" value="male" /><br/>
							Female : <input type="radio" name="gender" value="female" /><br/>
							Other : <input type="radio" name="gender" value="other" />
						</div>
					</div>						
					<div class="row">
						<input type="hidden" name="pagename" value="recommendation" />
						<input type="hidden" name="rid" value="1374098710121" />
					</div>						
					<div class="row">
						<input type="submit" class="btn btn-default" value="Load Recommendation" />
					</div>						
				</satellite:form>
			</div>
		</body>
	</html>
</cs:ftcs>