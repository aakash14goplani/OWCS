<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,COM.FutureTense.Util.ftMessage,COM.FutureTense.Util.ftErrors"
%><cs:ftcs>
	<!DOCTYPE html>
	<html>

		<head>
			<title>Dropdowns Menu</title>
			<meta name="viewport" content="width=device-width, initial-scale=1">
			<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/Aakash_Goplani/css/style.css">
		</head>

		<body>
			<div class="container">
				<a class="toggleMenu" href="#">&#9776;</a>
				<ul class="nav">
					
					<li class="test">
						<a href="#">My Policies</a>
						<ul>
							<li>
								<a href="#">A</a>
							</li>
							<li>
								<a href="#">B</a>
							</li>
						</ul>
					</li>

					<li>
						<a href="#">Billing & Payment</a>
						<ul>
							<li>
								<a href="#">C</a>
							</li>
							<li>
								<a href="#">D</a>
							</li>
						</ul>
					</li>
					
					<li>
						<a href="#">Audit</a>
					</li>
					
					<li>
						<a href="#">Documnts</a>
						<ul>
							<li>
								<a href="#">Training</a>
							</li>
							<li>
								<a href="#">Webinar</a>
							</li>
						</ul>
					</li>
					
					<li>
						<a href="#">My Profile</a>
					</li>
					
					<li>
						<a href="#">Contact Us</a>
						<ul>
							<li>
								<a href="#">Secured</a>
							</li>
							<li>
								<a href="#">Un-Secured</a>
							</li>
						</ul>
					</li>
				</ul>
			</div>

        <%ics.LogMsg("Inside Navigation Template"); %>
	
	<!-- Load the Page Asset -->
	<%ics.LogMsg("c : "+ics.GetVar("c"));%>
	<%ics.LogMsg("cid : "+ics.GetVar("cid"));%>
	<%ics.LogMsg("tid : "+ics.GetVar("tid"));%>
	<%ics.LogMsg("site : "+ics.GetVar("site"));%>
	

			<script type="text/javascript" src="http://code.jquery.com/jquery-1.7.2.min.js"></script>
			<script type="text/javascript" src="<%=request.getContextPath()%>/Aakash_Goplani/js/script.js"></script>

		</body>

	</html>
</cs:ftcs>