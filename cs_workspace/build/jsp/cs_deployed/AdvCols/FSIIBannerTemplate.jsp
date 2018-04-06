<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="property" uri="futuretense_cs/property.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ page import="java.util.*, java.text.*, java.io.*"
%>
<cs:ftcs>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>

	<%-- Load the recommendation, display the title and return "max" entries. --%>
	<asset:load name='currentAsset' type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>' deptype='exists'/>
	<asset:get name='currentAsset' field='description' output='description'/>
	<asset:get name='currentAsset' field='name' output='reconame'/>
	<commercecontext:getrecommendations collection='<%=ics.GetVar("reconame")%>' maxcount='<%=ics.GetVar("max")%>' listvarname="assetlist"/>
	<ics:if condition='<%=ics.GetList("assetlist",false)!=null && ics.GetList("assetlist",false).hasData()%>'>
	<ics:then>
		<div id="BannerImagesContainer">	 
		<ics:if condition='<%="1".equals(ics.GetVar("max")) || ics.GetList("assetlist").numRows() == 1%>'>
		<ics:then> 
				<ics:listget listname="assetlist" fieldname="assetid" output="assetid"/>
				<ics:listget listname="assetlist" fieldname="assettype" output="assettype"/>

				<listobject:create name="inputListName" columns="assetid,assettype" />
					<listobject:addrow name="inputListName">
					<listobject:argument name="assetid" value='<%=ics.GetVar("assetid")%>' />
					<listobject:argument name="assettype" value='<%=ics.GetVar("assettype")%>' />
				</listobject:addrow>
				<listobject:tolist name="inputListName" listvarname="assetInputList" />
				<asset:filterassetsbydate inputList="assetInputList" outputList="assetOutputList" date='<%=ics.GetSSVar("__insiteDate")%>' />
		
				<ics:if condition='<%=ics.GetList("assetOutputList")!=null && ics.GetList("assetOutputList").hasData()%>' >
				<ics:then>
					<ics:listget listname="assetOutputList" fieldname="assetid" output="assetid" />
					<ics:listget listname="assetOutputList" fieldname="assettype" output="assettype" />
					
					<render:lookup varname="ImageDisplayTemplate" key="ImageDisplayTemplate" />
					<render:calltemplate tname='<%=ics.GetVar("ImageDisplayTemplate")%>' c='<%=ics.GetVar("assettype")%>' cid='<%=ics.GetVar("assetid")%>' 
										 context="" args="p,locale" />
				</ics:then>
				</ics:if>
		</ics:then>
		<ics:else>
			<insite:slotlist slotname="RecommendationLink" parentid='<%=ics.GetVar("cid")%>' parenttype="AdvCols" parentfield="Manualrecs" 
								 tname='<%=ics.GetVar("ImageDisplayTemplate")%>'>
				<ics:listloop listname="assetlist" maxrows='<%=ics.GetVar("max")%>'>
					<ics:listget listname="assetlist" fieldname="assetid" output="assetid"/>
					<ics:listget listname="assetlist" fieldname="assettype" output="assettype"/>					
					<listobject:create name="inputListName" columns="assetid,assettype" />
					<listobject:addrow name="inputListName">
						<listobject:argument name="assetid" value='<%=ics.GetVar("assetid")%>' />
						<listobject:argument name="assettype" value='<%=ics.GetVar("assettype")%>' />
					</listobject:addrow>
					<listobject:tolist name="inputListName" listvarname="assetInputList" />
					<asset:filterassetsbydate inputList="assetInputList" outputList="assetOutputList" date='<%=ics.GetSSVar("__insiteDate")%>' />
		
					<ics:if condition='<%=ics.GetList("assetOutputList")!=null && ics.GetList("assetOutputList").hasData()%>' >
					<ics:then>
						<ics:listget listname="assetOutputList" fieldname="assetid" output="assetid" />
						<ics:listget listname="assetOutputList" fieldname="assettype" output="assettype" />
						<render:lookup varname="ImageDisplayTemplate" key="ImageDisplayTemplate" />
						<insite:calltemplate tname='<%=ics.GetVar("ImageDisplayTemplate")%>' c='<%=ics.GetVar("assettype")%>' cid='<%=ics.GetVar("assetid")%>' args="p,locale" />
					</ics:then>
					</ics:if>
				</ics:listloop>
			</insite:slotlist>
		</ics:else>
		</ics:if>
		</div>
	</ics:then>
	</ics:if>
</cs:ftcs>
