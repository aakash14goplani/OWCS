<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%@ taglib prefix="url" uri="futuretense_cs/url.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/DeviceGroup/AdminTreeNodes/DeviceGroupMgt/ShowDeviceRepository
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"%>
<%@ page import="COM.FutureTense.Interfaces.ICS"%>
<%@ page import="COM.FutureTense.Interfaces.IList"%>
<%@ page import="COM.FutureTense.Interfaces.Utilities"%>
<%@ page import="COM.FutureTense.Util.ftErrors"%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Mobility.*"%>
<%@ page import="com.fatwire.mobility.device.*"%>
<%@ page import="java.util.*"%>
<%@ page import="COM.FutureTense.Mobility.DeviceRepositoryType"%>
<%!

	private static final String FILENAME_SUFFIX = "_filename";

	private static final void setFileName(ICS ics, String icsVarName, String value) {
		ics.SetVar(icsVarName + FILENAME_SUFFIX, value);
	}

	private static final String getFileName(ICS ics, String icsVarName) {
		String fileName = ics.GetVar(icsVarName + FILENAME_SUFFIX);
		
		return getFileNameFromPath(fileName);
	}
	
	private static final void setId(ICS ics, String icsVarName, String value) {
		ics.SetVar(icsVarName, value);
	}
	
	private static final String getId(ICS ics, String icsVarName) {
		return ics.GetVar(icsVarName);
	}
	
	private static final String getFileNameFromPath(String filePath) {
		return Utilities.goodString(filePath) ? filePath.substring(filePath.lastIndexOf('\\') + 1) : "";
	}

%>
<cs:ftcs>
	<style type="text/css">
.wurfl-header-text {
	font-size: 14px;
	float: left;
	font: #353636;
	font-weight: bold;
	white-space: nowrap;
	margin-left: 20px;
	text-decoration: none;
}

.wurfl-title-text {
	font-size: 14px;
	float: left;
	font: #353636;
	white-space: nowrap;
    font-weight: bold;
    text-decoration: none;
}

.wurfl-subtitle-text {
	font-size: 12px;
	font: #353636;
	text-align: right;
	padding-right: 10px;
	white-space: nowrap;
}

.wurfl-comments-text {
	font-size: 12px;
	font: #353636;
	white-space: nowrap;
}

.wurfl-border {
	border: 1px solid #cbc8c8;
	border-radius: 15px;
	width: 100%;
}

.wurfl-line-color {
	border-bottom: 1px dashed #bee7fa;
	clear: both;
}

.wurfl-dark-line-color {
	border-bottom: 1px solid #cbc8c8;
	clear: both;
}

.wurfl-dashed-color {
	border-bottom: 1px dashed #e3e2e2;
	clear: both;
}

.wurfl-left-padding {
	padding-left: 20px;
}

.wurfl-right-padding {
	padding-right: 15px;
}
</style>
	<script type="text/javascript">
	function save() {
		var obj = document.forms[0];
		if(checkfields()) obj.submit();
	}
	
	function checkfields()
	{
		var selectedDeviceRepoType = dojo.query('input[type=radio]:checked')[0]
			, uploadedDeviceRepoFile
			, deleteDeviceRepoFile
			, deviceRepoFileExtensions = {
				<% for (DeviceRepositoryType drt : DeviceRepositoryType.values()) { %>
					'<%= drt.getName() %>' : '<%= drt.getFileExtension() %>' ,
				<% } %>
			}
			, selectedDeleteDeviceRepo
			, wurflRootXmlName = '<%= DeviceRepositoryType.WURFLROOTXML.getName() %>'
			, wurflPatchXmlName = '<%= DeviceRepositoryType.WURFLPATCHXML.getName() %>'
			, xlatstr='<xlat:stream key="fatwire/admin/devicerepository/PleaseUploadDeviceRepositoryFile"/>'
			, replacestr=/Variables.filetype/
			;
		
		if (selectedDeviceRepoType) selectedDeviceRepoType = selectedDeviceRepoType.value;
		
		if (!selectedDeviceRepoType) {
			alert('<xlat:stream key="dvin/UI/Search/PleaseSelectAction"/>');
			return false;
		}
		
		uploadedDeviceRepoFile = dojo.query('input[name^=upload_' + selectedDeviceRepoType + ']')[0];
		deleteDeviceRepoFile = dojo.query('input[type=checkbox][name=delete-' + selectedDeviceRepoType + ']')[0];
		
		if (!deleteDeviceRepoFile) deleteDeviceRepoFile = dojo.query('input[type=hidden][name=old-uploaded-' + selectedDeviceRepoType + ']')[0];
		if (uploadedDeviceRepoFile) uploadedDeviceRepoFile = uploadedDeviceRepoFile.value;
		if (deleteDeviceRepoFile) selectedDeleteDeviceRepo = deleteDeviceRepoFile.checked;
		if (deleteDeviceRepoFile) deleteDeviceRepoFile = deleteDeviceRepoFile.value;
		
		if (selectedDeviceRepoType && !deleteDeviceRepoFile && !uploadedDeviceRepoFile)
		{
			alert(xlatstr.replace(replacestr,deviceRepoFileExtensions[selectedDeviceRepoType]));
			return false;
		}
		
		if (uploadedDeviceRepoFile && uploadedDeviceRepoFile.indexOf('.' + deviceRepoFileExtensions[selectedDeviceRepoType]) === -1) 
		{
			alert(xlatstr.replace(replacestr,deviceRepoFileExtensions[selectedDeviceRepoType]));
			return false;
		}
			
		if (wurflRootXmlName === selectedDeviceRepoType) {
			uploadedPatchDeviceRepoFile = dojo.query('input[name^=upload_' + wurflPatchXmlName + ']')[0];
			if (uploadedPatchDeviceRepoFile) uploadedPatchDeviceRepoFile = uploadedPatchDeviceRepoFile.value;
			if (uploadedPatchDeviceRepoFile && uploadedPatchDeviceRepoFile.indexOf('.' + deviceRepoFileExtensions[selectedDeviceRepoType]) === -1) 
			{
				alert(xlatstr.replace(replacestr,deviceRepoFileExtensions[selectedDeviceRepoType]));
				return false;
			}
		}
		
		return true;
	}
	
	function makeActive(){
		var selectedRadioButton = dojo.query('input[type=radio]:checked')[0],
			selectedname = selectedRadioButton ? selectedRadioButton.value : selectedRadioButton,
			allUploadDeletes = dojo.query('input[name^=upload_],input[name^=delete-]'),
			wurflRootXmlName = '<%= DeviceRepositoryType.WURFLROOTXML.getName() %>',
			wurflPatchXmlName = '<%= DeviceRepositoryType.WURFLPATCHXML.getName() %>';
		
		for ( var i = 0; i < allUploadDeletes.length; i++) 
			allUploadDeletes[i].disabled = true;
		
		if (selectedname) {
			dojo.query('input[name^=upload_'+selectedname+'],input[name^=delete-'+selectedname+']').forEach(function(node){
				node.disabled = false;
			});
			if( selectedname === wurflRootXmlName){
				dojo.query('input[name^=upload_'+wurflPatchXmlName+'],input[name^=delete-'+wurflPatchXmlName+']').forEach(function(node){
					node.disabled = false;
				});
			}
		} 
	}
	
	dojo.addOnLoad(function(){
		makeActive();
	});
</script>

<%
	
	DeviceRepository dr = new DeviceRepository(ics);
	List<DeviceRepositoryObject> allDeviceRepos = dr.getAll();
	
	for (DeviceRepositoryObject dro : allDeviceRepos) 
	{
		setFileName(ics, dro.getType(), dro.getFileName());
		setId(ics, dro.getType(), dro.getId());
		
		if (dro.getActive()) 
			ics.SetVar("device-repository-type", dro.getType());
	}
	
%>
<div dojoType="dijit.layout.ContentPane" region="top">
	<div class='toolbarContent'>
		<xlat:lookup  key="dvin/UI/Save" varname="_ALT_"/>
		<A HREF='javascript:save();'>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ToolBarButton">
				<ics:argument name="buttonImage" value="save.png" />
				<ics:argument name="toolbartitle" value='<%= ics.GetVar("_ALT_") %>' />
			</ics:callelement>
		</A>
	</div>
	<div id="msgArea"></div>
	<div class="toolbarBorder"></div>
</div>
	<satellite:form assembler="query" method="post" enctype="multipart/form-data">
		<ics:setvar name="defaultFormStyle" value="true"/>
		<table border="0" cellpadding="0" cellspacing="0" class="width-outer-70">
			<tr>
				<td>
				<div class="wurfl-title-text"><xlat:stream key="fatwire/admin/mobility/DeviceRepository/DeviceRepositoryUploader" /></div>
				</td>
			</tr>

			<tr>
				<td><img height="5" width="1" src='<%=ics.GetVar("cs_imagedir")+ "/graphics/common/screen/dotclear.gif"%>' /></td>
			</tr>
			<tr>
				<td class="wurfl-line-color"><img height="2" width="1" src='<%=ics.GetVar("cs_imagedir")+ "/graphics/common/screen/dotclear.gif"%>' /></td>
			</tr>
			<tr>
				<td><img height="10" width="1" src='<%=ics.GetVar("cs_imagedir")+ "/graphics/common/screen/dotclear.gif"%>' /></td>
			</tr>

			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer" />
			<tr>
				<td>

				<table class="wurfl-border" border="0" cellpadding="0" cellspacing="0">
										
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer">
						<ics:argument name="colspan" value="4" />
					</ics:callelement>
					
					<tr>
						<td>
						<div class="wurfl-left-padding"><input type="radio" name="device-repository-type" value="<%= DeviceRepositoryType.DEVICESXML.getName() %>" 
						<% if (DeviceRepositoryType.DEVICESXML.getName().equals(ics.GetVar("device-repository-type"))) { %>
							checked="true"
						<% } %> 
						onclick="makeActive()"/>
						</div>
						</td>
						<td></td>
						<td>
						<div class="wurfl-title-text"><xlat:stream key="fatwire/admin/mobility/DeviceRepository/DefaultCSRepository" /></div>
						</td>
						<td></td>
					</tr>

					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer">
						<ics:argument name="colspan" value="4" />
					</ics:callelement>

					<tr>
						<td></td>
						<td></td>
						<td>
						<div class="wurfl-subtitle-text"><xlat:stream key="fatwire/admin/mobility/DeviceRepository/UploadDefaultRepository" /></div>
						</td>
						<td class="wurfl-right-padding"><ics:callelement element="OpenMarket/Gator/AttributeTypes/CommonDojoxUploader">
							<ics:argument name="inputTagName" value='<%= "upload_" + DeviceRepositoryType.DEVICESXML.getName() %>' />
						</ics:callelement></td>
					</tr>

					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td>
						<div class="wurfl-comments-text">(<xlat:stream key="fatwire/admin/mobility/DeviceRepository/SingleXmlFileUpload" />)</div>
						</td>
					</tr>
					
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td>
							<url:unpack value='%0D%0A' varname='CRLF'/>
							<url:pack value='<%= getFileNameFromPath(getFileName(ics, DeviceRepositoryType.DEVICESXML.getName())) %>' varname='encFileName'/>
							<url:pack value='application/xml' varname='encCT'/>
							<% if (null != getId(ics, DeviceRepositoryType.DEVICESXML.getName())) { %>
								<input type='hidden' name='old-uploaded-<%= DeviceRepositoryType.DEVICESXML.getName() %>' value='<%= getId(ics, DeviceRepositoryType.DEVICESXML.getName()) + ":" + getFileName(ics, DeviceRepositoryType.DEVICESXML.getName())%>' /> 
								<satellite:blob assembler="query"
								blobtable='DeviceRepository'
								blobkey='id'
								blobwhere='<%=getId(ics, DeviceRepositoryType.DEVICESXML.getName())%>'
								blobcol="urlrepository"
								csblobid='<%=ics.GetSSVar("csblobid")%>'
								blobnocache='true'
								outstring="anchorlink">
								<satellite:parameter name='blobheadername1' value='content-type'/>
								<satellite:parameter name='blobheadervalue1' value='<%=ics.GetVar("encCT") + ";charset=UTF-8"%>'/>
								
								<satellite:parameter name='blobheadername2' value='Content-Disposition'/>
								<satellite:parameter name='blobheadervalue2' value='<%="attachment; filename=" + ics.GetVar("encFileName") + ";filename*=UTF-8\'\'" + ics.GetVar("encFileName")%>'/>
								
								<satellite:parameter name='blobheadername3' value='MDT-Type'/>
								<satellite:parameter name='blobheadervalue3' value='abinary; charset=UTF-8'/>	
							</satellite:blob><a href="<%= ics.GetVar("anchorlink") %>" ><%= getFileName(ics, DeviceRepositoryType.DEVICESXML.getName()) %></a>
							<% } %>
						</td>
					</tr>

					<tr>
						<td colspan="4"><img height="5" width="1" src='<%=ics.GetVar("cs_imagedir")+ "/graphics/common/screen/dotclear.gif"%>' /></td>
					</tr>
					<tr>
						<td class="wurfl-dark-line-color" colspan="4"><img height="2" width="1" src='<%=ics.GetVar("cs_imagedir")+ "/graphics/common/screen/dotclear.gif"%>' /></td>
					</tr>
					<tr>
						<td colspan="4"><img height="10" width="1" src='<%=ics.GetVar("cs_imagedir")+ "/graphics/common/screen/dotclear.gif"%>' /></td>
					</tr>

					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer">
						<ics:argument name="colspan" value="4" />
					</ics:callelement>
					
					<tr>
						<td colspan="4">
						<div class="wurfl-header-text"><xlat:stream key="fatwire/admin/mobility/DeviceRepository/WURFL" /></div>
						</td>
					</tr>

					<tr>
						<td colspan="4"><img height="5" width="1" src='<%=ics.GetVar("cs_imagedir")+ "/graphics/common/screen/dotclear.gif"%>' /></td>
					</tr>
					<tr>
						<td class="wurfl-dashed-color" colspan="4"><img height="2" width="1" src='<%=ics.GetVar("cs_imagedir")+ "/graphics/common/screen/dotclear.gif"%>' /></td>
					</tr>
					<tr>
						<td colspan="4"><img height="10" width="1" src='<%=ics.GetVar("cs_imagedir")+ "/graphics/common/screen/dotclear.gif"%>' /></td>
					</tr>

					<tr>
						<td>
						<div class="wurfl-left-padding"><input type="radio" name="device-repository-type" value="<%= DeviceRepositoryType.WURFLZIP.getName() %>" 
							<% if (DeviceRepositoryType.WURFLZIP.getName().equals(ics.GetVar("device-repository-type"))) { %>
								checked="true"
							<% } %> 
							onclick="makeActive()"/>
						</div>
						</td>
						<td></td>
						<td>
						<div class="wurfl-title-text"><xlat:stream key="fatwire/admin/mobility/DeviceRepository/SingleZipUpload" /></div>
						</td>
						<td></td>
					</tr>

					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer">
						<ics:argument name="colspan" value="4" />
					</ics:callelement>

					<tr>
						<td></td>
						<td></td>
						<td>
						<div class="wurfl-subtitle-text"><xlat:stream key="fatwire/admin/mobility/DeviceRepository/UploadWurflZip" /></div>
						</td>
						<td><ics:callelement element="OpenMarket/Gator/AttributeTypes/CommonDojoxUploader">
							<ics:argument name="inputTagName" value='<%= "upload_" + DeviceRepositoryType.WURFLZIP.getName() %>' />
						</ics:callelement></td>
					</tr>

					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td>
							<% if (null != getId(ics, DeviceRepositoryType.WURFLZIP.getName())) { %>
								<input type='checkbox' name='delete-<%= DeviceRepositoryType.WURFLZIP.getName() %>' value='<%= getId(ics, DeviceRepositoryType.WURFLZIP.getName()) + ":" + getFileName(ics, DeviceRepositoryType.WURFLZIP.getName()) %>' /> <xlat:stream key="dvin/Assetmaker/CheckdeleteUploadFile" />:
								<satellite:blob blobtable="DeviceRepository" blobkey="id" blobwhere='<%= getId(ics, DeviceRepositoryType.WURFLZIP.getName()) %>' blobcol="urlrepository" outstring="anchorlink" />
								<a href="<%= ics.GetVar("anchorlink") %>" ><%= getFileName(ics, DeviceRepositoryType.WURFLZIP.getName()) %></a>
							<% } %>
						</td>
					</tr>
					
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer">
						<ics:argument name="colspan" value="4" />
					</ics:callelement>

					<tr>
						<td colspan="4"><img height="5" width="1" src='<%=ics.GetVar("cs_imagedir")+ "/graphics/common/screen/dotclear.gif"%>' /></td>
					</tr>
					<tr>
						<td class="wurfl-dashed-color" colspan="4"><img height="2" width="1" src='<%=ics.GetVar("cs_imagedir")+ "/graphics/common/screen/dotclear.gif"%>' /></td>
					</tr>
					<tr>
						<td colspan="4"><img height="10" width="1" src='<%=ics.GetVar("cs_imagedir")+ "/graphics/common/screen/dotclear.gif"%>' /></td>
					</tr>

					<tr>
						<td>
						<div class="wurfl-left-padding"><input type="radio" name="device-repository-type" value="<%= DeviceRepositoryType.WURFLROOTXML.getName() %>" 
						<% if (DeviceRepositoryType.WURFLROOTXML.getName().equals(ics.GetVar("device-repository-type"))) { %>
							checked="true"
						<% } %> 
						onclick="makeActive()"/>
						</div>
						</td>
						<td></td>
						<td>
						<div class="wurfl-title-text"><xlat:stream key="fatwire/admin/mobility/DeviceRepository/MultipleFilesUpload" /></div>
						</td>
						<td></td>
					</tr>

					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer">
						<ics:argument name="colspan" value="4" />
					</ics:callelement>

					<tr>
						<td></td>
						<td></td>
						<td>
						<div class="wurfl-subtitle-text"><xlat:stream key="fatwire/admin/mobility/DeviceRepository/UploadMainWurfl" /></div>
						</td>
						<td><ics:callelement element="OpenMarket/Gator/AttributeTypes/CommonDojoxUploader">
							<ics:argument name="inputTagName" value='<%= "upload_" + DeviceRepositoryType.WURFLROOTXML.getName() %>' />
						</ics:callelement></td>
					</tr>

					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td>
							<% if (null != getId(ics, DeviceRepositoryType.WURFLROOTXML.getName())) { %>
								<input type='checkbox' name='delete-<%= DeviceRepositoryType.WURFLROOTXML.getName() %>' value='<%= getId(ics, DeviceRepositoryType.WURFLROOTXML.getName()) + ":" + getFileName(ics, DeviceRepositoryType.WURFLROOTXML.getName()) %>' /> <xlat:stream key="dvin/Assetmaker/CheckdeleteUploadFile" />:
								<satellite:blob blobtable="DeviceRepository" blobkey="id" blobwhere='<%= getId(ics, DeviceRepositoryType.WURFLROOTXML.getName()) %>' blobcol="urlrepository" outstring="anchorlink" />
								<a href="<%= ics.GetVar("anchorlink") %>" ><%= getFileName(ics, DeviceRepositoryType.WURFLROOTXML.getName()) %></a>
							<% } %>
						</td>
					</tr>
					
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer">
						<ics:argument name="colspan" value="4" />
					</ics:callelement>
					
					<%
					
					List<DeviceRepositoryObject> allPatches = dr.getAllPatches();
					if (0 == allPatches.size()) 
					{
						allPatches.add(dr.getEmptyDeviceRepositoryObject());
					}
					
					int i = 1;
					for (DeviceRepositoryObject dro : allPatches) 
					{
					%>
						<tr>
							<td></td>
							<td></td>
							<td>
							<div class="wurfl-subtitle-text"><xlat:stream key="fatwire/admin/mobility/DeviceRepository/UploadPathFile" /></div>
							</td>
							<td><ics:callelement element="OpenMarket/Gator/AttributeTypes/CommonDojoxUploader">
								<ics:argument name="inputTagName" value='<%= "upload_" + DeviceRepositoryType.WURFLPATCHXML.getName() + "_" + i %>' />
							</ics:callelement></td>
						</tr>
						
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td>
								<% if (null != getId(ics, DeviceRepositoryType.WURFLPATCHXML.getName())) { %>
									<input type='checkbox' name='delete-<%= DeviceRepositoryType.WURFLPATCHXML.getName() + "_" + i %>' value='<%= dro.getId()+":"+getFileNameFromPath(dro.getFileName()) %>' /> <xlat:stream key="dvin/Assetmaker/CheckdeleteUploadFile" />:
									<satellite:blob blobtable="DeviceRepository" blobkey="id" blobwhere='<%= dro.getId() %>' blobcol="urlrepository" outstring="anchorlink" />
									<a href="<%= ics.GetVar("anchorlink") %>" ><%= getFileNameFromPath(dro.getFileName()) %></a>
								<% 
									ics.RemoveVar("anchorlink");
								} 
								%>
							</td>
						</tr>
						
						<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer">
							<ics:argument name="colspan" value="4" />
						</ics:callelement>
					<%
					
						i += 1;
					}
					%>

					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer">
						<ics:argument name="colspan" value="4" />
					</ics:callelement>
				</table>
				</td>
			</tr>
		</table>
		<input type="hidden" name="pagename" value="OpenMarket/Xcelerate/Actions/<%= ics.GetVar("PostPage") %>" />
		<input type="hidden" name="old-device-repository-type" value='<%= ics.GetVar("device-repository-type") %>' />
		<ics:removevar name="defaultFormStyle"/>
	</satellite:form>
</cs:ftcs>