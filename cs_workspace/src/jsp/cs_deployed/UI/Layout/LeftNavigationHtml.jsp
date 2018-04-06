<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="controller" uri="futuretense_cs/controller.tld" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ page import="java.util.*"%>
<cs:ftcs>
<%
   // Get the list of configured panes to render..
   List<Map<String,Object>> panes = (List<Map<String,Object>>)request.getAttribute("panes");
   int  pnt = 0 ; 
%>   
<div data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'top','class':'treeHeader'"></div>
	<div id="treeContentPane" data-dojo-type="dijit.layout.StackContainer" data-dojo-props="region:'center'" oncontextmenu="return false;">
		<c:forEach items="${panes}" var="pane" varStatus="status">
	    <%    
	      Map<String,Object> pane = (Map<String,Object>)panes.get(pnt++); // TODO check index variable
          Map<String,Object> content = (Map<String,Object>)pane.get("content");

	      // Set the current rendering pane handle 
          request.setAttribute( "pane", pane  );       
	      // Set the pane element rendering tag  OOBox is tree but now pure Custom Element
	      // that can Config--> Action ---> HTML or XML rendering 
	      // Here is the LeftNav Pane to do your Custom Rendering display or Form 
	      request.setAttribute( "content", content  );
        %> 
                  
		<div id="${pane.id}" data-dojo-type="dijit.layout.BorderContainer" data-dojo-props="title:'${pane.label}'">			
			<div data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'center'">
				<controller:callelement  elementname="${pane.content.source}"> </controller:callelement>
			</div>
		</div>		
				
	 </c:forEach>
</div>

<div id="treeTabPane" data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'bottom'">
	<div
		data-dojo-type="dijit.form.ToggleButton"
		data-dojo-props="
			iconClass: 'treeNavToggleIcon',
			checked: false,
			onChange: function(val) {
				if(val) {
					dojo.byId('treeNavButtons').style.display = 'none';
					dijit.byId('treeContainer').layout();
				} else {
					dojo.byId('treeNavButtons').style.display = 'block';
					dijit.byId('treeContainer').layout();
				}
			}
		">
	</div>
	<div class="inner" id="treeNavButtons">
		<c:forEach var="pane" items="${panes}" varStatus="status">
			<div
				id="${pane.id}Button"
				data-dojo-type="dijit.form.Button"
				data-dojo-props="
					iconClass: '${paner.iconClass}',
					onClick:function() {
						 fw.ui.app.showTree(${status.index}, '${pane.content.tree.id}');
					}
				">${pane.label}
			</div>
		</c:forEach>
	</div>
</div>
</cs:ftcs>