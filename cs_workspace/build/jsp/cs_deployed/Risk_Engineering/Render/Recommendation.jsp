<%@page import="com.fatwire.system.SessionFactory"%>
<%@page import="com.fatwire.system.Session"%>
<%@page import="com.openmarket.gator.jsp.vdm.Setscalar"%>
<%@page import="java.util.Map"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"%>
<%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"%>
<%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"%>
<%@ taglib prefix="vdm" uri="futuretense_cs/vdm.tld"%>
<%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"%>
<%@ page import="COM.FutureTense.Interfaces.*,
                 COM.FutureTense.Util.ftMessage,
                 com.fatwire.assetapi.data.*,
                 com.fatwire.assetapi.*,
                 COM.FutureTense.Util.ftErrors"
%>
<cs:ftcs>
	<%-- Record dependencies for the Template --%>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if>

<%
	String assetId = ics.GetVar("cid");
	String assetType = ics.GetVar("c");
	String age = ics.GetVar("age1");
	String male = ics.GetVar("male1");
	String female = ics.GetVar("female1");
	String others = ics.GetVar("others1");
	String recommendation = "" , recommendationType = "" , recommendationId = "" ; 
	out.println(age + " " + male + " " + female + " " + others);
	
	ics.ClearErrno();
	if(assetId != null && assetType != null){
		int errorNo = ics.GetErrno();
		out.println("Error : "+ errorNo + "<br/>");
		FTValList inList = new FTValList();
		inList.put("cid",assetId);
		inList.put("c",assetType);
		if(assetId != null && assetType != null)
			ics.CallElement("Risk_Engineering/Logic/LoadAssetInfoEJ", inList);	
		else
			ics.LogMsg("Null Asset Id / Type passed in Load Asset to Call Get Asset from HomePage");	
		
		 recommendation = ics.GetVar("asset:feature_recommendation");
		 recommendationType = recommendation.substring(0,recommendation.indexOf(':'));
		 recommendationId = recommendation.substring(recommendation.indexOf(':')+1);
		 out.println("Reco : " + recommendation + " == " + recommendationType + " == " + recommendationId);
	}
	else
		ics.LogMsg("Null Asset Id / Type passed in HomePage from LoginPage");
		
	if(age != null && !"".equals(age)){
		out.println("In age "  + age);
%>
		<vdm:setscalar attribute="user_age" value='<%=age%>'/>
<%
	}if(male != null && !"".equals(male)){
		out.println("In male "  + male);
%>
		<vdm:setscalar attribute="user_gender" value='<%=male%>'/>
<%		
	}if(female != null && !"".equals(female)){
		out.println("In female "  + female);
 %>	
 		<vdm:setscalar attribute="user_gender" value='<%=female%>'/>
 <%	} %>
 		
 	<commercecontext:calculatesegments/> 
 	 
    <commercecontext:getrecommendations collectionid='<%=recommendationId %>' maxcount="4" listvarname="personalizedRecommendations"/>
 	<ics:if condition='<%=ics.GetList("personalizedRecommendations") != null && ics.GetList("personalizedRecommendations").hasData()%>'>
		 <ics:then>
		 	<ics:listloop listname="personalizedRecommendations">
		 		<ics:listget fieldname="assettype" listname="personalizedRecommendations" output="assetType"/>
		 		<ics:listget fieldname="assetid" listname="personalizedRecommendations" output="assetId"/>
		 		<ics:callelement element="Risk_Engineering/Logic/LoadAssetInfoEJ">
		 			<ics:argument name="c" value='<%=ics.GetVar("assetType") %>'/>
		 			<ics:argument name="cid" value='<%=ics.GetVar("assetId") %>'/>
		 		</ics:callelement>
		 		Body Text : <%=ics.GetVar("asset:body_text") %><br/>
		 	</ics:listloop>
		 </ics:then>
		 <ics:else>
	 		<%out.println("<br/>personalizedRecommendations List Empty<br/>"); %>	
	 	</ics:else>
	 </ics:if>
 	Recommendation Error No: <ics:geterrno/><br/>
 	
 	<ics:clearerrno/>
 	<vdm:getscalar attribute="user_age" varname="varAge"/>
 	<vdm:getscalar attribute="user_gender" varname="varGender"/> 
 	Age 2 : <ics:getvar name="varAge"/><br/>
 	Gender 2 : <ics:getvar name="varGender"/><br/>
 	GetScalar Error No: <ics:geterrno/><br/>
 	 	  	
 	<a href="ContentServer?pagename=Risk_Engineering/form"><button class="btn btn-primary">Back</button></a>
</cs:ftcs>