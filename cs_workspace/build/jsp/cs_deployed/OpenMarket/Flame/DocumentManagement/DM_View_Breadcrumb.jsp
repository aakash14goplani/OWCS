<%@ page import="com.fatwire.flame.dm.HierarchyNode,
                 com.fatwire.flame.portlets.DocumentManagement,
                 java.util.Map,
                 java.util.Iterator"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%//
// OpenMarket/Xcelerate/Flame/DocumentManagement/DM_View_Breadcrumb
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
	<%
	HierarchyNode[] breadCrumbs = (HierarchyNode[]) ics.GetObj(DocumentManagement.DM_VIEW_BREADCRUMB_PAGENAME);
	if (breadCrumbs != null && breadCrumbs.length > 1) {
		%>
			<tr>
				<td colspan="2" style="padding:3px" class="portlet-section-selected">
				<!-- Make the breadcrumb trail -->
				<%
				for (int i = breadCrumbs.length - 1; i > 0; i--)
				{
					HierarchyNode node = breadCrumbs[i];

					Map params = node.getParameters();
					%><nobr><%
					if (params != null) {
						%>
						<satellite:link assembler="query" outstring="url">
						<%
						for (Iterator it = params.entrySet().iterator(); it.hasNext();) {
							Map.Entry entry = (Map.Entry) it.next();
							%><satellite:argument name="<%=(String)entry.getKey()%>" value="<%=(String)entry.getValue()%>"/><%
						}
						%>
						</satellite:link>
						<%
						String url = ics.GetVar("url");
						ics.RemoveVar("url");
						%><a href="<%=url%>"><%=node.getName()%></a><%
					} else {
						%><%=node.getName()%><%
					}
					%></nobr> &gt; <%
				}
				%>&nbsp;
				</td>
			</tr>
		<%
	}
	%>
</cs:ftcs>