<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"  
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%
//
// OpenMarket/Gator/AttributeTypes/DisplayTEXTAREA
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList,
				COM.FutureTense.Interfaces.ICS,
				COM.FutureTense.Interfaces.IList,
				COM.FutureTense.Interfaces.Utilities,
				COM.FutureTense.Util.ftErrors,
				COM.FutureTense.Util.ftMessage,
				com.openmarket.xcelerate.publish.EmbeddedLink"
%><cs:ftcs>
<%
boolean isCKEditor = ("CKEDITOR".equals(ics.GetVar("MyAttributeType"))||"CKEDITOR".equals(ics.GetVar("formfieldtype"))||"FCKEDITOR".equals(ics.GetVar("formfieldtype"))) ? true : false;
if(ics.GetVar("assetMakerAsset") == null){
%>
<ics:callelement element="OpenMarket/Gator/AttributeTypes/getprimaryattributevalue">
	<ics:argument name="presentationattribute" value="ASSETTYPENAME"/>
</ics:callelement>

<ics:callelement element="OpenMarket/Gator/AttributeTypes/getprimaryattributevalue">
	<ics:argument name="presentationattribute" value="ATTRIBUTETYPENAME"/>
</ics:callelement>

<ics:callelement element="OpenMarket/Gator/AttributeTypes/getprimaryattributevalue">
	<ics:argument name="presentationattribute" value="ATTRIBUTENAME"/>
</ics:callelement>

<ics:setvar name="doDefaultDisplay" value="no"/>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
<tr>
<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/DisplayAttributeName"/>
<td></td>
<td class="form-inset">
<%
if("url".equals(ics.GetVar("AttrType"))){
%>
	<ics:if condition='<%=ics.GetList("AttrValueList",false)!=null && ics.GetList("AttrValueList",false).hasData()%>'>
	<ics:then>
		<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/DisplayURLValue"/>
	</ics:then>
	</ics:if>
<%
} else {
%>
<ics:if condition='<%=ics.GetList("AttrValueList",false)!=null && ics.GetList("AttrValueList",false).hasData()%>'>
<ics:then>
	<ics:listloop listname="AttrValueList">
	<ics:listget listname="AttrValueList" fieldname="value" output="EditorValue" />
	<%
	EmbeddedLink link = new EmbeddedLink(ics,ics.GetVar("EditorValue"),false,false,true);
	String ret = null;
	if (isCKEditor)
		 ret = org.apache.commons.lang.StringEscapeUtils.escapeHtml(link.evaluate());
	else
		ret = link.evaluate();
	%>
	<%
	if(ics.GetList("AttrValueList",false).currentRow() != 1){
	%>
	<IMG WIDTH="1" HEIGHT="20" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/>
	<%	
	}
	if(isCKEditor)
	{
	 %>
	 <div dojoType="dojox.layout.ContentPane" style='padding:4px 0 0 4px; width:580px; min-height:50px; border:1px solid #E6E6E6'>
		<%=org.apache.commons.lang.StringEscapeUtils.unescapeHtml(ret)%>
		<script type="dojo/method">
			/*This is preventing the links from opening in the same iframe inside our forms.
			  This will not have any impact on actual site in production.
			*/
			dojo.query('a', this.domNode).forEach(function(node){
				dojo.attr(node, 'target', '_blank');
			});
		</script>
	</div>	
	<%
	}
	else 
	{
	%>
	<div>
		<string:stream value='<%=ret %>'/>
	</div>
	<%}%>
	
	</ics:listloop>
</ics:then>
<ics:else>
	<span class="disabledText"><xlat:stream key='UI/Forms/NotAvailable' encode="false" escape="true"/></span>
</ics:else>
</ics:if>
<%}%>
</td>
</tr>
<%} else {
	EmbeddedLink link = new EmbeddedLink(ics,ics.GetVar("EditorValue"),false,false,true);
	String ret = null;
	if (isCKEditor)
		 ret = org.apache.commons.lang.StringEscapeUtils.escapeHtml(link.evaluate());
	else
		ret = link.evaluate();
	%>
	<div dojoType="dojox.layout.ContentPane" style='padding:4px 0 0 4px; width:580px; min-height:50px; border:1px solid #E6E6E6'>
		<%
	if(isCKEditor)
	{
	 %><%=org.apache.commons.lang.StringEscapeUtils.unescapeHtml(ret)%>
	 <script type="dojo/method">
		/*This is preventing the links from opening in the same iframe inside our forms.
		  This will not have any impact on actual site in production.
		*/
		dojo.query('a', this.domNode).forEach(function(node){
			dojo.attr(node, 'target', '_blank');
		});
	</script>
	 <%
	}
	else 
	{
	%><string:stream value='<%=ret %>'/>
	<%}%>
	</div>
<%	
}
%>
</cs:ftcs>