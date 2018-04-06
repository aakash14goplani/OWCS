<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"%>
<%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="vdm" uri="futuretense_cs/vdm.tld"%>
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
<%
	String recommendationId = ics.GetVar("rid");
	String age = ics.GetVar("age");
	String male = ics.GetVar("male");
	String female = ics.GetVar("female");
	String other = ics.GetVar("other");	
	if(age != null && !"".equals(age)){
		out.println("Scalar Age :  "  + age + "<br/>");
%>
		<vdm:setscalar attribute="SM_AGE" value='<%=age%>'/>
<%
	}if(male != null && !"".equals(male)){
		out.println("Scalar Gender :  "  + male + "<br/>");
%>
		<vdm:setscalar attribute="SM_GENDER" value='<%=male%>'/>
<%		
	}if(female != null && !"".equals(female)){
		out.println("Scalar Gender :  "  + female + "<br/>");
 %>	
 		<vdm:setscalar attribute="SM_GENDER" value='<%=female%>'/>
 <%	} %> 		
 	<commercecontext:calculatesegments/> 
    <commercecontext:getrecommendations collectionid='<%=recommendationId %>' maxcount="4" listvarname="personalizedRecommendations"/>
 	<ics:if condition='<%=ics.GetList("personalizedRecommendations") != null && ics.GetList("personalizedRecommendations").hasData()%>'>
		 <ics:then>
		 	<ics:listloop listname="personalizedRecommendations">
		 		<ics:listget fieldname="assettype" listname="personalizedRecommendations" output="assetType"/>
		 		<ics:listget fieldname="assetid" listname="personalizedRecommendations" output="assetId"/>
		 		
		 		<asset:load name="basicAsset" type='<%=ics.GetVar("assetType") %>' objectid='<%=ics.GetVar("assetId") %>' flushonvoid="true"/>
		 		<asset:scatter name="basicAsset" prefix="asset"/>
		 		
		 		<assetset:setasset name="flexAsset" type='<%=ics.GetVar("assetType") %>' id='<%=ics.GetVar("assetId") %>' />
				<assetset:getmultiplevalues name="flexAsset" prefix="assetset">
					<assetset:sortlistentry attributetypename="Car_A" attributename="door"/>
					<assetset:sortlistentry attributetypename="Car_A" attributename="mirrior"/>
				</assetset:getmultiplevalues>
				<br/><br/>
				<h1><ics:getvar name="asset:name" /></h1>
				<ics:listloop listname="assetset:door">
					Door : <ics:listget fieldname="value" listname="assetset:door"/><br/>
				</ics:listloop>
				<ics:listloop listname="assetset:mirrior">
					Mirror : <ics:listget fieldname="value" listname="assetset:mirrior"/><br/>
				</ics:listloop>
				<br/><br/>
		 	</ics:listloop>
		 </ics:then>
		 <ics:else>
	 		<%out.println("<br/>personalizedRecommendations List Empty<br/>"); %>	
	 	</ics:else>
	 </ics:if>
 	Recommendation Error No: <ics:geterrno/><br/>
 	
 	<ics:clearerrno/>
 	<vdm:getscalar attribute="SM_AGE" varname="varAge"/>
 	<vdm:getscalar attribute="SM_GENDER" varname="varGender"/> 
 	Age 2 : <ics:getvar name="varAge"/><br/>
 	Gender 2 : <ics:getvar name="varGender"/><br/>
 	GetScalar Error No: <ics:geterrno/><br/>
 	 	  	
 	<a href="ContentServer?pagename=Snehal_Website/details"><button class="btn btn-primary">Back</button></a>

</cs:ftcs>
