<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="ccuser" uri="futuretense_cs/ccuser.tld"%>
<%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld"%>
<%@ page import="COM.FutureTense.Interfaces.*"%>
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
	ics.ClearErrno();
	if(Utilities.goodString(assetId) && Utilities.goodString(assetType)){
%>
 		<ics:callelement element="Risk_Engineering/Logic/LoadAssetInfoEJ"> 
			<ics:argument name="assetId" value='<%=assetId %>'/>
			<ics:argument name="assetType" value='<%=assetType %>'/>
			<ics:argument name="assetPrefix" value='<%=assetId %>'/>
		</ics:callelement>
<%
		if(Utilities.goodString(ics.GetVar(assetId + ":body_text"))){
			out.println("From LoadAsset : " + ics.GetVar(assetId + ":body_text") + "<br/><br/>");
			out.println("Tags From AssetAPI : " + ics.GetVar(assetId + ":fwtags") + "<br/><br/>");
		}
		else{
			out.println("Body Text Not Found ! <br/><br/>");
		}
		int errorNo = ics.GetErrno();
		out.println("Error : "+errorNo);
	}
%>
 	Body Text : <render:stream variable='<%=assetId + ":body_text"%>' />
 	
 	<asset:load name="userDetails" type='<%=assetType %>' objectid='<%=assetId %>'/>
 	<asset:scatter name="userDetails" prefix="user"/>
 	
 	Created By : <ics:getvar name="user:createdby"/><br/>
 	Created Date : <ics:getvar name="user:createddate"/><br/>
 	Updated By : <ics:getvar name="user:updatedby"/><br/>
 	Updated Date : <ics:getvar name="user:updateddate"/><br/>
 	<ics:clearerrno/>	
 	Tags : <ics:getvar name="user:fwtags"/><br/>
 	
 	Tags Error : <ics:geterrno/><br/>
 	Tag : <ics:getvar name="tag"/>, <ics:getvar name="user:tag"/><br>
 	
 	<assetset:setasset name="renderTag" type='<%=assetType %>' id='<%=assetId %>'/>
 	<assetset:getattributevalues name="renderTag" listvarname="tagList" attribute="fwtags" typename="HIG_ComponentWidget_A"/>
 	<ics:if condition='<%=null!=ics.GetList("tagList") && ics.GetList("tagList").hasData() %>'>
 		<ics:then>
 			<ics:listloop listname="tagList">
 				<ics:listget fieldname="value" listname="tagList"/>
 			</ics:listloop>
 		</ics:then>
 		<ics:else>
 			<% out.println("tagList is empty!!!"); %>
 		</ics:else>
 	</ics:if>
</cs:ftcs>