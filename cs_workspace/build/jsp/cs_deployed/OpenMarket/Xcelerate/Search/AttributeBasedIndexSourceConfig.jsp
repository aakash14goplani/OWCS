<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// OpenMarket/Xcelerate/Search/AttributeBasedIndexSourceConfig
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
<%@ page import="com.openmarket.assetframework.interfaces.AssetTypeManagerFactory" %>
<%@ page import="com.openmarket.assetframework.interfaces.IAssetTypeManager" %>
<%@ page import="com.fatwire.search.util.AssetQueueIndexSourceUtil" %>
<%@ page import="com.fatwire.search.source.AssetIndexSourceConfigImpl" %>
<%@ page import="com.fatwire.search.source.AssetIndexSourceMetadata" %>
<%@ page import="com.fatwire.cs.core.search.source.IndexSource" %>
<%@ page import="com.fatwire.search.source.IndexSourceProperties" %>
<%@ page import="java.util.*" %>
<%@ page import="com.fatwire.search.util.AssetIndexSourceConfigHandler" %>
<%@ page import="com.fatwire.search.source.IndexSourceMetaDataImpl" %>
<cs:ftcs>
<string:encode variable="cs_imagedir" varname="cs_imagedir"/>
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/Security/TimeoutError" outstring="urltimeouterror">
</satellite:link>
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
<ics:callelement element='OpenMarket/Xcelerate/Search/SortableTable'/>
<script type="text/javascript">
        matchHeight=function()
        {
            var divs,contDivs,maxHeight,divHeight,d;
            div=document.getElementById('tableBodyDiv');
            if ( div.offsetHeight > 480 )
            {
               // div.style.height = 480;
            }
        }

        window.onload=function()
        {
            if(document.getElementById('tableBodyDiv'))
            {
                matchHeight();
            }
        }

        function selectActionOnChange( select )
        {
            document.forms[0].OnOk.value = false;
            document.forms[0].submit();
        }

        function selectAllAssetTypes( fields )
        {
            var value = document.forms[0].SelecteAllAssetTypes.checked;
            if ( fields )
            {
                if ( fields.length == undefined )
                {
                    fields.checked  = value;
                }
                else
                {
                    for ( var i =0; i < fields.length; i ++ )
                    {
                        fields[i].checked = value;
                    }
                }
            }
        }

        function checkAction( confirmEnableOkAction, enable )
        {
            document.forms[0].OnOk.value = true;
            var action = document.forms[0].elements["selectAction"].value;
			
            if ( action == '<%=AssetIndexSourceConfigHandler.ENABLE%>') 
				{
				 
			        confirmStr = '<xlat:stream key="dvin/UI/Search/confirmAddAction"  encode="false" escape="true"/>';
				}
				else if ( action == '<%=AssetIndexSourceConfigHandler.PAUSE%>') 
				{
					
					confirmStr = '<xlat:stream key="dvin/UI/Search/confirmPauseAction"   encode="false" escape="true"/>';
				}
				else if (  action == '<%=AssetIndexSourceConfigHandler.DELETE%>') 
				{
					
					confirmStr = '<xlat:stream key="dvin/UI/Search/confirmDeleteAction"  encode="false" escape="true"/>';
				}
				else if (  action == '<%=AssetIndexSourceConfigHandler.REINDEX%>') 
				{
				
				confirmStr = '<xlat:stream key="dvin/UI/Search/confirmReIndexAction" encode="false" escape="true"/>';
				}		 			
			

			
			if ( action == "")
            {
				alert('<xlat:stream key="dvin/UI/Search/PleaseSelectAction" encode="false" escape="true"/>');
            }
            else
            {
                var submit = false;
                var fields = document.forms[0].elements.SelectedAssetTypes;
                for ( var i = 0; fields && i < fields.length; i ++ )
                {
                    if ( fields[i].checked == true )
                    {
                        submit = true;
                        break;
                    }
                }
                if ( fields && fields.length == undefined )
                {
                    if ( fields.checked == true )
                    {
                        submit = true;
                    }
                }
                if ( submit == false )
                {
                	alert('<xlat:stream key="dvin/UI/Search/PleaseSelectAssetType" encode="false" escape="true"/>');
                }
                else
                {
                    if ( enable == action )
                    {
                        var answer = confirm( confirmEnableOkAction);
                        if ( answer )
                        {
                          
							document.forms[0].submit();
                        }
						
						else cancelSelected() ;
                        
                    }
                    else
                    {
                        var answer = confirm( confirmStr );
                        if ( answer )
                        {
                            document.forms[0].submit();
                        }
                    }
                }
            }
        }
		
		function cancelSelected(){
			var selectedfields = document.forms[0].SelectedAssetTypes;
			if ( selectedfields )
            { document.forms[0].SelecteAllAssetTypes.checked = false ;
                if ( selectedfields.length == undefined )
                {
                    selectedfields.checked  = false;
                }
                else
                {
                    for ( var i =0; i < selectedfields.length; i ++ )
                    {
                        selectedfields[i].checked = false;
                    }
                }
            }
			return false;
		}
		
    </script>
    <%
        String temp1 = ics.GetVar( "SelectedAssetTypes");
        StringBuilder sb = new StringBuilder();
        if ( null != temp1 && temp1.length() > 0 )
        {
            StringTokenizer st = new StringTokenizer( temp1, ";");
            boolean firstToken=true;
            while ( st.hasMoreTokens() )
            {
                String temp2 = st.nextToken();
               	if(firstToken){
                    sb.append(temp2);
                    firstToken=false;
                }else{
                	sb.append(", ").append( temp2  );
                }
            }
            ics.SetVar( "parsedAssetTypes", sb.toString());
        }
    %>
    <xlat:lookup key="dvin/UI/Search/confirmEnableOkAction" varname='confirmEnableOkAction' encode="false" escape="true"/>
    <input type="hidden" name="pagename" value='OpenMarket/Xcelerate/Search/AttributeBasedIndexSourceConfig'/>
	<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
		<tr><td>
			<span class="title-text"><xlat:stream key="dvin/TreeApplet/ConfigureAssetTypeSearch" encode='false'/></span>
		</td></tr>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
	</table>	
	
	<xlat:lookup  key="dvin/UI/Search/Enable" varname="_ENABLE_XLAT_" encode="false"/>
	<xlat:lookup  key="dvin/UI/Search/Pause" varname="_PAUSE_XLAT_" encode="false"/>
	<xlat:lookup  key="dvin/UI/Search/Delete" varname="_DELETE_XLAT_" encode="false"/>
	<xlat:lookup  key="dvin/UI/Search/Reindex" varname="_REINDEX_XLAT_" encode="false"/>
	 <%
		String temp = ics.GetVar("selectAction");
		 if( null != temp && "true".equals( ics.GetVar( "OnOk" ) ) )
		 {
			//setting up translated text - selectAction variable expecting translated text inside SLS
			if(AssetIndexSourceConfigHandler.ENABLE.equals(temp))
				ics.SetVar("selectAction",ics.GetVar("_ENABLE_XLAT_"));  
			if(AssetIndexSourceConfigHandler.PAUSE.equals(temp))
				ics.SetVar("selectAction",ics.GetVar("_PAUSE_XLAT_"));
			if(AssetIndexSourceConfigHandler.DELETE.equals(temp))
				ics.SetVar("selectAction",ics.GetVar("_DELETE_XLAT_"));
			if(AssetIndexSourceConfigHandler.REINDEX.equals(temp))
				ics.SetVar("selectAction",ics.GetVar("_REINDEX_XLAT_"));
	%>
	<string:encode variable="selectAction" varname="selectAction"/>
	<xlat:lookup key="dvin/UI/Search/assettypesactioninfo" varname='assettypesactioninfo' encode="false" escape="true"/>
	<div class="width-outer-70">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
				<ics:argument name="msgtext" value='<%=ics.GetVar("assettypesactioninfo")%>'/>
				<ics:argument name="severity" value="info"/>
			</ics:callelement>	
	</div>	
	<%	//putting back the action value
		ics.SetVar("selectAction",temp);
		}
	%>	
	
	<table cellpadding="0" cellspacing="0" class="width-outer-70">

		<tr>
			<td colspan='3'>
				<xlat:lookup  key="dvin/UI/Search/AssetTypeIndexConfigDesc" varname="_XLAT_" encode="false"/>
				<%=ics.GetVar("_XLAT_")%>
			</td>
		</tr>

        <tr>
			<td nowrap="nowrap">
			<span><xlat:stream key='dvin/UI/Search/Step1' encode='false'/>:</span> <xlat:stream key='dvin/UI/Search/Selectanaction' encode='false'/> > <span><xlat:stream key='dvin/UI/Search/Step2' encode='false'/>:</span> <xlat:stream key='dvin/UI/Search/SelectAssetTypesfromtablerows' encode='false'/> > <span><xlat:stream key='dvin/UI/Search/Step3' encode='false'/>:</span> <xlat:stream key='dvin/UI/Search/Clickok' encode='false'/>
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<div style="padding:15px 15px 15px 0">
				<!--start main content td -->
				<!--start main content top nested table -->
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td style="padding:15px 0" colspan="2">
							<table><tr><td>
							<b><xlat:stream key="dvin/UI/Search/Forindex"/>:</b>&nbsp;
               			    <%
                              List<String> assetAssetTypes = AssetQueueIndexSourceUtil.getAllAssetTypeNamesForGlobal_Q( ics );
               			      Map<String, String> selected = new HashMap<String, String>();

               			       //List<AssetIndexSourceMetadata.AssetTypeIndexStatusEnum> reindexingList = pauseList;

               			       String action = ics.GetVar( "selectAction" );
               			       //String disable = "Disabled";
               			       String disable = "";
                               if ( null == action || action.length() == 0)
                               {
                                    disable = "Disabled";
                               }
                               selected.put( AssetIndexSourceConfigHandler.ENABLE, "");
               			       selected.put( AssetIndexSourceConfigHandler.PAUSE, "");
               			       selected.put( AssetIndexSourceConfigHandler.DELETE, "");
               			       selected.put( AssetIndexSourceConfigHandler.REINDEX, "");
               			       if( null != action )
               			       {
                                   selected.put( action, "Selected");
                                   if( "Enable".equals( action ) )
               			           {
               			               assetAssetTypes = AssetQueueIndexSourceUtil.getToEnabledAttributeBasedIndex( ics );
               			           }
               			           else if( "Delete".equals( action ) )
               			           {
                                       assetAssetTypes = AssetQueueIndexSourceUtil.getToDeleteOrDisableAttributeBasedIndex( ics );
               			           }
               			           else
               			           {
               			               assetAssetTypes = AssetQueueIndexSourceUtil.getToPausedAttributeBasedIndex( ics );
               			           }
               			           disable = "";
               			       }
               			   %>
                            <input type='hidden' name='OnOk' value=''/>
                            <input type='hidden' name='reindex' value=''/>
                                <%
   								 String a = ics.GetVar( "assettype" );

   								 String e = ics.GetVar( "enableFullText" );
                                 AssetIndexSourceConfigHandler handler = new AssetIndexSourceConfigHandler( ics );
   								 if( null != e )
   								 {
                                    handler.enableBinaryIndex( ics.GetVar( "SelectedAssetTypes" ), e );   
                                        //metadata.setProperty( IndexSourceProperties.Names.FULLTEXTINDEX, e );
   								     //aConfig.saveConfigs( Arrays.asList( metadata ) );
   								 }
                                 AssetIndexSourceConfigImpl aConfig = new AssetIndexSourceConfigImpl( ics );
   								 boolean fullTextIndex = handler.binaryIndexEnabled();
                                 if( null != action && "true".equals( ics.GetVar( "OnOk" ) ) )
   								 {

   								     handler.manageAssetTypeIndex( ics.GetVar( "SelectedAssetTypes" ), action );
                                     selected.put( action, "");
                                     assetAssetTypes = AssetQueueIndexSourceUtil.getAllAssetTypeNamesForGlobal_Q( ics );   
                                     disable = "Disabled";
                                }
							%>
                			<select name='selectAction' onchange='selectActionOnChange(this)'>
                			    <xlat:lookup  key="dvin/UI/Search/toSelectActionDesc" varname="_XLAT_" encode="false"/>
                			    <option value =""><%=ics.GetVar("_XLAT_")%></option>
                			    <xlat:lookup  key="dvin/UI/Search/Enable" varname="_XLAT_" encode="false"/>
                			    <option value ='<%=AssetIndexSourceConfigHandler.ENABLE%>' <%=selected.get( AssetIndexSourceConfigHandler.ENABLE)%>><%=ics.GetVar("_XLAT_")%></option>
                			    <xlat:lookup  key="dvin/UI/Search/Pause" varname="_XLAT_" encode="false"/>
                			    <option value ='<%=AssetIndexSourceConfigHandler.PAUSE%>' <%=selected.get( AssetIndexSourceConfigHandler.PAUSE)%>><%=ics.GetVar("_XLAT_")%></option>
                			    <xlat:lookup  key="dvin/UI/Search/Delete" varname="_XLAT_" encode="false"/>
                			    <option value ='<%=AssetIndexSourceConfigHandler.DELETE%>' <%=selected.get( AssetIndexSourceConfigHandler.DELETE)%>><%=ics.GetVar("_XLAT_")%></option>
                			    <xlat:lookup  key="dvin/UI/Search/Reindex" varname="_XLAT_" encode="false"/>
                			    <option value ='<%=AssetIndexSourceConfigHandler.REINDEX%>' <%=selected.get( AssetIndexSourceConfigHandler.REINDEX)%>><%=ics.GetVar("_XLAT_")%></option>
                			</select>
							</td><td><A HREF="javascript:checkAction( '<%=ics.GetVar("confirmEnableOkAction")%>', '<%=AssetIndexSourceConfigHandler.ENABLE%>' )"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Ok"/></ics:callelement></A>
							</td></tr></table>
						</td>
						<td rowspan="2">
							<!--start binary indexing nested table -->
							<table cellpadding="0" cellspacing="0" width="250">
								<tr>
									<td style="border-color:#c2c0c1;border-style:solid;border-width:1px;background-color:#ECECEC">
										<table cellpadding="0" cellspacing="10">

											<tr>
												<td align="center">


													 <%
             									       if ( fullTextIndex )
             									       {
             									  %>
             									   <satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Search/AttributeBasedIndexSourceConfig" outstring="EnableURL">
             									       <satellite:argument name="enableFullText" value="false"/>
             									   </satellite:link>
             									   <xlat:lookup  key="dvin/TreeApplet/Disable" varname="_XLAT_" encode="false"/>
             									   <%
             									       String _XLAT_ = ics.GetVar(  "_XLAT_" );
             									   %>
             									   <a href='<%=ics.GetVar("EnableURL")%>' onmouseover='window.status="<%=_XLAT_%>";return true;' onmouseout='windowstatus=""; return true;'>
													   <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/EndBinaryIndexing"/></ics:callelement>
             									   </a>

             									  <%
             									       }
             									       else
             									       {
             									 %>
             									   <satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Search/AttributeBasedIndexSourceConfig" outstring="EnableURL">
             									       <satellite:argument name="enableFullText" value="true"/>
             									   </satellite:link>
             									   <xlat:lookup  key="dvin/TreeApplet/Enable" varname="_XLAT_" encode="false"/>
             									   <%
             									       String _XLAT_ = ics.GetVar(  "_XLAT_" );
             									   %>
             									   <a href='<%=ics.GetVar("EnableURL")%>' onmouseover='window.status="<%=_XLAT_%>";return true;' onmouseout='windowstatus=""; return true;'>
													   <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/StartBinaryIndexing"/></ics:callelement>
             									   </a>

             									  <%
             									       }
             									   %>


												</td>
											</tr>
											<tr>
												<td>
													<xlat:stream key='dvin/UI/Common/StartorStopbinary' encode='false'/>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
							<!--end binary indexing nested table -->
						</td>

                    </tr>
					<tr>
						<td style="padding-top:25px">
							<b><xlat:stream key='dvin/UI/CSAdminForms/Add' encode='false'/>:</b> <xlat:stream key='dvin/UI/Search/addassettypestoindex' encode='false'/><br>
							<b><xlat:stream key='dvin/UI/Search/Pause' encode='false'/>:</b> <xlat:stream key='dvin/UI/Search/pauseindexingonassettypes' encode='false'/><br>
							<b><xlat:stream key='dvin/UI/Search/Delete' encode='false'/>:</b> <xlat:stream key='dvin/UI/Search/deleteassettypesfromindex' encode='false'/><br>
							<b><xlat:stream key='dvin/UI/Search/Reindex' encode='false'/>:</b> <xlat:stream key='dvin/UI/Search/re-indexassettypes' encode='false'/><br>
						</td>
					</tr>
				</table>
				</div>
				<!--end main content top nested table -->
				<!--Start main content main nested table -->
				<div  id='tableBodyDiv' align="left" style="margin-top: 20px;margin-right: 20px;margin-bottom: 20px;">
            	<table class="width-outer-70" style="margin-left:0" cellspacing="0" cellpadding="0" border="0">
				<tr><td></td><td class="tile-dark" height="1"><img width="1" height="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'></td><td></td></tr>
				<tr><td class="tile-dark" width="1" valign="top"><br></td><td>
				<table cellpadding="0" cellspacing="0" width="100%" id='AssetTypesTable'>
				<thead>
				<tr><td class="tile-highlight" colspan="7"><img width="1" height="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'></td></tr>
                <tr>
					<td class="tile-a" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;</td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><input type='CHECKBOX' name='SelecteAllAssetTypes' onclick='selectAllAssetTypes( this.form.SelectedAssetTypes )' <%=disable%>/></td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;</td>
                    <xlat:lookup  key="dvin/UI/Common/AssetTypes" varname="_XLAT_" encode="false"/>
					<td class="tile-b sortable" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><%=ics.GetVar("_XLAT_")%></td>
					<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;</td>
                    <xlat:lookup  key="dvin/UI/Search/status" varname="_XLAT_" encode="false"/>
					<td class="tile-b sortable" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'> <%=ics.GetVar("_XLAT_")%></td>
					<td class="tile-c" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;</td>
				</tr>
				<tr>
					<td colspan="7" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				</tr>
				<tr>
					<td colspan="7" class="tile-rule"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				</tr>
				</thead>
					<%
					    for( String assettype : assetAssetTypes )
					    {
                            AssetIndexSourceMetadata metadata = aConfig.getConfiguration( assettype, assettype, null );
                            AssetIndexSourceMetadata.AssetTypeIndexStatusEnum status = AssetIndexSourceMetadata.AssetTypeIndexStatusEnum.DISABLED;
                            if ( null != metadata )
                            {
                                status = metadata.getAssetTypeIndexStatus( assettype, null );
                            }

                            // if ( !AssetIndexSourceMetadata.AssetTypeIndexStatusEnum.NOTSUPPORTED.equals( status ) )
					%>
                            <tr>
					                <td></td>
                                <td><input type='CHECKBOX' name='SelectedAssetTypes' value='<string:stream value='<%=assettype%>'/>' <%=disable%>/></td>
					                <td></td>
                                <td><string:stream value='<%=assettype%>'/></td>
					                <td></td>
                                <td>
                                    <%
                                        if (status.toString().equals("Disabled"))
                                        {
                                    %>
                                            <xlat:stream key="dvin/UI/Admin/IndexDisabled" encode="false"/>
                                    <%
                                        }
                                        else if(status.toString().equals("Enabled"))
                                        {
                                    %>
                                           <xlat:stream key="dvin/UI/Admin/IndexEnabled" encode="false"/>
                                    <%
                                        }
                                        else if (status.toString().equals("Paused"))
                                        {
                                    %>
                                           <xlat:stream key="dvin/UI/Admin/IndexPaused" encode="false"/>
                                    <%
                                        }
                                        else
                                        {
                                    %>
                                        <%=status.toString()%>
                                    <%
                                        }
                                    %>
                                </td>
									<td></td>
                            </tr>
					<%
					        }
					    
					%>

            	</table>
				</td><td class="tile-dark" width="1" valign="top"><br></td></tr>
				<tr>
					<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif' /></td>
				</tr>
				</table>
           		 <script type="text/javascript">
           		     makeSortable('AssetTypesTable');
           		 </script>
            	</div>
				<!--end main content main nested table -->
				<!--end main content td -->
			</td>
		</tr>
	
</table>
</cs:ftcs>
