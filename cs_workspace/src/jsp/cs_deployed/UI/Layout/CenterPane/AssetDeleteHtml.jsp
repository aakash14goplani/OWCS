<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// UI/Layout/CenterPane/Search/View/DeleteAssetsHtml
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@ page import="org.codehaus.jackson.type.TypeReference"%>
<%@ page import="java.util.*"%>

<cs:ftcs>
<%	
	int deletedCount =  request.getParameter("deletedCount") != null ? Integer.parseInt(request.getParameter("deletedCount")) : 0;	
	String success = deletedCount > 0 ? deletedCount+" Assets  were deleted" : "";	
	
	int failedCount =  request.getParameter("failedCount") != null ? Integer.parseInt(request.getParameter("failedCount")) : 0;	

	int referncedCount =  request.getParameter("referncedCount") != null ? Integer.parseInt(request.getParameter("referncedCount")) : 0;	

%>	

<div  dojoType="dijit.layout.BorderContainer">

		<div dojoType="dijit.layout.ContentPane" region="top" height="100px">
				
		<%if(failedCount > 0){ %>			
			<table 
				id="failedDeleteGrid"
				dojoType="dojox.grid.EnhancedGrid"
				store="failedStore"	
				border="5px"
				columnReordering="true"
				>
				<thead>
					<tr>
						<th field="name" width="400px" formatter="fw.ui.SearchFormatter.nameFormatter"><xlat:stream key="dvin/Common/Name"/></th>
						<th field="type" width="500px"><xlat:stream key="dvin/Common/Type"/></th> 
						<th field="message" width="auto"><xlat:stream key="fatwire/Alloy/UI/ReasonInfo"/></th>
					</tr>
				</thead>
			</table>						
					
		<%} %>
					
		</div>
		
		<%if(referncedCount > 0){ %>
		
			<div dojoType="dijit.layout.ContentPane" region="center" height="100px">
		     		       
		     	<div dojoType="dojox.grid.LazyTreeGridStoreModel" jsId="model"
		        	store="deleteStore" query="{id:'*'}" childrenAttrs="children">
		        </div>
		     				
		        <table id="deleteGrid" dojoType="fw.ui.dojox.grid.LazyTreeGrid" class="grid" defaultOpen=true rowsPerPage=5
					   store="deleteStore"  treeModel="model" columnReordering=true  height='100px'>
		            <thead>
		                <tr>
		                    <th field="name" width="400px" formatter="fw.ui.SearchFormatter.nameFormatter"><xlat:stream key="dvin/Common/Name"/></th>
		                    <th field="type" width="auto"><xlat:stream key="dvin/Common/Type"/></th> 					
		                </tr>
		            </thead>
		        </table>  
	   		</div>  		
	   		 		
   	   <%} %>
</div>

</cs:ftcs>