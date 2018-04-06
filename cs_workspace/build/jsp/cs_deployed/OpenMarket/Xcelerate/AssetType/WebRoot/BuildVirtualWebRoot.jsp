<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/WebRoot/BuildWebRoot
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>

<!-- user code here -->

<tr>
<td  CLASS="form-label-text">
	<xlat:stream key='UI/Forms/VirtualRootURL'/>:
</td> 
<td><img height="1" width="5" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif" REPLACEALL="Variables.cs_imagedir"/></td>
<td>
	<table border="0">
	<tbody id="WebRootsTableBody">
	<tr>
		<th style="text-align:left"><span CLASS="form-label-text" style="padding-left:0"><xlat:stream key='UI/Forms/Environment'/></span></th>
		<th style="text-align:left"><span CLASS="form-label-text" style="padding-left:0"><xlat:stream key='UI/Forms/RootURL'/></span></th>
		<th><span CLASS="form-label-text"></span></th>
	</tr>
	<%
		String virtualWebRootsString = ics.GetVar("fieldvalue");		
		int total = 0,index =0; String inputEnvironmentName, inputWirutalWebRootName;
		if(StringUtils.isEmpty(virtualWebRootsString)) {
			virtualWebRootsString = " = ";
		}
		boolean editmode = "edit".equals(ics.GetVar("action"));
		if(StringUtils.isNotEmpty(virtualWebRootsString)) {
			String[] webroots = virtualWebRootsString.split(",");
			for(String virtualWebRootString: webroots)
				{
				String[] virutalroot = virtualWebRootString.split("=");				
				if(virutalroot.length == 2)
				{
					total ++;
					inputEnvironmentName = "WebRoot:environment:" + index;
					inputWirutalWebRootName = "WebRoot:virtualrooturl:" + index;
					%>
					<tr id="WebRootsTableRow_<%=index%>">
					<td>
					<%if(editmode) { %>
						<ics:callelement element="OpenMarket/Gator/AttributeTypes/TextBox">
								<ics:argument name="inputName" value="<%=inputEnvironmentName%>"/>
								<ics:argument name="inputValue" value='<%=virutalroot[0].trim()%>'/>								
								<ics:argument name="width" value='10em'/>
								<ics:argument name="inputMaxlength" value='128'/>				
						</ics:callelement>
						<% } else { %>
								<%=virutalroot[0].trim()%>
						<% } %>
					</td>
					<td>
						<%if(editmode) { %>
						<ics:callelement element="OpenMarket/Gator/AttributeTypes/TextBox">
								<ics:argument name="inputName" value="<%=inputWirutalWebRootName%>"/>
								<ics:argument name="inputValue" value='<%=virutalroot[1].trim()%>'/>								
								<ics:argument name="width" value='45em'/>
								<ics:argument name="inputMaxlength" value='128'/>				
						</ics:callelement>						
						<% } else { %>
							<%=virutalroot[1].trim()%>
						<% } %>
					</td>
					<td width="30">
						<%if(editmode) { %>
						<img src="js/fw/images/ui/ui/forms/cross.png" onClick="deleteWebroot(<%=index%>)">
						<% } %>
					</td>
					</tr>
					<%
					index ++;
					}									
				}
		}	
	%>			
		</tbody>
	</table>
	<input type="hidden" name='VirtualRootURLTotal' value='<%=total%>'>
	</td>
</tr>
	<%if(editmode) { %>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
	<tr>
		<td><img height="1" width="5" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif" REPLACEALL="Variables.cs_imagedir"/></td>
		<td><img height="1" width="5" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif" REPLACEALL="Variables.cs_imagedir"/></td>
		<td>
		<div class="AddNode" dojotype='fw.ui.dijit.Button' title="<xlat:stream key='UI/Forms/AddNew'/>" label="<xlat:stream key='UI/Forms/AddNew'/>" onClick="addNewWebRoot()"></div>	

		</td>
	</tr>
	<% } %>
</cs:ftcs>