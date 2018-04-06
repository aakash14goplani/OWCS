<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" %>
<%//
// OpenMarket/Gator/FlexibleAssets/Common/ParentSelectQueryResults
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
<%@ page import="com.openmarket.assetframework.interfaces.IAssetTypeManager"%>
<%@ page import="com.openmarket.assetframework.interfaces.AssetTypeManagerFactory"%>
<%@ page import="com.openmarket.gator.interfaces.ITemplateableAssetManager"%>
<%!
private void buildItem(StringBuilder jsonBuilder, String resultValue, String resultId, int resultCount) {
	if (resultCount != 0)
		jsonBuilder.append(",");

	jsonBuilder.append("{");
	
	if (null != resultId) 	
		jsonBuilder.append("\"assetid\":\"").append(resultId)
				   .append("\"" + ",");
				
	jsonBuilder.append("\"value\": \"").append(resultValue)
			   .append("\"}");
}
%>
<cs:ftcs>
<asset:list type='<%=ics.GetVar("parentTemplateType")%>' list='tmplList' field1='id' value1='<%=ics.GetVar("parentDefinitionId")%>'/>
<%
IList tmpllist = ics.GetList("tmplList");
%>
<ics:setvar name='<%="req"+tmpllist.getValue("name")%>' value='<%=ics.GetVar("required")%>'/>
<ics:setvar name='<%="mult"+tmpllist.getValue("name")%>' value='<%=ics.GetVar("multiple")%>'/>
<ics:setvar name='<%="_id_"+tmpllist.getValue("name")%>' value='<%=ics.GetVar("parentDefinitionId")%>'/>
<listobject:create name='singleTmpl' columns='assetid'/>
<listobject:addrow name='singleTmpl'>
	<listobject:argument name='assetid' value='<%=ics.GetVar("parentDefinitionId")%>'/>
</listobject:addrow>
<listobject:tolist name='singleTmpl' listvarname='mycurrentList'/>
<%
IAssetTypeManager atm = AssetTypeManagerFactory.getATM(ics);
ITemplateableAssetManager itam = (ITemplateableAssetManager)atm.locateAssetManager(ics.GetVar("grouptype"));
IList myparentgroups = itam.getSortedTypedAssets(ics.GetSSVar("pubid"),ics.GetList("mycurrentList"));

ics.RegisterList("MyParentGroups",myparentgroups);
ics.ClearErrno();

StringBuilder jsonBuilder = new StringBuilder("");
int resultCount = 0;
String qryString = org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(ics.GetVar("value"));
String resultValue = "";
String resultID = "";
String keyString = "";

jsonBuilder.append("{")
			.append("\"identifier\":\"assetid\"" + ",")
			.append("\"label\":\"value\"" + ",") 
			.append("\"items\": [");
%>
<ics:if condition='<%=null != ics.GetList("MyParentGroups")%>'>
<ics:then>
	<ics:if condition='<%=ics.GetList("MyParentGroups").hasData()%>'>
	<ics:then>
		<ics:listloop listname="MyParentGroups">
			<ics:listget listname="MyParentGroups" fieldname="assetid" output="resultId" />			
			<ics:listget listname="MyParentGroups" fieldname="name" output="resultValue" />
<%
				resultID = ics.GetVar("resultId");
				resultValue = org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(ics.GetVar("resultValue"));				
				if (null == qryString || qryString.equalsIgnoreCase(resultValue) || qryString.equals(resultID) || "*".equals(qryString)) {
					buildItem(jsonBuilder, resultValue, resultID, resultCount);
					resultCount++;			
				}
				else if (qryString.endsWith("*")) {
					keyString = qryString.substring(0 , qryString.indexOf("*"));
					if (null != resultValue && 
						resultValue.toLowerCase()
								   .startsWith(keyString.toLowerCase()))
					{
						buildItem(jsonBuilder, resultValue, resultID, resultCount);
						resultCount++;
					}	
				}	
%>
		</ics:listloop>	
	</ics:then>
	</ics:if>
</ics:then>
</ics:if>
<%
	jsonBuilder.append("]}");
%>
<%=jsonBuilder.toString()%>
<ics:removevar name="tmplList"/>
<ics:removevar name="MyParentGroups"/>
</cs:ftcs>