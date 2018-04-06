<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><cs:ftcs>
	<ics:if condition='<%=ics.GetVar("tid")!=null%>'>
    	<ics:then>
    		<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
    	</ics:then>
    </ics:if>

	<!DOCTYPE html>
	<html>

		<head>
			<title>Dropdowns Menu</title>
			<meta name="viewport" content="width=device-width, initial-scale=1">
			<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/Aakash_Goplani/css/style.css">
		</head>

		<body>	
			<div class="container">
							
	<%ics.LogMsg("Inside Navigation Template"); %>
	
	<!-- Load the Page Asset -->
	<asset:load name="HomeNavigation" type="Page" objectid='<%=ics.GetVar("cid")%>' flushonvoid="true" />
	<%
		int errLoad = ics.GetErrno();
		if(errLoad == 0){					
	 %>
		<!--  Get site node -->
		<asset:getsitenode name="HomeNavigation" output="PageNodeId"/>
		<%
			int errNodeId = ics.GetErrno();
			String pageNodeId = ics.GetVar("PageNodeId");
			if(errNodeId == 0 && !(" ").equals(pageNodeId) && pageNodeId != null){
		 %>
		 	<!-- Load Home page as a siteplan node object -->
			<siteplan:load name="ParentNode" nodeid='<%=ics.GetVar("PageNodeId") %>'/>
			
			<!-- Obtain Home page's child node, save in list and order them by their rank -->
			<siteplan:children name="ParentNode" list="ChildPages" order="nrank" code="Placed" objecttype="Page"/>
			
			<!-- Loop through list to get page names's under Home page node -->
			<ics:if condition='<%=ics.GetList("ChildPages") !=null %>'>
				<ics:listloop listname="ChildPages">
			  		<p><ics:listget listname="ChildPages" fieldname="id" output="aid"/></p>
			  		<asset:load name="ThePage" type="Page" objectid='<%=ics.GetVar("aid") %>' />
			  		<asset:get name="ThePage" field="name"/>
			  		<p><ics:getvar name="name"/></p>
			  		<%ics.LogMsg("Page aid : "+ics.GetVar("aid")+", Page name : "+ics.GetVar("name")); %>
				</ics:listloop>
			</ics:if>
			
			<%ics.LogMsg("-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*Method : 2-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-"); %>
			
			<siteplan:load name="ParentNode" nodeid='<%=ics.GetVar("PageNodeId") %>'/>
			<siteplan:listpages name="ParentNode" placedlist="placedPages" level="2" />
			<%--ics.LogMsg(ics.GetVar("placedPages")); --%>
			<!-- Loop through list to get page names under specified page node -->
			<ics:if condition='<%=ics.GetList("placedPages") != null %>'>
			 <ics:listloop listname="placedPages">
			  <ics:listget listname="placedPages" fieldname="PageName" output="abc"/>
			  <%ics.LogMsg(ics.GetVar("abc")); %>
			  <p><ics:getvar name="abc"/></p>
			 </ics:listloop>
			
			</ics:if>
		 <%
		 	}
		 	else{
				ics.LogMsg("error in Navigation Load : "+errNodeId+", PageNodeId : "+ics.GetVar("PageNodeId"));
			}
		  %>
	 <%
	 	}
	 	else{
	 		ics.LogMsg("error in Asset Load : "+errLoad);	
	 	}
	  %>
	  
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
  
		<script type="text/javascript" src="http://code.jquery.com/jquery-1.7.2.min.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath()%>/Aakash_Goplani/js/script.js"></script>	

		</body>
	</html>
</cs:ftcs>