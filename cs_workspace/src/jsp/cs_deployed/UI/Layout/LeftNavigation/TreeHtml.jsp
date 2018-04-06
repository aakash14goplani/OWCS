<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.*"%>

<cs:ftcs>

<ics:callelement element="UI/Utils/encodeParameters"></ics:callelement>  

<%
// Get the rendereing element's tree map data of properties 
// And Determine if user has access to the tree tabs / roots etc 
Map<String,Object> tree = (Map<String,Object>)request.getAttribute("tree");
Boolean  canAccess = (Boolean)tree.get("canAccess") ; 
%>

<!--   Does this user have access to this tree 
       Check The Tree canAccess property or Flag  
-->
<%
if ( canAccess ) { 	   
%>
        <!-- user has access query and load the datastore  -->
		<div dojoType="dojox.data.QueryReadStore"
			 jsId="${tree.id}Store" url="${tree.datastoreUrl}" requestMethod="post">
        </div>

		<!-- fetch all immediate children  -->
		<div dojoType="fw.ui.data.stores.CSForestStoreModel" 
	 		jsId="${tree.id}Model" store="${tree.id}Store" rootId="paneRoot"  rootLabel="${tree.label}"
	 			query="{ tabs:	 '${tree.tabs}', 
	 		  			 exclude:'${tree.excludetabs}', 
	 		  			 roots:	 '${tree.roots}', 	 		  			
	 		 			 filter: '${tree.filter}', 
	 		  			 showParentsOnly: ${tree.showParentsOnly != false}}" 
	            childrenAttrs="children">
		</div>

		<div dojoType="fw.dijit.UITree" 
	 		 id="${tree.id}"
	 		 model="${tree.id}Model"	 		
			 <c:forEach items="${tree.arguments}" var="arg">
				${arg.key}="${arg.value}"
			</c:forEach>>
		</div>
 <% 
 }
 else {
	  // Render a ERROR message 
      %>
   		 <div data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'center'">
				<div class="treeMessage"> <xlat:stream key="UI/UC1/Layout/YouDoNotHaveTreePanePermission"/> </div>
		 </div>
      <% 
 }
%>
</cs:ftcs>