<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@page import="com.openmarket.ICS.listloop"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ page import="java.util.*, java.text.*, java.io.*"
%><%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld"%>
<%//
// OpenMarket/Xcelerate/Admin/DeleteAssets
//
// INPUT
//
// OUTPUT
//%>


<cs:ftcs>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment" />
	<ics:callelement element="OpenMarket/Gator/UIFramework/UITimeOutCheck" />
	<ics:callelement element="OpenMarket/Xcelerate/Util/SetLocale"/>

	<%
		String contextPath= request.getContextPath();
		String locale = (String)session.getAttribute("locale");
		String defaultLocale = (String)session.getAttribute("defaultLocale");
		locale = defaultLocale == null ? "en_US": defaultLocale;
	%>
	<html>
		<head>
			<LINK href='<%=contextPath%>/Xcelerate/data/css/<%=locale%>/common.css' rel="stylesheet" type="text/css" />
			<LINK href='<%=contextPath%>/Xcelerate/data/css/<%=locale%>/content.css' rel="stylesheet" type="text/css" />
			<LINK href='<%=contextPath%>/Xcelerate/data/css/<%=locale%>/cacheTool.css' rel="stylesheet" type="text/css" />
			<ics:callelement element="OpenMarket/Xcelerate/Util/LoadDefaultStyleSheet">
				<ics:argument name="cssFilesToLoad" value="common.css,content.css,cacheTool.css"/>
			</ics:callelement>
			<script type="text/javascript">
				function search()
				{
					var assetType = document.getElementById("assetType");
					document.getElementById("assetType").value = assetType;
					document.forms[0].submit();	
				}
			</script>
		</head>
		<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
			<tbody>
				<tr>
					<td>
						<span class="title-text"><xlat:stream key="fatwire/SystemTools/DeleteAssets/Heading" encode="true" escape="false" evalall="false"/></span>
					</td>
				</tr>
				<tr>
					<td>
						<img width="1" height="5" src="<%=contextPath%>/Xcelerate/graphics/common/screen/dotclear.gif">
					</td>
				</tr>
				<tr>
					<td style="border-bottom: 1px dashed #B9B9B9; clear: both; color: #9E9E9E; font-size: 12px;font-weight: bold;">
						<img width="1" height="1" src="<%=contextPath%>/Xcelerate/graphics/common/screen/dotclear.gif">
					</td>
				</tr>
			</tbody>
		</table>
		</br>
		<div class="width-outer-70">
			<b><xlat:stream key="fatwire/SystemTools/DeleteAssets/SubHeading" encode="true" escape="false" evalall="false"/></b>
		</div>
		<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
			<tr><td>
			
				<ics:ifnotempty variable="assetType">
					<ics:then>
						<ics:if condition='<%="_ALL_".equals(ics.GetVar("assetType"))%>'>
							<ics:then>
								<assettype:list list="allAssetTypes"/>
							</ics:then>
							<ics:else>
								<listobject:create name="allAssetTypes" columns="assettype" />
								<listobject:addrow name="allAssetTypes">
									<listobject:argument name="assettype" value='<%=ics.GetVar("assetType")%>' />
								</listobject:addrow>
								<listobject:tolist name="allAssetTypes" listvarname="allAssetTypes" />
							</ics:else>
						</ics:if>
						<ics:listloop listname="allAssetTypes">
							<ics:listget listname="allAssetTypes" fieldname="assettype" output="assettype" />
							<asset:list type='<%=ics.GetVar("assettype")%>' list="deletelist" field1="status" value1="VO" />
							<ics:ifnotempty list="deletelist">
								<ics:then>
									<ics:listget listname="deletelist" fieldname="#numRows" output="count" />
									
									<listobject:create name="inputListName" columns="assetid,assettype" />
									<ics:listloop listname="deletelist">	
										<ics:listget listname="deletelist" fieldname="id" output="assetId" />
										<listobject:addrow name="inputListName">
											<listobject:argument name="assetid" value='<%=ics.GetVar("assetId")%>' />
											<listobject:argument name="assettype" value='<%=ics.GetVar("assettype")%>' />
										</listobject:addrow>	
									</ics:listloop>
									<listobject:tolist name="inputListName" listvarname="assetInputList" />
									<asset:deletevoids list="assetInputList" />
									 
									<ics:if condition="<%=ics.GetErrno()!=0%>">
										<ics:then>
											<xlat:stream key="dvin/Common/Error"/> <ics:geterrno/>
										</ics:then>
										<ics:else>
											<xlat:stream key="fatwire/SystemTools/DeleteAssets/DeletedAssetType" encode="true" escape="false" evalall="false">
												<xlat:argument name="assettype" value='<%=ics.GetVar("assettype")%>'/>
												<xlat:argument name="count" value='<%=ics.GetVar("count")%>'/>
											</xlat:stream><br/>
										</ics:else>
									</ics:if>
								</ics:then>
								<ics:else>
									<xlat:stream key="fatwire/SystemTools/DeleteAssets/NoAssetsToDelete" encode="true" escape="false" evalall="false">
										<xlat:argument name="assettype" value='<%=ics.GetVar("assettype")%>'/>
									</xlat:stream><br/>
								</ics:else>
							</ics:ifnotempty>
						</ics:listloop>
					</ics:then>
				</ics:ifnotempty>
				
				<div>
					<div style="float:left;margin-right:10px;">
						<select name="assetType" id="assetType">
							<option value='_ALL_' ><xlat:stream key="dvin/Common/All" encode="true" escape="false" evalall="false"/></option>
							<assettype:list list="assetTypes" order="assettype" />
							<ics:listloop listname="assetTypes">
								<ics:listget listname="assetTypes" fieldname="assettype" output="assettype" />
								<option value='<%=ics.GetVar("assettype")%>' ><%=ics.GetVar("assettype")%></option>
							</ics:listloop>
						</select>
					</div>
					<input type="hidden" name="pagename" id="pagename" value="OpenMarket/Xcelerate/Admin/DeleteAssets"/>
					<A HREF="javascript:void(0);" onClick="{document.forms['AppForm'].submit(); return false;}">
						<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton">
							<ics:argument name="buttonkey" value="dvin/Common/Purge"/>
						</ics:callelement>
					</A>
				</div>
				<br/>
			</td></tr>
		</table>
	</html>
</cs:ftcs>