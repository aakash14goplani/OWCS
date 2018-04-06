<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><cs:ftcs><!DOCTYPE html>
<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<!DOCTYPE html>
<html>
<head>
	<title>Dropdowns Menu</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/avisports/css/style.css">
</head>
<body>
<div class="container">
	
<a class="toggleMenu" href="#">&#9776; Menu</a>
<ul class="nav">
	<li  class="test">
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

<script type="text/javascript" src="http://code.jquery.com/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/avisports/js/script.js"></script>
</body>
</html>
</cs:ftcs>