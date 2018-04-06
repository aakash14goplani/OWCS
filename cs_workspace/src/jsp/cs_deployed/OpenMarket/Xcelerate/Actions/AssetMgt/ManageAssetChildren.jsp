<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/AssetMgt/ManageAssetChildren
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
<%@ page import="java.util.*"%>
<cs:ftcs>
<%
	if("createDS".equals(ics.GetVar("action"))){
		Map<String,Map<String,List<String>>> assocDS = new LinkedHashMap<String,Map<String,List<String>>>();
		IList associations = ics.GetList("associations");
		if (associations != null) {
			int oldPos = associations.currentRow();
			int i = 0;
			while (associations.moveToRow(IList.gotorow, i + 1)) {
				String x = associations.getValue("name");
				assocDS.put(x, null);
				i++;
			}
			associations.moveToRow(IList.gotorow, oldPos);
		}
		ics.SetObj("assocDS",assocDS);
	} else if("updateDS".equals(ics.GetVar("action"))){
		String assocName = ics.GetVar("m:assocname");
		String assetName = ics.GetVar("m:assetname");
		String assetId = ics.GetVar("m:assetid");
		String assetType = ics.GetVar("m:assettype");
		Map<String,List<String>> assocDS = (Map<String,List<String>>)ics.GetObj("assocDS");
		if(assocDS.get(assocName) != null){
			List<String> assets = assocDS.get(assocName);
			assets.add(assetType + ":" + assetName + ":" + assetId);
		} else {
			List<String> assets = new ArrayList<String>();
			assets.add(assetType + ":" + assetName + ":" + assetId);
			assocDS.put(assocName,assets);
		}
	} else if("displayDS".equals(ics.GetVar("action"))){
		Map<String,List<String>> assocDS = (Map<String,List<String>>)ics.GetObj("assocDS");
		List<String> assocKeys = new ArrayList<String>(assocDS.keySet());
		IList associations = ics.GetList("associations");
		for(int i = 0 ; i < assocKeys.size() ; i++){
		String description=null;
		if (associations != null) {
			for (int a = 1; a <= associations.numRows(); a++) {
				associations.moveTo(a);
				description = associations.getValue("description");
				if (assocKeys.get(i).equals(associations.getValue("name"))) 
					break;
				else 
					description = null;
			}
		}
		%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer" />
			<tr>
			<td valign="top" class="form-label-text">
				<% if ("-".equals(assocKeys.get(i))) { %> <xlat:stream key='dvin/Common/AT/Contains'/>: <% } else if(description!=null) { %>
				<%=description%>:  <% } else { %> <%=assocKeys.get(i)%>: <%} %>
			</td>
			<td>
				<img height="1" width="5" src='<%=ics.GetVar("cs_imagedir") + "/graphics/common/screen/dotclear.gif"%>'/>
			</td>
			<td class="form-inset">
				<%
					List<String> assets = assocDS.get(assocKeys.get(i));
					if(null != assets && assets.size() > 0){
					%>
					<table border="0" cellpadding="0" cellspacing="0">
					<%
							for(int j = 0 ; j < assets.size() ; j++){
							String[] asset = assets.get(j).split(":");
							%>
								<tr>
								<td>
									 <xlat:lookup key="dvin/Common/InspectThisItem" varname="_XLAT_"/>
									 <xlat:lookup key="dvin/Common/InspectThisItem" varname="mouseover" escape="true"/>
									<ics:callelement element="OpenMarket/Xcelerate/Util/GenerateLink">
										<ics:argument name="assettype" value='<%=asset[0]%>'/>
										<ics:argument name="assetid" value='<%=asset[2]%>'/>
										<ics:argument name="varname" value='urlInspectItem'/>
										<ics:argument name="function" value='inspect'/>
									</ics:callelement>
									<A HREF="<%=ics.GetVar("urlInspectItem")%>" OnMouseOver="window.status='<%=ics.GetVar("mouseover")%>'; return true" OnMouseOut="return window.status='';" title='<%=ics.GetVar("_XLAT_")%>'>
										<%=asset[1]%>
									</A> (<%=asset[0]%>)
								</td>
								</tr>
							<%
							}
					%>		
					</table>
				<%} else{ %>
					<span class="disabledText"><xlat:stream key='UI/Forms/NotAvailable' encode="false" escape="true"/></span>
				<%}%>
			</td>
			</tr>
		<%
		}
	}
%>
<!-- user code here -->

</cs:ftcs>