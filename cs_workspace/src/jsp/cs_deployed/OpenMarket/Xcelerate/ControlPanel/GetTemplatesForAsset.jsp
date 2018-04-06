<%@ page contentType="text/xml; charset=UTF-8" 
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld" 
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" 
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld" 
%><%//
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList" 
%><%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" 
%><cs:ftcs>
<ics:getproperty file="futuretense_xcel.ini" name="xcelerate.previewhost" output="preview-host"/>
<ics:getproperty file="futuretense_xcel.ini" name="xcelerate.previewservlet" output="preview-servlet"/>
<usermanager:getloginusername varname="thisusername"/>
<ics:getproperty file="futuretense_xcel.ini" name="xcelerate.enableinsite" output="insiteenabled"/>
<string:encode variable="defTemplate" varname="defTemplate"/>
<%
String insiteEnabled = ics.GetVar("insiteenabled");
boolean isInsiteEnabled = insiteEnabled != null && "true".equals(insiteEnabled);
String rendermode = isInsiteEnabled?"preview-"+ics.GetVar("thisusername")+"-"+ics.GetSSVar("pubid"):"previewnoinsite";
String currentWrapper = ics.GetVar("currentWrapper");
%><asset:load type='<%=ics.GetVar("AssetType")%>' objectid='<%=ics.GetVar("id") %>' name="theCurrentAsset"/>
<ics:if condition='<%=ics.GetErrno() == 0%>'>
<ics:then>
	<asset:get name="theCurrentAsset" field="name" />
	<assettype:load name="type" type='<%=ics.GetVar("AssetType")%>' />
	
	<ics:if condition='<%=ics.GetVar("defTemplate") == null%>'>
	<ics:then>
	
		<ics:if condition='<%=ics.GetVar("target") != null%>'>
		<ics:then>
			<asset:gettemplatefortarget name="theCurrentAsset" target='<%=ics.GetVar("target") %>' output="defTemplate"/>
		</ics:then>
		<ics:else>
			<asset:get name="theCurrentAsset" field="template" output="defTemplate" />
		</ics:else>
		</ics:if>
	</ics:then>
	</ics:if>
	{ 
		"defaultTemplate": "<%=(ics.GetVar("defTemplate") == null?"":ics.GetVar("defTemplate"))%>",
	<asset:getsubtype name="theCurrentAsset" output="subtype" />
	<ics:if condition='<%=("SiteEntry".equals(ics.GetVar("AssetType")) ||  "CSElement".equals(ics.GetVar("AssetType")))%>'>
	<ics:then>
		<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/MakeURLWithWrapper">
			<ics:argument name="AssetType" value='<%=ics.GetVar("AssetType") %>' />
			<ics:argument name="id" value='<%=ics.GetVar("id") %>' />
			<ics:argument name="thisrendermode" value="<%=rendermode %>" />
			<ics:argument name="templatename" value='<%="OpenMarket/" + ics.GetVar("AssetType") + "Template" %>' />
		</ics:callelement>
		"templates": [
			{
				"name": "<%="OpenMarket/" + ics.GetVar("AssetType") + "Template" %>",
				"url": "<ics:getvar name="previewURL"/>",
				"selected": true
			}
		]
	</ics:then>
	<ics:else>
		<asset:list type="SiteEntry" list="SEWrappers" field1="cs_wrapper" value1="y" pubid='<%=ics.GetSSVar("pubid") %>' excludevoided="true" order="name"/><%
		IList wrapperList = ics.GetList("SEWrappers");
		if (wrapperList != null && wrapperList.hasData()) {
			if (currentWrapper == null) {
				currentWrapper = wrapperList.getValue("name");
			}
		}
		//TODO Clean this up
		FTValList args = new FTValList();
		args.setValString("LISTVARNAME", "Templates");
		args.setValString("ASSETTYPE", ics.GetVar("AssetType"));
		args.setValString("TTYPE", "x");
		args.setValString("SUBTYPE", ics.GetVar("subtype"));
		args.setValString("PUBID", ics.GetSSVar("pubid"));
		ics.runTag("TemplateManager.GetTemplateNames", args);
		IList templateList = ics.GetList("Templates");
		
		args = new FTValList();
		args.setValString("LISTVARNAME", "Layouts");
		args.setValString("ASSETTYPE", ics.GetVar("AssetType"));
		args.setValString("TTYPE", "l");
		args.setValString("SUBTYPE", ics.GetVar("subtype"));
		args.setValString("PUBID", ics.GetSSVar("pubid"));
		ics.runTag("TemplateManager.GetTemplateNames", args);
		IList layoutList = ics.GetList("Layouts");
		boolean templateHasData = false;
		out.print("\"templates\": [");
		if (templateList != null && templateList.hasData()) {
			templateHasData = true;
			while (!templateList.atEnd()) {%> 			
				<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/MakeURLWithWrapper">
					<ics:argument name="AssetType" value='<%=ics.GetVar("AssetType") %>' />
					<ics:argument name="id" value='<%=ics.GetVar("id") %>' />
					<ics:argument name="thisrendermode" value="<%=rendermode %>" />
					<ics:argument name="templatename" value='<%=templateList.getValue("tname")%>' />
					<ics:if condition='<%=currentWrapper != null %>'>
						<ics:argument name="wrapperpage" value="<%=currentWrapper %>" />
					</ics:if>
				</ics:callelement>								
				{
					"name": "<%=templateList.getValue("name")%>",
					"tname": "<%=templateList.getValue("tname")%>",
					"url": "<ics:getvar name="previewURL"/>",
					"selected": <%=templateList.getValue("tname").equals(ics.GetVar("defTemplate"))%>
				}
				<% templateList.moveToRow(IList.next, 0);
				   if (!templateList.atEnd()) out.print(",");
			} // end while						
		} // end if
		if (layoutList != null && layoutList.hasData()) {
			if(templateHasData) out.print(",");
			while (!layoutList.atEnd()) {%> 			
				<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/MakeURLWithWrapper">
					<ics:argument name="AssetType" value='<%=ics.GetVar("AssetType") %>' />
					<ics:argument name="id" value='<%=ics.GetVar("id") %>' />
					<ics:argument name="thisrendermode" value="<%=rendermode %>" />
					<ics:argument name="templatename" value='<%=layoutList.getValue("tname")%>' />
					<ics:if condition='<%=currentWrapper != null %>'>
						<ics:argument name="wrapperpage" value="<%=currentWrapper %>" />
					</ics:if>
				</ics:callelement>								
				{
					"name": "<%=layoutList.getValue("name")%>",
					"tname": "<%=layoutList.getValue("tname")%>",
					"url": "<ics:getvar name="previewURL"/>",
					"selected": <%=layoutList.getValue("tname").equals(ics.GetVar("defTemplate"))%>
				}
				<% layoutList.moveToRow(IList.next, 0);
				   if (!layoutList.atEnd()) out.print(",");
			} // end while						
		} // end if
		out.print("],");				
		%>
		"wrappers": [
		<%
		if (wrapperList != null && wrapperList.hasData()) {
			while (!wrapperList.atEnd()) {
			%>{           
            		"name": "<%=wrapperList.getValue("name")%>",
	            	"selected": <%=wrapperList.getValue("name").equals(ics.GetVar("currentWrapper"))%>
				} <% 
				wrapperList.moveToRow(IList.next, 0);	
				if (!wrapperList.atEnd()) out.print(",");
			}
		}%>
		]
	</ics:else>
	</ics:if>
</ics:then>
</ics:if>
}	
</cs:ftcs>
