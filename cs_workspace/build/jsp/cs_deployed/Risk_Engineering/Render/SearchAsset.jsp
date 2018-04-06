<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><% 
/******************************************************************************************************************************
   *    Element Name        :  SearchAsset 
   *    Author              :  Aakash Goplani 
   *    Creation Date       :  (26/05/2017) 
   *    Description         :  Element to search asset.
   *    Input Parameters    :  Variables required by this Element 
   *                            NONE
   *    Output              :  searched asset
 *****************************************************************************************************************************/
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
	<%--create searchstate object --%>
	<searchstate:create name="flexSearch"/>
	
	<%--Simple Like Constraint to fetch all assets containing Aakash in insert_title --%>
	<searchstate:addsimplelikeconstraint name="flexSearch" attribute="insert_title" value="%Aakash%" typename="HIG_ComponentWidget_A" />
	<assetset:setsearchedassets name="simpleLikeSearch" constraint="flexSearch" assettypes="HIG_ComponentWidget_C" />
	<assetset:getassetlist name="simpleLikeSearch" listvarname="simpleLikeSearchList" />
	<%-- <ics:callelement element="Risk_Engineering/Render/List">
		<ics:argument name="list" value="simpleLikeSearchList" />
		<ics:argument name="output_as_variable" value="false" />
	</ics:callelement> --%>
	<ics:if condition='<%=ics.GetList("simpleLikeSearchList")!=null && ics.GetList("simpleLikeSearchList").hasData() %>'>
		<ics:then>
			<% out.println("----------Simple Like Search----------<br/><br/>"); %>
			<ics:listloop listname="simpleLikeSearchList">
				<ics:listget fieldname="assettype" listname="simpleLikeSearchList" output="simpleLikeSearchAssetType"/>
				<ics:listget fieldname="assetid" listname="simpleLikeSearchList" output="simpleLikeSearchAssetId"/>
				<asset:load name="fetchSimpleLikeAssetName" type='<%=ics.GetVar("simpleLikeSearchAssetType")%>' objectid='<%=ics.GetVar("simpleLikeSearchAssetId")%>'/>
				<asset:get name="fetchSimpleLikeAssetName" field="name" output="simpleLikeAssetName"/>
				<ics:getvar name="simpleLikeAssetName"/> => <ics:getvar name="simpleLikeSearchAssetType"/> : <ics:getvar name="simpleLikeSearchAssetId"/> <br/>
			</ics:listloop>
		</ics:then>
		<ics:else>
			<% out.println("<br/><br/>----------simpleLikeSearchList empty!----------<br/><br/>"); %>
		</ics:else>
	</ics:if>
	
	<%--Like Constraint to fetch all assets containing insert_title attribute--%>
	<searchstate:addlikeconstraint name="flexSearch" attribute="insert_title" typename="HIG_ComponentWidget_A"/>
	<assetset:setsearchedassets name="likeSearch" constraint="flexSearch" assettypes="HIG_ComponentWidget_C"/>	
	<assetset:getassetlist name="likeSearch" listvarname="likeSearchList" />
	<ics:if condition='<%=ics.GetList("likeSearchList")!=null && ics.GetList("likeSearchList").hasData() %>'>
		<ics:then>
			<% out.println("<br/><br/>----------Like Search----------<br/><br/>"); %>
			<ics:listloop listname="likeSearchList">
				<ics:listget fieldname="assettype" listname="likeSearchList" output="likeSearchAssetType"/>
				<ics:listget fieldname="assetid" listname="likeSearchList" output="likeSearchAssetId"/>
				<asset:load name="fetchLikeAssetName" type='<%=ics.GetVar("likeSearchAssetType")%>' objectid='<%=ics.GetVar("likeSearchAssetId")%>'/>
				<asset:get name="fetchLikeAssetName" field="name" output="likeAssetName"/>
				<ics:getvar name="likeAssetName"/> => <ics:getvar name="likeSearchAssetType"/> : <ics:getvar name="likeSearchAssetId"/> <br/>
			</ics:listloop>
		</ics:then>
		<ics:else>
			<% out.println("<br/><br/>----------likeSearchList empty!----------<br/><br/>"); %>
		</ics:else>
	</ics:if>
	
	<%--NOT WORKING : Has Ancestor Constraint to fetch all assets to find assets that have a particular asset of type assettype and id assetid as its ancestor --%>
	<asset:load name="hasConstraint" type="HIG_MultiMedia_P" field="name" value="MultiMedia_Parent"/>
	<asset:get name="hasConstraint" field="id" output="assetid"/>
	<ics:getvar name="assetid"/>
	<searchstate:addhasancestorconstraint name="flexSearch" assettype="HIG_MultiMedia_P" assetid='<%=ics.GetVar("assetid") %>' bucket="bucketValue" />
	<assetset:setsearchedassets name="hasConstraintSearch" constraint="flexSearch" assettypes="HIG_MultiMedia_C" />
	<%--<assetset:getattributevalues name="hasConstraintSearch" attribute="body_assets" listvarname="hasConstraintSearchList" typename="HIG_MultiMedia_A"/>--%>
	<assetset:getassetlist name="hasConstraintSearch" listvarname="hasConstraintSearchList" />
	<ics:if condition='<%=ics.GetList("hasConstraintSearchList")!=null && ics.GetList("hasConstraintSearchList").hasData() %>'>
		<ics:then>
			<% out.println("<br/><br/>----------Has Constraint Search----------<br/><br/>"); %>
			<ics:listloop listname="hasConstraintSearchList">
				<ics:listget fieldname="assettype" listname="hasConstraintSearchList" output="asancestorAssetType"/>
				<ics:listget fieldname="assetid" listname="hasConstraintSearchList" output="asancestorAssetId"/>
				<asset:load name="fetchAsancestorAssetName" type='<%=ics.GetVar("likeSearchAssetType")%>' objectid='<%=ics.GetVar("asancestorAssetId")%>'/>
				<asset:get name="fetchAsancestorAssetName" field="name" output="asancestorAssetName"/>
				<ics:getvar name="asancestorAssetName"/> => <ics:getvar name="likeSearchAssetType"/> : <ics:getvar name="asancestorAssetId"/> <br/>
			</ics:listloop>
		</ics:then>
		<ics:else>
			<% out.println("<br/><br/>----------hasConstraintSearchList empty!----------<br/><br/>"); %>
		</ics:else>
	</ics:if>
	
	<%--Simple Like Constraint to fetch all assets containing Aakash OR aakash in insert_title --%>
	<searchstate:create name="parentState" op="or"/>
	<searchstate:addsimplelikeconstraint name="parentState" attribute="insert_title" value="%Aakash%" typename="HIG_ComponentWidget_A" bucket="b1" />
	<searchstate:create name="childState" op="or"/>
	<searchstate:addsimplelikeconstraint name="childState" attribute="insert_title" value="%aakash%" typename="HIG_ComponentWidget_A" bucket="b2" />
	<searchstate:addnestedconstraint searchstate="parentState" name="childState" bucket="b3"/>
	<assetset:setsearchedassets name="nestedSearch" constraint="childState" assettypes="HIG_ComponentWidget_C" />
	<assetset:getassetlist name="nestedSearch" listvarname="nestedSearchList" />
	<ics:if condition='<%=ics.GetList("nestedSearchList")!=null && ics.GetList("nestedSearchList").hasData() %>'>
		<ics:then>
			<% out.println("<br/><br/>----------Nested Search----------<br/><br/>"); %>
			<ics:listloop listname="nestedSearchList">
				<ics:listget fieldname="assettype" listname="nestedSearchList" output="nestedSearchAssetType"/>
				<ics:listget fieldname="assetid" listname="nestedSearchList" output="nestedSearchAssetId"/>
				<asset:load name="fetchNestedAssetName" type='<%=ics.GetVar("nestedSearchAssetType")%>' objectid='<%=ics.GetVar("nestedSearchAssetId")%>'/>
				<asset:get name="fetchNestedAssetName" field="name" output="nestedAssetName"/>
				<ics:getvar name="nestedAssetName"/> => <ics:getvar name="nestedSearchAssetType"/> : <ics:getvar name="nestedSearchAssetId"/> <br/>
			</ics:listloop>
		</ics:then>
		<ics:else>
			<% out.println("<br/><br/>----------nestedSearchList empty!----------<br/><br/>"); %>
		</ics:else>
	</ics:if>
	
	<%--Range Constraint to fetch all assets having customer id greater than 1000 and less than or equal to 2002--%>
	<searchstate:create name="range"/>
	<searchstate:addrangeconstraint name="range" attribute="custom_id" typename="HIG_ComponentWidget_A" lower="1000" upperequal="2002" />
	<assetset:setsearchedassets name="rangeSearch" constraint="range" assettypes="HIG_ComponentWidget_C" />
	<assetset:getassetlist name="rangeSearch" listvarname="rangeSearchList"/>
	<ics:if condition='<%=ics.GetList("rangeSearchList")!=null && ics.GetList("rangeSearchList").hasData() %>'>
		<ics:then>
			<% out.println("<br/><br/>----------Range Search----------<br/><br/>"); %>
			<ics:listloop listname="rangeSearchList">
				<ics:listget fieldname="assettype" listname="rangeSearchList" output="rangeSearchAssetType"/>
				<ics:listget fieldname="assetid" listname="rangeSearchList" output="rangeSearchAssetId"/>
				<asset:load name="fetchRangeAssetName" type='<%=ics.GetVar("rangeSearchAssetType")%>' objectid='<%=ics.GetVar("rangeSearchAssetId")%>'/>
				<asset:get name="fetchRangeAssetName" field="name" output="rangeAssetName"/>
				<ics:getvar name="rangeAssetName"/> => <ics:getvar name="rangeSearchAssetType"/> : <ics:getvar name="rangeSearchAssetId"/> <br/>
			</ics:listloop>
		</ics:then>
		<ics:else>
			<% out.println("<br/><br/>----------rangeSearchList empty!----------<br/><br/>"); %>
		</ics:else>
	</ics:if>
	
	<%--Simple Standard Constraint to fetch all the assets that have title EXACTLY as aakash --%>
	<searchstate:create name="simpleStandard"/>
	<searchstate:addsimplestandardconstraint name="simpleStandard" attribute="insert_title" value="aakash" typename="HIG_ComponentWidget_A"/>
	<assetset:setsearchedassets name="simpleStandardSearch" constraint="simpleStandard" assettypes="HIG_ComponentWidget_C"/>
	<assetset:getassetlist name="simpleStandardSearch" listvarname="simpleStandardSearchList"/>
	<ics:if condition='<%=ics.GetList("simpleStandardSearchList")!=null && ics.GetList("simpleStandardSearchList").hasData() %>'>
		<ics:then>
			<% out.println("<br/><br/>----------Simple Standard Search Search----------<br/><br/>"); %>
			<ics:listloop listname="simpleStandardSearchList">
				<ics:listget fieldname="assettype" listname="simpleStandardSearchList" output="simpleStandardAssetType"/>
				<ics:listget fieldname="assetid" listname="simpleStandardSearchList" output="simpleStandardAssetId"/>
				<asset:load name="fetchsimpleStandardAssetName" type='<%=ics.GetVar("simpleStandardAssetType")%>' objectid='<%=ics.GetVar("simpleStandardAssetId")%>'/>
				<asset:get name="fetchsimpleStandardAssetName" field="name" output="simpleStandardAssetName"/>
				<ics:getvar name="simpleStandardAssetName"/> => <ics:getvar name="simpleStandardAssetType"/> : <ics:getvar name="simpleStandardAssetId"/> <br/>
			</ics:listloop>
		</ics:then>
		<ics:else>
			<% out.println("<br/><br/>----------simpleStandardSearchList empty!----------<br/><br/>"); %>
		</ics:else>
	</ics:if>
	
	<%--Standard Constraint to fetch all assets containing sic_code attribute--%>
	<searchstate:create name="standard"/>
	<searchstate:addlikeconstraint name="standard" attribute="abstract" typename="HIG_MultiMedia_A"/>
	<assetset:setsearchedassets name="standardSearch" constraint="standard" assettypes="HIG_MultiMedia_C"/>	
	<assetset:getassetlist name="standardSearch" listvarname="standardSearchList" />
	<ics:if condition='<%=ics.GetList("standardSearchList")!=null && ics.GetList("standardSearchList").hasData() %>'>
		<ics:then>
			<% out.println("<br/><br/>----------Standard Search----------<br/><br/>"); %>
			<ics:listloop listname="standardSearchList">
				<ics:listget fieldname="assettype" listname="standardSearchList" output="standardSearchAssetType"/>
				<ics:listget fieldname="assetid" listname="standardSearchList" output="standardSearchAssetId"/>
				<asset:load name="fetchStandardAssetName" type='<%=ics.GetVar("standardSearchAssetType")%>' objectid='<%=ics.GetVar("standardSearchAssetId")%>'/>
				<asset:get name="fetchStandardAssetName" field="name" output="standardAssetName"/>
				<ics:getvar name="standardAssetName"/> => <ics:getvar name="standardSearchAssetType"/> : <ics:getvar name="standardSearchAssetId"/> <br/>
			</ics:listloop>
		</ics:then>
		<ics:else>
			<% out.println("<br/><br/>----------standardSearchList empty!----------<br/><br/>"); %>
		</ics:else>
	</ics:if>
	
	<%--Basic Asset Search : Search all the assets with taxo_type=Language --%>
	<ics:setvar name="prefix:status_op" value="!="/>
	<ics:setvar name="prefix:status" value="VO"/>
	<ics:setvar name="prefix:taxo_type_op" value="="/>
	<ics:setvar name="prefix:taxo_type" value="Language"/>
	<asset:search type="HIG_Taxonomy" prefix="prefix" list="taxonomyList"/>
	<ics:if condition='<%=ics.GetList("taxonomyList")!=null && ics.GetList("taxonomyList").hasData() %>'>
		<ics:then>
			<% out.println("<br/><br/>----------Basic Asset Search----------<br/><br/>"); %>
			<ics:listloop listname="taxonomyList">
				Name : <ics:listget fieldname="taxo_name" listname="taxonomyList"/><br/> 
				Value : <ics:listget fieldname="taxo_value" listname="taxonomyList"/><br/>
				Type : <ics:listget fieldname="taxo_type" listname="taxonomyList"/><br/>
				SIC Code : <ics:listget fieldname="sic_code" listname="taxonomyList"/><br/><br/> 
			</ics:listloop>
		</ics:then>
		<ics:else>
			<% out.println("<br/><br/>----------taxonomyList empty!----------<br/><br/>"); %>
		</ics:else>
	</ics:if>
</cs:ftcs>