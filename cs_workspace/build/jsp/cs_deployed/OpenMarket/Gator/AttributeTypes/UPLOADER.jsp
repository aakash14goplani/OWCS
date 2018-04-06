<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="hash" uri="futuretense_cs/hash.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/UPLOADER
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
<cs:ftcs>
<%
	ics.SetVar("doDefaultDisplay", "no");
	
	FTValList args = new FTValList();
	args.setValString("NAME", ics.GetVar("PresInst"));
	args.setValString("ATTRIBUTE", "MAXVALUES");
	args.setValString("VARNAME", "OVERRIDEMAXVALUES");
	ics.runTag("presentation.getmaxvalues", args);
	args.setValString("ATTRIBUTE", "MAXFILESIZE");
	args.setValString("VARNAME", "MAXFILESIZE");
	ics.runTag("presentation.getmaxfilesize", args);
	args.setValString("ATTRIBUTE", "FILETYPES");
	args.setValString("VARNAME", "FILETYPES");
	ics.runTag("presentation.getfiletypes", args);
	args.setValString("ATTRIBUTE", "MINWIDTH");
	args.setValString("VARNAME", "MINWIDTH");
	ics.runTag("presentation.getminwidth", args);
	args.setValString("ATTRIBUTE", "MAXWIDTH");
	args.setValString("VARNAME", "MAXWIDTH");
	ics.runTag("presentation.getmaxwidth", args);
	args.setValString("ATTRIBUTE", "MINHEIGTH");
	args.setValString("VARNAME", "MINHEIGTH");
	ics.runTag("presentation.getminheight", args);
	args.setValString("ATTRIBUTE", "MAXHEIGHT");
	args.setValString("VARNAME", "MAXHEIGHT");
	ics.runTag("presentation.getmaxheight", args);
%>

<ics:if condition='<%= "no".equalsIgnoreCase(ics.GetVar("MultiValueEntry")) %>'>
<ics:then>
	<ics:callelement element='OpenMarket/Gator/AttributeTypes/ProcessValues'>
		<ics:argument name='AttrType' value='<%= ics.GetVar("type") %>' />
	</ics:callelement>
</ics:then>
</ics:if>

<ics:callelement element='OpenMarket/Gator/AttributeTypes/RenderSWFUpload'>
	<ics:argument name='RequiredAttr' value='<%= ics.GetVar("RequiredAttr") %>'/>
	<ics:argument name='RequireInfo' value='<%= ics.GetVar("RequireInfo") %>'/>
</ics:callelement>


<ics:removevar name="OVERRIDEMAXVALUES"/>
<ics:removevar name="MAXFILESIZE"/>
<ics:removevar name="FILETYPES"/>
<ics:removevar name="MINWIDTH"/>
<ics:removevar name="MINHEIGTH"/>
<ics:removevar name="MAXWIDTH"/>
<ics:removevar name="MAXHEIGHT"/>

</cs:ftcs>