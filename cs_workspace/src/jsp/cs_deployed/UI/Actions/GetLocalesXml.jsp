<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ page import="COM.FutureTense.Interfaces.*,
                COM.FutureTense.Util.*,
                java.util.*"%>
<%//
// UI/Actions/GetLocalesXml
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
<ics:if condition='<%=!"true".equals(System.getProperty("cs.disable.dimensions.in.ui"))%>'>
<ics:then><% 
	String pubid = ics.GetSSVar("pubid"); 
	String sql = "select nid from PublicationTree where oid=(select id from AssetType where assettype='Dimension') and nparentid=(select nid from PublicationTree where oid=" + pubid +")";%>
	<ics:sql  sql='<%=sql%>' listname="queryResults" table="PublicationTree"/>
	<ics:if condition='<%=ics.GetList("queryResults") != null && ics.GetList("queryResults").numRows()>0%>'>
	<ics:then>
		<asset:list type="Dimension" list="listLocales" order="name" pubid='<%=ics.GetSSVar("pubid")%>' excludevoided="true">
			<asset:argument name="subtype" value="Locale"/>
		</asset:list>
		<div dojoType="fw.dijit.UIMenu"><%
			for ( IList row : new IterableIListWrapper( ics.GetList("listLocales") ) ) {
				String sLocale = row.getValue("name");
				String sLocaleDesc = row.getValue("description");
				String sLocaleID = row.getValue("id");
				String itemType;%>
				<div dojoType="fw.dijit.UIMenuItem" functionid="translate" topicArgs="{dimension: {type: 'Dimension', id: <%=sLocaleID%>}}">
					<span><%=sLocaleDesc != null ? sLocaleDesc : sLocale%></span>
				</div><%
			}
		%></div>
	</ics:then>
	</ics:if>
</ics:then>
</ics:if>
</cs:ftcs>