<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%//
// OpenMarket/Xcelerate/Admin/WebRefPatternFront
//
// INPUT
//
// OUTPUT
//%>
<%@page import="com.openmarket.xcelerate.asset.WebReferencePatternBean"%>
<%@page import="com.openmarket.xcelerate.asset.WebReferencesPattern"%>
<%@page import="java.util.*"%>
<%@ page import="com.openmarket.basic.interfaces.AssetException" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.fatwire.mobility.util.MobilityUtils"%>
<%@page import="com.fatwire.mobility.beans.DeviceGroupBean"%>
<%@page import="com.openmarket.xcelerate.asset.WebRootsManager"%>
<%@page import="com.fatwire.services.*"%>
<%@page import="com.fatwire.services.beans.*"%>
<%@ page import="com.fatwire.services.ServicesManager"%>
<%@page import="com.fatwire.services.beans.asset.basic.template.ArgumentBean"%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="com.fatwire.system.*"%>
<%@page import="com.openmarket.xcelerate.interfaces.ITemplateAssetManager"%>
<%@page import="com.openmarket.assetframework.interfaces.AssetTypeManagerFactory"%>
<%@page import="com.openmarket.assetframework.interfaces.IAssetTypeManager"%>
<%@page import="com.fatwire.mobility.util.MobilityUtils"%>
<%@page import="com.fatwire.assetapi.site.Site"%>
<%@page import="com.fatwire.assetapi.site.SiteManagerImpl"%>
<%@page import="com.fatwire.assetapi.common.SiteAccessException"%>
<%@ page import="com.fatwire.assetapi.util.AssetUtil"%>
<%@ page import="com.openmarket.gator.page.Page"%>
<%!
	private static final Log _log = LogFactory.getLog(ftMessage.GENERIC_DEBUG);
	
%>
<cs:ftcs>
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/Security/TimeoutError" outstring="urlstring"></satellite:link>
<%
	List<DeviceGroupBean> deviceGroupList = MobilityUtils.getDeviceGroups(ics);
	Map<String,List<String>> deviceGroupMap = new HashMap<String,List<String>>();
	Collections.reverse(deviceGroupList);
	for(DeviceGroupBean deviceGroup:deviceGroupList) {
		String deviceSuffix = deviceGroup.getDeviceGroupSuffix();
		if(deviceGroupMap.get(deviceSuffix) == null)
		{
			deviceGroupMap.put(deviceSuffix, new LinkedList<String>());
		}
		deviceGroupMap.get(deviceSuffix).add(deviceGroup.getName());
	}
	
	WebRootsManager webrootsManager = new WebRootsManager(ics);
%>
<style type="text/css">
body {
	padding: 0 !important;
}
.webRefPattern {
	padding: 20px;
	min-width: 960px;
}
h3 {
	margin: 0 0 30px;
	border-bottom: 1px dashed #b9b9b9;
	padding-bottom: 12px;
}
.webRefTable th {
	background: url('Xcelerate/graphics/common/screen/grad.gif') repeat-x 0 0;
	color: #fff;
}
</style>
<script>
	var updateTrees = function(keys) {
		parent.frames["XcelTree"].document.TreeApplet.updateTrees(keys);
	};
	
	var updateWebRefTableDetailView = function (index, elem, show) {
		var detail = dojo.byId('WebRefTableDetail_'+index);
		if(show) {
			detail.style.display = "block";
			elem.innerHTML = "<xlat:stream key='UI/Forms/ViewLess'/>";
			elem.onclick = function() {
				updateWebRefTableDetailView(index, this, false);
			}
		} else {
			detail.style.display = "none";
			elem.innerHTML = "<xlat:stream key='UI/Forms/ViewMore'/>";
			elem.onclick = function() {
				updateWebRefTableDetailView(index, this, true);
			}
		}
		return false;
	};
	
	var deletePattern = function (patternID, tableRowId){
		var self = this;
		var areYouSure = confirm("<xlat:stream key='dvin/UI/Common/DeleteConfirm'/>");
		if (!areYouSure)
			return false;
		var xhrArgs = {url: "ContentServer",
			content: {
				pagename: "OpenMarket/Xcelerate/WebRefPattern/DeletePattern",
				responseType: "json",
				patternId: patternID
			},
			preventCache: true,
			handleAs: "json",
			action: "delete"
		};
		dojo.xhrPost(xhrArgs).then(function(res) {
			if (res.error && res.error === "TimeOut") {
				parent.parent.location="<%=ics.GetVar("urlstring")%>";
				return;
			}
			if (dojo.isObject(res) && res.status === "success") {
				if (typeof window.updateTrees === "function") window.updateTrees("Self:<%=ics.GetVar("parentassettype")%>_WebRefPattern");
				dojo.destroy(tableRowId);
				dojo.destroy(tableRowId+"_1");
			}
		});
		return false;
	};
</script>
	<div class="webRefPattern">		
		<div>
			<h3><xlat:stream key='UI/Forms/UrlPatterns'/>:</h3>
		</div>
		<div data-dojo-type="dijit.layout.ContentPane" style="overflow:visible">
			<%
				IAssetTypeManager atm = AssetTypeManagerFactory.getATM(ics);
				ITemplateAssetManager tam = (ITemplateAssetManager)atm.locateAssetManager("Template");
				Session ses = SessionFactory.getSession();
				ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
				List<WebReferencePatternBean> patternlist = null;
				try 
				{					
					WebReferencesPattern webReferencesPattern = new WebReferencesPattern(ics);
					patternlist = webReferencesPattern.getForType(ics.GetVar("parentassettype"));
				} 
				catch(AssetException e) {
					_log.error("Unable to get pattern for given asset type: " + e.getMessage());
				}
				int total = patternlist != null ? patternlist.size() : 0;
				int index = 0;				
			%>
			<div class="webRefWrapper">
				<%	if(total == 0) { %>
					<div class='webRefTableNoData' style="padding-left:20px"><xlat:stream key='UI/Forms/NoURL'/></div>
				<%	} else { %>					
						<table class="webRefTable">
							<tr><td class="tile-dark" colspan="6" height="1" style="padding:0"><img width="1" height="1" src="Xcelerate/graphics/common/screen/dotclear.gif"></td></tr>
							<tr>
								<th width="100" class="center"><xlat:stream key='dvin/UI/Admin/Action'/></th>
								<th width="100" class="center"><xlat:stream key='dvin/UI/Common/Type'/></th>
								<th width="128"><xlat:stream key="dvin/Common/Name"/></th>
								<th><xlat:stream key='UI/Forms/Host'/></th>
								<th width="128"><xlat:stream key="dvin/Common/Site"/></th>
								<% if (AssetUtil.isFlexAsset(ics, ics.GetVar("parentassettype")) || Page.STANDARD_TYPE_NAME.equals(ics.GetVar("parentassettype")))  { %>
									<th width="128"><xlat:stream key="dvin/Common/Subtype"/></th>
								<% } %>
							</tr>
						<% 	for (WebReferencePatternBean pattern : patternlist) { 
							String params = pattern.getParams();
							%>
									
								<tr class="tableRow<%=index%2%>" id="tableRowId<%=index%>">
									<td rowspan="2" class="center">
										<xlat:lookup key="dvin/Common/Edit" varname="_XLAT_" escape="true"/>
										<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/WebRefPattern/PatternUIFront" outstring="urlPatternEditFront">
											<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
											<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
											<satellite:argument name="action" value="details"/>
											<satellite:argument name="urlPatternId" value='<%=String.valueOf(pattern.getId())%>'/>
											<satellite:argument name="assettype" value='<%=ics.GetVar("parentassettype")%>'/>
										</satellite:link>
										<a href="<%=ics.GetVar("urlPatternEditFront")%>" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true">
											<img height="14" width="14" hspace="2" vspace="4" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconEditContent.gif"  border="0" alt="<%=ics.GetVar("_XLAT_")%>" title="<%=ics.GetVar("_XLAT_")%>"  />
										</a>
										<xlat:lookup key="dvin/Common/Copy" varname="_XLAT_" escape="true"/>
										<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/WebRefPattern/PatternUIFront" outstring="urlPatternCopyFront">
											<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
											<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
											<satellite:argument name="action" value="copy"/>
											<satellite:argument name="urlPatternId" value='<%=String.valueOf(pattern.getId())%>'/>
											<satellite:argument name="assettype" value='<%=ics.GetVar("parentassettype")%>'/>
										</satellite:link>
										<a href="<%=ics.GetVar("urlPatternCopyFront")%>" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true">
											<img height="14" width="14" hspace="2" vspace="4" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconCopyContent.png"  border="0" alt="<%=ics.GetVar("_XLAT_")%>" title="<%=ics.GetVar("_XLAT_")%>"  />
										</a>
										<xlat:lookup key="dvin/Common/Delete" varname="_XLAT_" escape="true"/>
										<a href="javascript:void(0)" onclick="deletePattern('<%=pattern.getId()%>', 'tableRowId<%=index%>')" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true">
											<img height="14" width="14" hspace="2" vspace="4" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconDeleteContent.gif"  border="0" alt="<%=ics.GetVar("_XLAT_")%>" title="<%=ics.GetVar("_XLAT_")%>"  />
										</a>
									</td>
									<td rowspan="2" class="center">
										<%if(StringUtils.isBlank(pattern.getField())) { %>
										<img src="js/fw/images/ui/wem/webPage.png" width="35" height="28" alt="Web Page" title="Web Page" />
										<% } else { %>
										<img src="js/fw/images/ui/wem/blob.png" width="69" height="33" alt="Blob" title="Blob" />
										<%}%>
									</td>
									<td><%= pattern.getName() %></td>
									<td><%= webrootsManager.getWebRoot(pattern.getWebroot(), null) %></td>
									<td><%= pattern.getPublication() %></td>
									<xlat:lookup key='dvin/Common/Any' escape="false" varname="optionAny"/>
									<% if (AssetUtil.isFlexAsset(ics, ics.GetVar("parentassettype")) || Page.STANDARD_TYPE_NAME.equals(ics.GetVar("parentassettype")))  { %>
										<td><%= StringUtils.isBlank(pattern.getSubtype()) ? ics.GetVar("optionAny") : pattern.getSubtype() %></td>
									<% } %>
								</tr>
								<tr class="tableRow<%=index%2%>" id="tableRowId<%=index%>_1">
									<td colspan="4">
										<div id="WebRefTableDetail_<%=index%>" class="webRefTableDetail">										
											<strong><xlat:stream key='UI/Forms/Pattern'/>:</strong> <%=pattern.getPattern()%><br />
											<% if (StringUtils.isNotBlank(pattern.getField())) { %>
												<strong><xlat:stream key='dvin/Common/Field'/>:</strong> <%=pattern.getField()%><br />
												<strong><xlat:stream key='dvin/AT/Template/Parameters'/>:</strong> <%= pattern.getParams() %>
											<% } else { %>											
												<strong><xlat:stream key='dvin/UI/Template'/>:</strong> 
												<%= "__defaultassettemplate__".equals(pattern.getTemplate()) ? "<i>defaultassettemplate</i>" : pattern.getTemplate() %><br/>
												<strong><xlat:stream key='dvin/UI/Wrapper'/>:</strong> <%=pattern.getWrapper()%><br/>
												<strong><xlat:stream key='dvin/UI/Admin/DeviceGroup'/>:</strong> 
												<%= StringUtils.join(deviceGroupMap.get(pattern.getDgroup()), ",") %><br/>	
												<%	if(StringUtils.isNotEmpty(params))  {
												%>
												<strong><xlat:stream key='dvin/AT/Template/Parameters'/>:</strong> <br>
												<%												
												String template = pattern.getTemplate();
												String assetType = tam.getAssetTypeFromPageName(template);
												String tname = tam.getTemplateNameFromPageName(template);
												TemplateService templateDataService = servicesManager.getTemplateService();
												List<ArgumentBean> templateArgs = templateDataService.getTemplateArguments( tname, assetType );											
												String[] paramArr = params.split("&");
												for (String str : paramArr) {
													String paramValue = "&nbsp;&nbsp;&nbsp;&nbsp;";
													String[] strArr = str.split("=");
													for(ArgumentBean arguments:templateArgs) {
														if(strArr.length == 2) {
															if(strArr[0].equals(arguments.getName())) {
																paramValue +=arguments.getDescription() + "=";								
																	if(arguments.getValues().size() > 0)
																	{
																		 for(Map.Entry<String,String> entry:arguments.getValues().entrySet()) {
																			 String value =  entry.getKey();
																			 if(value.equals(strArr[1])) {
																				out.println(paramValue + entry.getValue() +"<br>");																						 
																			 }
																		 }
																	} else {
																			 out.println(paramValue + strArr[1]+"<br>");														 
																	}
																}
															}
														}
													}
										 		}
												%>
											<% } %>																					
										</div>
										<div class='viewLink'><a href='#' onclick='updateWebRefTableDetailView(<%=index%>, this, true)'><xlat:stream key='UI/Forms/ViewMore'/></a></div>
									</td>
								</tr>
						<% 		
								index ++;
							}
						%>
						</table>
				<% 	} %>
				<div style="padding-left:20px">
					<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/WebRefPattern/PatternUIFront" outstring="NewPatternURL">
						<satellite:argument name="action" value="new"/>
						<satellite:argument name="assettype" value='<%=ics.GetVar("parentassettype")%>'/>
					</satellite:link>
					<a HREF='<%=ics.GetVar("NewPatternURL")%>'>
						<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton">
							<ics:argument name="buttonkey" value="dvin/TreeApplet/AddNew"/>
						</ics:callelement>
					</a>
				</div>
			</div>
		</div>	
	</div>
</cs:ftcs>