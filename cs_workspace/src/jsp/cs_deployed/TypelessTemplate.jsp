<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
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
		out.println("ID : " + ics.GetVar("cid") + ", Type : " + ics.GetVar("c")  + ", Site : " + ics.GetVar("site"));
	 %>
	<br/><br/>
	<ics:clearerrno />
	<asset:load name="pageAsset" type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>' flushonvoid="true"/>
	<asset:get name="pageAsset" field="name"/>
	Name : <ics:getvar name="name"/> <br/>
	<asset:get name="pageAsset" field="id"/>
	id : <ics:getvar name="id"/> <br/>
	<asset:get name="pageAsset" field="title"/>
	Title : <ics:getvar name="title"/> <br/>
	<ics:geterrno />
	<asset:scatter name="pageAsset"/>
	t : <ics:getvar name="Attribute_title"/><br/>
	T : <ics:getvar name="Attribute_Title"/><br/>
	
	<ics:clearerrno />
	<assetset:setasset name="abc" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>'/>
	<assetset:getattributevalues name="abc" listvarname="titleList" attribute="body_text" typename="PageAttribute"/>
	<assetset:getattributevalues name="abc" listvarname="titleList2" attribute="body_components" typename="PageAttribute"/>
	<assetset:getattributevalues name="abc" listvarname="titleList3" attribute="right_rail_components" typename="PageAttribute"/>
	<assetset:getattributevalues name="abc" listvarname="titleList4" attribute="title" typename="PageAttribute"/>
	<ics:listloop listname="titleList">
		body text : <ics:listget fieldname="value" listname="titleList"/><br/>
	</ics:listloop>
	<ics:listloop listname="titleList2">
		body_components : <ics:listget fieldname="value" listname="titleList2"/><br/>
	</ics:listloop>
	<ics:listloop listname="titleList3">
		right_rail_components : <ics:listget fieldname="value" listname="titleList3"/><br/>
	</ics:listloop>
	<ics:listloop listname="titleList4">
		title : <ics:listget fieldname="value" listname="titleList4"/><br/>
	</ics:listloop>
	<ics:geterrno />
	
	
	<asset:load name="loadAssociations" type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>'/>
	<asset:children name="loadAssociations" list="association_list" objecttype="HIG_ComponentWidget_C" order="nrank" code="asset_link"/>
<%
       IList list = ics.GetList("association_list");
       int rows = list.numRows();
       int cols = list.numColumns();
       String columnName = "", columnValue = "";
       for(int i=0; i<rows; i++){
%>
		<table border="1">
<%
           for(int j=0; j<cols; j++){
               columnName = list.getColumnName(j);
               columnValue = list.getValue(columnName);
               list.moveTo(i+1);
%>
				<tr>
					<th><%=columnName %></th>
					<td><%=columnValue %></td>
				</tr>
<%  
           }
 %>
 		</table><br/>
 <%
       }
 %>

 	<asset:getsitenode output="siteNodeId" name="loadAssociations"/>
 	<siteplan:load name="parentNode" nodeid='<%=ics.GetVar("siteNodeId") %>'/>
 	<siteplan:children name="parentNode" list="navigationList" objecttype="Page" order="nrank" code="Placed"/>
 	<ics:if condition='<%=null != ics.GetList("navigationList") && ics.GetList("navigationList").hasData()%>'>
 		<ics:then>
 			<ics:listloop listname="navigationList">
 				<ics:listget fieldname="id" listname="navigationList" output="pageId"/>
 				<asset:load name="parentPage" type="Page" objectid='<%=ics.GetVar("pageId") %>'/>
 				<asset:siteparent name="parentPage" outname="parentPageAsset"/>
 				<asset:get name="parentPageAsset" field="id" output="parentId"/>
 				Parent Page : <ics:getvar name="parentId"/>
 			</ics:listloop>
 		</ics:then>
 	</ics:if>
	
</cs:ftcs>