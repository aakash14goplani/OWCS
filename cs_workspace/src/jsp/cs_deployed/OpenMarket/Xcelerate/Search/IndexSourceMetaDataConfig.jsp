<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors, com.fatwire.cs.core.search.source.IndexSourceConfig, java.util.*, com.fatwire.cs.core.search.source.IndexSourceMetadata, com.fatwire.cs.core.search.data.FieldDescriptor, com.fatwire.assetapi.def.*, com.fatwire.search.source.*, com.fatwire.assetapi.util.AssetUtil, com.openmarket.assetframework.interfaces.*,java.util.TreeMap"
%><cs:ftcs>
<string:encode variable="cs_imagedir" varname="cs_imagedir"/>
<%//
// OpenMarket/Xcelerate/Search/IndexSourceMetadataConfig
//%>

<%
    boolean user = ics.UserIsMember( "SiteGod,xceladmin" );
	if ( !user )
    {
%>
        <script LANGUAGE="JavaScript">
            parent.parent.location='<%=ics.GetVar("urltimeouterror")%>';
        </script>
<%
        ics.ThrowException();
    }
%>
    <script type="text/javascript">
        function selectActionOnChange( select )
        {
            document.forms[0].action.value = 'refresh'; 
            document.forms[0].submit();
        }
        function checkAction(action)
        {
            document.forms[0].action.value = action;
			if(verifyAttributes()){
				document.forms[0].submit();
			} else{
				alert('<xlat:stream key="dvin/UI/Search/atleastOneAttributeBeSelected" encode="false" escape="true"/>');
			}
		}
		function selectAllAttributes()
        {
            var form = document.forms[0];
            var fields = form['fields'].value;
			var fieldsArr = fields.split(',');
			for ( var i =0; i < fieldsArr.length; i ++ )
            {
                if(form[fieldsArr[i] + '_ChBx'])
					form[fieldsArr[i] + '_ChBx'].checked = true;
            }
        }
		function verifyAttributes()
        {
            var form = document.forms[0];
            var fields = form['fields'].value;
			var fieldsArr = fields.split(',');
			for ( var i =0; i < fieldsArr.length; i ++ )
            {
                if(form[fieldsArr[i] + '_ChBx'] && form[fieldsArr[i] + '_ChBx'].checked)
				{
					return true;
				}
            }
			return false;
        }
        </script>
		<%
            String[] blockedAttrs = {"Dimension-parent","Dimension","externaldoctype","filename","fw_uid","id","status","template","urlexternaldoc","urlexternaldocxml","subtype","renderid"};
			List blockedAttrsList = Arrays.asList(blockedAttrs);
			Map<String, String> selected = new HashMap<String, String>();
            String temp = ics.GetVar("selectAction");
            String imgdir = ics.GetProperty( "xcelerate.imageurl", "futuretense_xcel.ini", true);            
            //Set the image dir
			ics.SetVar("cs_imagedir",imgdir);
			selected.put( temp, "Selected" );
            StringBuilder stringBuilder = new StringBuilder();
			Map<String,FieldDescriptor> sortedMap = new TreeMap<String,FieldDescriptor>();
		%>
		<%
			AssetIndexSourceConfigImpl indexConfig = new AssetIndexSourceConfigImpl( ics );
			List<String> names = indexConfig.getIndexSources();
			//Sort the names in the dropdown
			Collections.sort(names);
			if ( null == temp || temp.length() == 0 )
			{
				temp = names.get( 0 );
			}
			AssetIndexSourceMetadata metadata = (AssetIndexSourceMetadata) indexConfig.getConfiguration( temp );
			if ( "save".equals(ics.GetVar("action")))
			{
				//Reset the error number
				ics.SetVar("errno","0");
				String fields = ics.GetVar("fields");                         
				StringTokenizer st = new StringTokenizer(fields, ",");
				StringBuilder sb = new StringBuilder();
				while ( st.hasMoreTokens() )
				{
					String fieldname = st.nextToken();
					if ( "true".equals( ics.GetVar( fieldname + "_ChBx" )))
					{
						sb.append( fieldname ).append( "," ).append( ics.GetVar( fieldname+"Type" )).append( "," );
						sb.append( ics.GetVar( fieldname+"Tokenized" )).append( "," );
						sb.append( ics.GetVar( fieldname+"Stored" )).append( "," );
						sb.append( ics.GetVar( fieldname+"Boost" )).append( ";" );
					}
				}
				if(sb.toString().length() == 0){
					indexConfig.removeByName(temp);
				} else {
					metadata.setFieldDescriptorString( sb.toString() );
					indexConfig.saveConfigs( Arrays.<AssetIndexSourceMetadata>asList( metadata ));
				}
				if("0".equals(ics.GetVar("errno"))){
				%>
					<xlat:lookup key="dvin/UI/Updatesuccessful" encode="false" varname="msg"/>
					<div class="width-outer-70">
					<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
						<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
						<ics:argument name="severity" value="info"/>
					</ics:callelement>
					</div><P/>
				<%
				} else {
				%>
					<ics:callelement element="OpenMarket/Xcelerate/Actions/Util/ShowError">
						<ics:argument name="error" value="UpdateFailed"/>
					</ics:callelement>
				<%
				}
			}
		%>
 	<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
		<tr><td>
			<span class="title-text"><xlat:stream key="dvin/TreeApplet/ConfigureIndexSourceMetaData" encode='false'/></span>
		</td></tr>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
	</table>	


		<table cellpadding="0" cellspacing="0" class="width-outer-70">
			<tr>
				<td colspan="3"><xlat:lookup  key="dvin/UI/Search/IndexSourceMetaDataConfigDesc" varname="_XLAT_" encode="false"/>
					<%=ics.GetVar("_XLAT_")%></td>
			</tr>
			<tr>
				<td >
				<!--start main content td -->
				<!--start main content top nested table -->
				<div style="margin: 20px 20px 20px 0">
				<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td><b><xlat:stream key="dvin/UI/Admin/Index"/>:</b></td>
					<td>&nbsp;&nbsp;&nbsp;</td>
					<td><select name='selectAction' onchange='selectActionOnChange(this)'>
                    <%
                    for ( String name : names )
                    {
                    %>
                        <option value='<%=name%>' <%=selected.get( name )%>><%=name%></option>
                    <%
                    }
                    %>
                    </select>
                     </td>
                     <td>&nbsp;&nbsp;&nbsp;</td>
					<%if(!"Global".equals(temp)){%>
                     <td>
                    	<A HREF="javascript:checkAction('save')"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Save"/></ics:callelement></A>
                    	<A HREF="javascript:selectAllAttributes()"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/SelectAll"/></ics:callelement></A>
					</td>
					<%}%>
					<td>&nbsp;</td>
                </tr>
				</table>
				</div>
				</td>
			</tr>
			<tr>
				<td >	
				<!--end main content top nested table -->
				<!--Start main content main nested table -->
				<div  id='tableBodyDiv' align="left" style="margin-right:10px;margin-top:10px;margin-bottom:10px;">
            	<table class="width-outer-50" style="margin-left:0" cellspacing="0" cellpadding="0" border="0">
				<tr><td></td><td class="tile-dark" height="1"><img width="1" height="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'></td><td></td></tr>
				<tr><td class="tile-dark" width="1" valign="top"><br></td><td>
				<table width="100%" cellpadding="0" cellspacing="0" id='AssetTypesTable'>
                <tr>
                    <td height="27px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;</td>
					<xlat:lookup  key="dvin/UI/Common/Enabled" varname="_XLAT_" encode="false"/>
                    <td class='tile-b' height="27px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><%=ics.GetVar("_XLAT_")%></td>
					<td height="27px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'></td>
                    <xlat:lookup  key="dvin/AT/Flex/Attribute" varname="_XLAT_" encode="false"/>
                    <td class='tile-b' height="27px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><%=ics.GetVar("_XLAT_")%></td>
					<td height="27px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'></td>
                    <xlat:lookup  key="dvin/UI/Common/Type" varname="_XLAT_" encode="false"/>
                    <td class='tile-b' height="27px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><%=ics.GetVar("_XLAT_")%></td>
					<td></td>
					<xlat:lookup  key="dvin/UI/Search/Tokenized" varname="_XLAT_" encode="false"/>
                    <td class='tile-b' height="27px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><%=ics.GetVar("_XLAT_")%></td>
					<td height="27px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'></td>
					<xlat:lookup  key="dvin/UI/Search/Stored" varname="_XLAT_" encode="false"/>
					<td class='tile-b' height="27px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><%=ics.GetVar("_XLAT_")%></td>
					<td height="27px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'></td>
					<xlat:lookup  key="dvin/UI/Search/Boost" varname="_XLAT_" encode="false"/>
                    <%--Set the display for the boost to none so that it is not configurable PR#21447 --%>
					<td style="display:none" class='tile-b' height="27px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><%=ics.GetVar("_XLAT_")%></td>
					<td height="27px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;</td>
                </tr>
                <tr>
					<td colspan="7" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				</tr>
				<tr>
					<td colspan="7" class="tile-rule"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				</tr>
                	<%
					if ( temp.equals( "Global" ) || (metadata.getFieldNames() != null && metadata.getFieldNames().size() > 0))
                    {
                        Set<String> fieldnames = metadata.getFieldNames();
						for ( String fieldname : fieldnames )
                        {
                            FieldDescriptor desc = metadata.getFieldDescriptor( fieldname );
                            //This value is always available in the database so store it as true.
							String fieldInfo = fieldname + ";true";
							sortedMap.put(fieldInfo,desc);
						}
						if ( !temp.equals( "Global" )){
							ics.SetObj("tempSortedMap",sortedMap);
						%>
							<ics:callelement element="OpenMarket/Xcelerate/Search/IndexSourceMetaDataConfigHelper">
								<ics:argument name="containsChk" value="true"/>
								<ics:argument name="tempAssetType" value="<%=temp%>"/>
							</ics:callelement>
						<%
							if(ics.GetObj("tempStringbdr") != null)
								stringBuilder.append((ics.GetObj("tempStringbdr")));
						}
					}
                    else
                    {
						ics.SetObj("tempSortedMap",sortedMap);
					%>
						<ics:callelement element='OpenMarket/Xcelerate/Search/IndexSourceMetaDataConfigHelper'>
							<ics:argument name="tempAssetType" value="<%=temp%>"/>
							<ics:argument name="checked" value="true"/>
						</ics:callelement>
					<%
						if(ics.GetObj("tempStringbdr") != null)
							stringBuilder.append((ics.GetObj("tempStringbdr")));
					}
					for ( String fieldInfo : sortedMap.keySet() )
                    {
						String[] fieldInfoAr = fieldInfo.split(";");
						String fieldname = fieldInfoAr[0];
						if(!blockedAttrsList.contains(fieldname))
						{
							boolean enabled = Boolean.valueOf(fieldInfoAr[1]);
							String checked=(enabled==true)?"checked":"";
							FieldDescriptor desc = (FieldDescriptor)sortedMap.get(fieldInfo);
							String tokenized = "";
							if ( !desc.isTokenized() )
							{
								tokenized = "Selected";
							}
							String stored = "";
							if ( !desc.isStoredInIndex() )
							{
								stored = "Selected";
							}
							stringBuilder.append( fieldname ).append( "," );
							%>
							 <tr>
							 <td></td>
								<td>
									<input type="CHECKBOX" value="true" name='<%=fieldname+"_ChBx"%>' <%if(temp.equals( "Global" )){%>onclick="return false;"<%}%> <%=checked%>/>
								</td>
							<td></td>
								<td>
									<%=fieldname%>
								</td>
								<td></td>
								<td>
									<input type="hidden" name='<%=fieldname+"Type"%>' value='<%=desc.getType()%>'/> <%=desc.getType()%>
								</td>
								<%if(!"Global".equals(temp)){%>
								<td></td>
								<td>
									<select name='<%=fieldname+"Tokenized"%>'>
										<option value="true"><xlat:stream key='dvin/AT/Common/true' encode='false'/></option>
										<option value="false" <%=tokenized%>><xlat:stream key='dvin/AT/Common/false' encode='false'/></option>
									</select>
								</td>
								<td></td>
								<td>
									<select name='<%=fieldname+"Stored"%>'>
										<option value="true"><xlat:stream key='dvin/AT/Common/true' encode='false'/></option>
										<option value="false" <%=stored%>><xlat:stream key='dvin/AT/Common/false' encode='false'/></option>
									</select>
								</td>
								<td style="display:none">
									<input name='<%=fieldname+"Boost"%>' type="TEXT" value='<%=desc.getBoost()%>' size="4"/>
								</td>
								<%} else {%>
								<td></td>
								<td>
									<%=!"Selected".equals(tokenized)%>
								</td>
								<td></td>
								<td>
									<%=!"Selected".equals(stored)%>
								</td>
								<td style="display:none">
									<%=desc.getBoost()%>
								</td>
								<%}%>
								<td></td> 
							</tr>
						<%
						}
					}
					%>
				</table>
				</td><td class="tile-dark" width="1" valign="top"><br></td></tr>
				<tr>
					<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				</tr>
				</table>
				</div>
				</td>
				</tr>
		</table>
		<input type='hidden' name='action' value=''/>
		<input type="hidden" name="fields" value='<%=stringBuilder.toString()%>'/>
		<input type="hidden" name="pagename" value='OpenMarket/Xcelerate/Search/IndexSourceMetaDataConfig'/>
</cs:ftcs>