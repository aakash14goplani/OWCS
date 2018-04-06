<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ page import="COM.FutureTense.Interfaces.*,COM.FutureTense.Util.ftMessage,COM.FutureTense.Util.ftErrors"%>
<cs:ftcs>
<%--
	CSELEMENT:  OpenMarket/Gator/AttributeTypes/HELLOWORLD
	INPUT: 		whatever the XML passes via the Attribute Editor
	OUTPUT: 	renders the current attribute in the Advanced Interface
--%>
	<ics:if condition='<%=ics.GetVar("eid")!=null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/>
		</ics:then>
	</ics:if>
	<% if ( "no".equals(ics.GetVar("MultiValueEntry")) ) { %>
		<ics:setvar name="doDefaultDisplay" value="no" />
		<tr>
			<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/DisplayAttributeName" />
			<td></td>
			<td>
	<%
			FTValList args = new FTValList();
			args.setValString("NAME", ics.GetVar("PresInst"));
			args.setValString("ATTRIBUTE", "SIZE");
			args.setValString("VARNAME", "size");
			ics.runTag("presentation.getprimaryattributevalue", args);
			args.setValString("ATTRIBUTE", "MESSAGE");
			args.setValString("VARNAME", "message");
			ics.runTag("presentation.getprimaryattributevalue", args);
			if ( "single".equals(ics.GetVar("EditingStyle")) ) {
			    ics.SetVar("inputName", ics.GetVar("cs_SingleInputName") );
			    ics.SetVar("inputValue", ics.GetVar("MyAttrVal") );
			} else { // it is multi-valued
	    		ics.SetVar("inputName", ics.GetVar("cs_MultipleInputName"));
	    		ics.SetVar("inputValue", ics.GetVar("tempval") ); 
	    		if ( "true".equals(ics.GetVar("RequiredAttr")) ) { 
	%>
	    			<ics:resolvevariables name="Variables.RequireInfo*Variables.cs_MultipleInputName*Variables.AttrName*ReqTrue*Variables.AttrType!" output="RequireInfo" />
	<% 
				} else { 
	%>
	    			<ics:resolvevariables name="Variables.RequireInfo*Variables.cs_MultipleInputName*Variables.AttrName*ReqFalse*Variables.AttrType!" output="RequireInfo" />
	<% 			} // endif
			} // endif 
	%>
			<input type="text" name = "<ics:getvar name="inputName" />" value = "<ics:getvar name="inputValue" />" size = "<ics:getvarname="size" />" />
			(<ics:getvar name="message"/>)
			</td>
		</tr>
	<% 
		} // endif 
	%>
</cs:ftcs>