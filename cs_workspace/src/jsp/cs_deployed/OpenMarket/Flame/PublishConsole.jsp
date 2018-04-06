<%@ page import="COM.FutureTense.Interfaces.IList,
                 COM.FutureTense.Interfaces.FTValList,
                 com.fatwire.flame.variation.Normalizer,
                 com.fatwire.flame.variation.NormalizerFactory"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>
<%@ taglib prefix="locale" uri="futuretense_cs/locale1.tld" %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet"%>
<%//
// OpenMarket/Flame/PublishConsole
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
<portlet:defineObjects/>
<%
Normalizer normFormField = NormalizerFactory.getNormalizer(NormalizerFactory.FORM_FIELD,
	renderRequest, renderResponse, portletConfig);
ics.CallElement("OpenMarket/Xcelerate/UIFramework/BasicEnvironment", null);
String cs_imageDir = ics.GetVar("cs_imagedir");
%>

<script>
function <portlet:namespace/>_csPubTargetPopup(url, target)
{
	var form = document.forms["<portlet:namespace/>_PublishConsole"];
	var selectedTarget = form.elements['<%=normFormField.normalize("target")%>'].selectedIndex;
	url = url + "&target="+form.elements['<%=normFormField.normalize("target")%>'][selectedTarget].value;
	var win = window.open(url, target, "directories=no,scrollbars=yes,resizable=yes,location=no,menubar=no,toolbar=no,top=20,width=650,height=680,left=300");
	win.focus();
}
</script>

<ics:callelement element='OpenMarket/Xcelerate/UIFramework/Util/SetStylesheet'/>
<ics:if condition='<%=!ics.UserIsMember("xcelpublish")%>'>
<ics:then>
    <ics:callelement element="OpenMarket/Xcelerate/Actions/Util/ShowError">
        <ics:argument name="error" value="PortletRequiresAdminPrivs"/>                
    </ics:callelement>
</ics:then>
<ics:else>
    <% FTValList args = new FTValList(); %>
    <ics:callelement element='OpenMarket/Flame/Common/Script/Popup'/>
    <locale:create varname='LocaleName' localename='<%=ics.GetSSVar("locale")%>'/>
    <dateformat:create name="_FormatDate_" timestyle="FULL" locale="LocaleName"/>
  
    <satellite:link assembler="query" portleturltype="action" outstring="actionURL"/>
    <satellite:link assembler="query" outstring="viewURL"/>
  
    <satellite:form name="<portlet:namespace/>_PublishConsole" method="post" action="<%=ics.GetVar("actionURL")%>">
	<property:get param="xcelerate.charset" inifile="futuretense_xcel.ini" varname="propcharset"/>
	<INPUT TYPE="HIDDEN" NAME="_charset_" VALUE="<%=ics.GetVar("propcharset")%>"/>
	<table border="0" cellpadding="0" cellspacing="0" WIDTH="80%">
        <tr>
            <td><span class="title-value-text"><xlat:stream key="dvin/UI/SelectPublishDestination"/></span></td>
        </tr>
        <tr>
           <td><img height="10" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
        </tr>
        <tr>
            <td>
				<ics:setvar name="doproceed" value="true" />
				<ics:setvar name="dest" value="none"/>
				<property:get param="xcelelem.publishoptions" inifile="futuretense_xcel.ini" varname="proppublishoptions"/>

				<ics:if condition='<%=ics.GetVar("proppublishoptions").length()!=0%>'>
				<ics:then>
					<!-- use customized element -->
					<!--callelement NAME="Variables.proppublishoptions"/-->
					<!-- call console from a popup since the custom element probably won't work in a portlet -->
				</ics:then>
				<ics:else>
				<TABLE>
				<TR>
					<!--TD ALIGN="LEFT" VALIGN="TOP"-->
					<TD class="form-label-text">
						<xlat:stream key="dvin/UI/Publishdestination"/>
					</TD>
				</TR>
				<TR>
					<TD>
					<ics:setvar name="errno" value="0"/>
					<%
					args.setValString("PREFIX", "pbt");
					args.setValString("PUBID", ics.GetSSVar("pubid"));
					ics.runTag("pubtargetmanager.find", args);
					args.removeAll();
					%>
              	    <ics:if condition='<%=ics.GetVar("pbtTotal").equals("0")%>'>
              	    <ics:then>
						<ics:setvar name="doproceed" value="NoPublishDest"/>
              	    </ics:then>
              	    <ics:else>
                  	    <SELECT NAME="<%=normFormField.normalize("target")%>" SIZE="1">
						<%
						for (int targetIndex = 0; targetIndex < Integer.parseInt(ics.GetVar("pbtTotal")); targetIndex++) {
							args.setValString("NAME", "pbt"+String.valueOf(targetIndex));
							args.setValString("PREFIX", "pubtgt:");
							ics.runTag("pubtarget.scatter", args);
							args.removeAll();

							args.setValString("NAME", "dtype");
							args.setValString("OBJECTID", ics.GetVar("pubtgt:type"));
							ics.runTag("deliverytype.load", args);
							args.removeAll();

							args.setValString("NAME", "dtype");
							args.setValString("FIELD", "name");
							args.setValString("OUTPUT", "dtype:name");
							ics.runTag("deliverytype.get", args);
							args.removeAll();
							%>
                  		    <ics:if condition='<%=!ics.GetVar("pubtgt:id").equals(ics.GetVar("dest"))%>'>
                  		    <ics:then>
                  			  <OPTION VALUE="<%=ics.GetVar("pubtgt:id")%>"/><xlat:stream key="dvin/UI/Publish/pubtgtnameLPusingpubdtnameRP"/>
                  		    </ics:then>
                  		    <ics:else>
                  			  <OPTION VALUE="<%=ics.GetVar("pubtgt:id")%>" SELECTED="true"/><xlat:stream key="dvin/UI/Publish/pubtgtnameLPusingpubdtnameRP"/>
                  		    </ics:else>
                  		    </ics:if>
                  		    <%
                        }
                        %>
                  		</SELECT>
              	    </ics:else>
              	    </ics:if>
                    </TD>
				</TR>

				<ics:if condition='<%=ics.GetVar("doproceed").equals("true")%>'>
				<ics:then>
					<!--
					- Let another element add publishing factors
					-->
              		<property:get param="xcelelem.publishfactors" inifile="futuretense_xcel.ini" varname="proppublishfactors"/>
              		<ics:if condition='<%=ics.GetVar("proppublishfactors").length()!=0%>'>
              		<ics:then>
              		    <!-- use customized element -->
              		    <!--callelement NAME="Variables.proppublishfactors"/-->
                        <!-- call console from a popup since the custom element probably won't work in a portlet -->
              		</ics:then>
              		</ics:if>
              	</ics:then>
              	</ics:if>
			</TABLE>
			</ics:else>
			</ics:if>
                
			<ics:if condition='<%=ics.GetVar("doproceed").equals("NoPublishDest")%>'>
			<ics:then>
				  <xlat:stream key="dvin/UI/Noexistingpublishdestsite"/>
			</ics:then>
			</ics:if>
            </td>
        </tr>
        <tr>
           <td><img height="8" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
        </tr>
      
        <ics:if condition='<%=ics.GetVar("doproceed").equals("true")%>'>
        <ics:then>
            <tr>
               <td>
                   <table>
                   <tr>
						<td ALIGN="LEFT" BGCOLOR="#FFFFFF">
							<satellite:link assembler="query" outstring='showContentURL' container='servlet'>
								<satellite:argument name='cs_environment' value='portal' />
								<satellite:argument name='pagename' value='OpenMarket/Xcelerate/Actions/PublishConsolePost'/>
							</satellite:link>
							<xlat:lookup key="dvin/UI/ShowOutput" varname="_XLAT_"/>
							<xlat:lookup key="dvin/UI/ShowOutput" varname="mouseover" escape="true"/>

							<% String showPopup = "csPubTargetPopup('" + ics.GetVar("showContentURL") + "', 'ShowContent')" ; %>
                      <td><a HREF="javascript:void(0);" onclick="<portlet:namespace/>_<%=showPopup%>" onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;' onmouseout="window.status='';return true"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/SelectDestination"/></ics:callelement></a>
						</td>
                   </tr>
                   </table>
               </td>
            </tr>
        </ics:then>
        </ics:if>
      
        <tr>
           <td><img height="15" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
        </tr>
        <tr>
           <td class="dark-line-color"><img height="2" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
        </tr>
        <tr>
           <td><img height="10" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
        </tr>
      </table> 
  
      <table border="0" cellpadding="0" cellspacing="0" WIDTH="80%">
      <tr>
          <td><span class="title-value-text"><xlat:stream key="dvin/UI/RunningPublishSessions"/></span></td>
      </tr>
      <tr>
         <td><img height="15" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
      </tr>
      
      <%
        args.setValString("STATUS", "running");
        args.setValString("PREFIX", "pubsess:");
        ics.runTag("pubsessionmanager.getall", args);
        args.removeAll();
  
      %>
      
      <ics:if condition='<%=ics.GetVar("pubsess:Total").equals("0")%>'>
      <ics:then>
           <tr><td><xlat:stream key="dvin/UI/NoRunningPublishSessions"/></td></tr>
      </ics:then>
      <ics:else>
          <ics:setvar name="hasRunningSessions" value="true" />
          
          <property:get param="xcelerate.batchmode" inifile="futuretense_xcel.ini" varname="batchmode"/>
          <ics:if condition='<%=!ics.GetVar("batchmode").equals("multiple")%>'>
          <ics:then>    
              <!-- close failed pubsessions -->
              <%
                int sessionIndex = 0;
                for (sessionIndex = 0; sessionIndex < Integer.parseInt(ics.GetVar("pubsess:Total")); sessionIndex++) {
                  args.setValString("NAME", "pubsess:"+String.valueOf(sessionIndex));
                  args.setValString("VARNAME", "pubsess:id");
                  ics.runTag("pubsession.getid", args);
                  args.removeAll();
  
                  args.setValString("ID", ics.GetVar("pubsess:id"));
                  args.setValString("OUTPUT", "output");
                  ics.runTag("publishclient.status", args);
                  args.removeAll();
                  
                  if (ics.GetVar("output").startsWith("Not found") && ics.GetErrno()>=0) {
                      args.setValString("ID", ics.GetVar("pubsess:id"));
                      ics.runTag("pubsessionmanager.fail", args);
                      args.removeAll();
                  }
                } %>
      		  
          </ics:then>
          </ics:if>
      
          <ics:if condition='<%=ics.GetVar("hasRunningSessions").equals("true")%>'>
      	<ics:then>
            <!-- get the fresh list - since we may have failed a running one -->    
            <%
              args.setValString("STATUS", "running");
              args.setValString("PREFIX", "pubsess:");
              ics.runTag("pubsessionmanager.getall", args);
              args.removeAll(); %>
              
      	    <ics:if condition='<%=!ics.GetVar("pubsess:Total").equals("0")%>'>
      	    <ics:then>
      	        <tr>
      	        <td>
      	            <table border="0" cellpadding="0" cellspacing="0">
      	            <tr>
      	            <td></td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td><td>&nbsp;</td>
      	            <td><span class="table-header-text"><b><xlat:stream key="dvin/Common/Destination"/></b></span></td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
      	            <td><span class="table-header-text"><b><xlat:stream key="dvin/UI/PublishBeginTime"/></b></span></td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
      	            <td><span class="table-header-text"><b><xlat:stream key="dvin/AT/Common/Status"/></b></span></td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
      	            <td><span class="table-header-text"><b><xlat:stream key="dvin/UI/PublishedBy"/></b></span></td>
      	            </tr>
      	    
      	            <tr><td colspan="2"><img height="10" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td></tr>
      	       
      	        	<%
                        for (int sessionIndex = 0; sessionIndex < Integer.parseInt(ics.GetVar("pubsess:Total")); sessionIndex++) {
                            args.setValString("NAME", "pubsess:"+String.valueOf(sessionIndex));
                            args.setValString("VARNAME", "pubsess:id");
                            ics.runTag("pubsession.getid", args);
                            args.removeAll();
            
                            args.setValString("ID", ics.GetVar("pubsess:id"));
                            args.setValString("OUTPUT", "output");
                            ics.runTag("publishclient.status", args);
                            args.removeAll(); %>
                          
                          <ics:setvar name="pubtgt:name" value=" "/>
      	                <ics:setvar name="inMySite" value="false"/>
      	                <!-- get target name, and whether it is accessible to me in my logged on site -->
                          <%
                            args.setValString("NAME", "pubsess:"+String.valueOf(sessionIndex));
                            args.setValString("VARNAME", "pubsess:target");
                            ics.runTag("pubsession.gettarget", args);
                            args.removeAll();
  
                            args.setValString("OBJVARNAME", "pubtgt");
                            args.setValString("ID", ics.GetVar("pubsess:target"));
                            ics.runTag("pubtargetmanager.load", args);
                            args.removeAll();
  
                            if (ics.GetErrno()==0) {
                                args.setValString("NAME", "pubtgt");
                                args.setValString("VARNAME", "pubtgt:name");
                                ics.runTag("pubtarget.getname", args);
                                args.removeAll();
  
                                args.setValString("NAME", "pubtgt");
                                args.setValString("OBJVARNAME", "sites");
                                ics.runTag("pubtarget.getsites", args);
                                args.removeAll();
  
                                args.setValString("NAME", "sites");
                                args.setValString("PUBID", ics.GetSSVar("pubid"));
                                args.setValString("VARNAME", "inMySite");
                                ics.runTag("sitelist.hassite", args);
                                args.removeAll();
                            }
                          %>
      	                <tr>
      	                <td></td>
      	            
      	                <ics:if condition='<%=ics.GetVar("inMySite")!=null && ics.GetVar("inMySite").equals("true")%>'>
      	                <ics:then>         
                              <satellite:link assembler="query" outstring='showContentURL' container='servlet'>
                                  <satellite:argument name='id' value='<%=ics.GetVar("pubsess:id")%>' />
                                  <satellite:argument name='cs_environment' value='portal' />
                                  <satellite:argument name='pagename' value='OpenMarket/Xcelerate/Actions/ShowPublishOutputFront'/>
                              </satellite:link>
                              <xlat:lookup key="dvin/UI/ShowOutput" varname="_XLAT_"/>
                              <xlat:lookup key="dvin/UI/ShowOutput" varname="mouseover" escape="true"/>
                  
                              <% String showPopup = "csPopup('" + ics.GetVar("showContentURL") + "', 'ShowContent')" ; %>
      	                    <td><A HREF="javascript:void(0);" onclick="<portlet:namespace/>_<%=showPopup%>" onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;' onmouseout="window.status='';return true"><img height="14" width="14" src="<%=cs_imageDir%>/graphics/common/icon/iconInspectContent.gif" border="0" alt="<%=ics.GetVar("_XLAT_")%>" title='<%=ics.GetVar("_XLAT_")%>' /></A></td>
      	                    <td></td>
      	                </ics:then>
      	                <ics:else>
      	                    <td><img height="14" width="14" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
      	                    <td><img height="14" width="14" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
      	                </ics:else>
      	                </ics:if>
      	            
      	                <td>&nbsp;</td>
      	                <td><string:stream variable="pubtgt:name"/></td>     	      	      
      	                <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
      	                <td>
                            <%
                              args.setValString("NAME", "pubsess:"+String.valueOf(sessionIndex));
                              args.setValString("VARNAME", "pubsess:startdate");
                              ics.runTag("pubsession.getstartdate", args);
                              args.removeAll();
                            %>
      	                <dateformat:getdatetime name='_FormatDate_' value='<%=ics.GetVar("pubsess:startdate")%>' valuetype='jdbcdate' varname='publishdate'/>
      	                <string:stream variable="publishdate"/>
      						</td>
      	                <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
      	                <td>
      	                    <%
                                if (ics.GetVar("output").startsWith("Running")) { %>
                                  <xlat:stream key="dvin/Common/Running"/> <%
                                } else { %>
                                  <string:stream variable="output"/> <%
                                } %>
      	                    <ics:setvar name="errno" value="0"/>    
      	                </td>
      	                <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
      	                <td>
                            <%
                              args.setValString("NAME", "pubsess:"+String.valueOf(sessionIndex));
                              args.setValString("VARNAME", "pubsess:publishedby");
                              ics.runTag("pubsession.getuser", args);
                              args.removeAll();
                            %>
                            <string:stream variable="pubsess:publishedby"/></td>
      	            
      	                </tr>  <%
                        } %>
      	            </table>
      	        </td>
      	        </tr>
      	    </ics:then>
      	    </ics:if>
      	</ics:then>
      	</ics:if>
      </ics:else>
      </ics:if>
      <tr>
         <td><img height="15" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
      </tr>
      <tr>
         <td class="dark-line-color"><img height="2" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
      </tr>
      <tr>
         <td><img height="10" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
      </tr>
      </table>
      
      <table border="0" cellpadding="0" cellspacing="0" WIDTH="80%">
      <tr>
          <td><span class="title-value-text"><xlat:stream key="dvin/UI/ScheduledPublishTasks"/></span></td>
      </tr>
      <tr>
         <td><img height="15" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
      </tr>
      
      <ics:setvar name="errno" value="0"/>
      <!-- read SystemEvents table -->
      <ics:queryevents list="scheduledtasks" enabled="true" name="PublishEvent_%"/>
      <!-- this code assumes that if there is no list the errno is not zero, but that isn't always true for reasons that are not clear to me. Therefore, I'm forcing an errno if there is no list. JRWS-->	
      <ics:if condition='<%=ics.GetErrno()>=0%>'>
      <ics:then>
           <ics:if condition='<%=ics.GetList("scheduledtasks")==null%>'>
           <ics:then>
      	      <ics:setvar name="errno" value="-101"/>
           </ics:then>
           </ics:if>
      </ics:then>
      </ics:if>
      	
      <ics:if condition='<%=ics.GetErrno()<0%>'>
      <ics:then>
          <tr><td><xlat:stream key="dvin/UI/NoScheduledPublishTasks"/></td></tr>
      </ics:then>
      <ics:else>
          <tr><td>
           <table border="0" cellpadding="0" cellspacing="0">
           <tr>
              <td></td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td><td>&nbsp;</td>
              <td><span class="table-header-text"><b><xlat:stream key="dvin/Common/Destination"/></b></span></td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
              <td><span class="table-header-text"><b><xlat:stream key="dvin/UI/PublishTimeDate"/></b></span></td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
              <td><span class="table-header-text"><b><xlat:stream key="dvin/UI/ScheduledBy"/></b></span></td>
           </tr>
           
           <tr><td colspan="2"><img height="10" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td></tr>
           <%
             IList tasks = ics.GetList("scheduledtasks");
             if (tasks.hasData()) {
                 do {
                    args.setValString("VALUE", "scheduledtasks.params");
                    args.setValString("PREFIX", "scheduled");
                    ics.runTag("url.scatter", args);
                    args.removeAll();
                    
                    args.setValString("ID", ics.GetVar("scheduled:target"));
                    args.setValString("OBJVARNAME", "pubtgt");
                    ics.runTag("pubtargetmanager.load", args);
                    args.removeAll();
  
                    args.setValString("VARNAME", "pubtgt:name");
                    args.setValString("NAME", "pubtgt");
                    ics.runTag("pubtarget.getname", args);
                    args.removeAll(); %>
                    
                    <tr>
                        <td></td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td></td>	      	      
                        <td><string:stream variable="pubtgt:name"/></td>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td><string:stream list="scheduledtasks" column="time"/></td>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td><string:stream variable="scheduled:scheduledby"/></td>
                     </tr> <%
                 } while (tasks.moveToRow(IList.next,0));
             }
             tasks.flush();
           %>
           </table>
           </td></tr>
      </ics:else>
      </ics:if>
      
      <tr>
         <td><img height="15" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
      </tr>
      <tr>
         <td class="dark-line-color"><img height="2" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
      </tr>
      <tr>
         <td><img height="10" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
      </tr>
      </table>
      
      <table border="0" cellpadding="0" cellspacing="0" WIDTH="80%">
      <tr>
          <td><span class="title-value-text"><xlat:stream key="dvin/UI/PublishHistory"/></span></td>
      </tr>
      <tr>
         <td><img height="15" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
      </tr>
      
      <!-- need to set a limit here, I think -->
      <!-- can we exclude running? -->
      <%
        args.setValString("PREFIX", "pubsess:");
        ics.runTag("pubsessionmanager.getallfinished", args);
        args.removeAll();
      %>
      
      <ics:if condition='<%=ics.GetVar("pubsess:Total").equals("0")%>'>
      <ics:then>
           <tr><td><xlat:stream key="dvin/UI/NoPublishHistory"/></td></tr>
      </ics:then>
      <ics:else>
          <tr><td>
           <table border="0" cellpadding="0" cellspacing="0">
           <tr>
              <td></td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td><td>&nbsp;</td>
              <td><span class="table-header-text"><b><xlat:stream key="dvin/Common/Destination"/></b></span></td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
              <td><span class="table-header-text"><b><xlat:stream key="dvin/UI/PublishEndTime"/></b></span></td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
              <td><span class="table-header-text"><b><xlat:stream key="dvin/AT/Common/Status"/></b></span></td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
              <td><span class="table-header-text"><b><xlat:stream key="dvin/UI/PublishedBy"/></b></span></td>
           </tr>
           
           <tr><td colspan="2"><img height="10" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td></tr>
           <%
             for (int sessionIndex = 0; sessionIndex < 20 && (sessionIndex < Integer.parseInt(ics.GetVar("pubsess:Total"))); sessionIndex++) {
                //<!-- get target name -->
                args.setValString("NAME", "pubsess:"+String.valueOf(sessionIndex));
                args.setValString("VARNAME", "pubsess:id");
                ics.runTag("pubsession.getid", args);
                args.removeAll();
  
                args.setValString("NAME", "pubsess:"+String.valueOf(sessionIndex));
                args.setValString("VARNAME", "pubsess:target");
                ics.runTag("pubsession.gettarget", args);
                args.removeAll();
                
                args.setValString("ID", ics.GetVar("pubsess:target"));
                args.setValString("OBJVARNAME", "pubtgt");
                ics.runTag("pubtargetmanager.load", args);
                args.removeAll(); %>
                
                <ics:if condition='<%=ics.GetErrno()==0%>'>
                <ics:then>
                  <%
                    args.setValString("NAME", "pubtgt");
                    args.setValString("VARNAME", "pubtgt:name");
                    ics.runTag("pubtarget.getname", args);
                    args.removeAll();
  
                    args.setValString("NAME", "pubtgt");
                    args.setValString("OBJVARNAME", "sites");
                    ics.runTag("pubtarget.getsites", args);
                    args.removeAll();
  
                    args.setValString("NAME", "sites");
                    args.setValString("PUBID", ics.GetSSVar("pubid"));
                    args.setValString("VARNAME", "inMySite");
                    ics.runTag("sitelist.hassite", args);
                    args.removeAll();
  
                  %>
                </ics:then>
                </ics:if>
                <tr>
                <td></td>
                <ics:if condition='<%=ics.GetVar("inMySite")!=null && ics.GetVar("inMySite").equals("true")%>'>
                <ics:then>
                    <satellite:link assembler="query" outstring='showContentURL' container='servlet'>
                        <satellite:argument name='id' value='<%=ics.GetVar("pubsess:id")%>' />
                        <satellite:argument name='cs_environment' value='portal' />
                        <satellite:argument name='pagename' value='OpenMarket/Xcelerate/Actions/ShowPublishOutputFront'/>
                    </satellite:link>
                    <xlat:lookup key="dvin/UI/ShowOutput" varname="_XLAT_"/>
                    <xlat:lookup key="dvin/UI/ShowOutput" varname="mouseover" escape="true"/>
        
                    <% String showPopup = "csPopup('" + ics.GetVar("showContentURL") + "', 'ShowContent')" ; %>
                    <td><A HREF="javascript:void(0);" onclick="<portlet:namespace/>_<%=showPopup%>" onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;' onmouseout="window.status='';return true">
                    <img height="14" width="14" src="<%=cs_imageDir%>/graphics/common/icon/iconInspectContent.gif" border="0" alt="<%=ics.GetVar("_XLAT_")%>" title="<%=ics.GetVar("_XLAT_")%>" /></A></td>
                    
                    <xlat:lookup key="dvin/UI/DeletePublishSession" varname="_XLAT_"/>
                    <xlat:lookup key="dvin/UI/DeletePublishSession" escape="true" varname="mouseover"/>
                    <satellite:link assembler="query" outstring='showContentURL' container='servlet'>
                        <satellite:argument name='id' value='<%=ics.GetVar("pubsess:id")%>' />
                        <satellite:argument name='cs_environment' value='portal' />
                        <satellite:argument name='pagename' value='OpenMarket/Xcelerate/Actions/RemovePubSessionFront'/>
                    </satellite:link>
                    <% showPopup = "csPopup('" + ics.GetVar("showContentURL") + "', 'ShowContent')" ; %>
                    <td><img height="10" width="5" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/><A HREF="javascript:void(0);" onclick="<portlet:namespace/>_<%=showPopup%>" onmouseover='window.status="<%=ics.GetVar("mouseover")%>";return true;' onmouseout="window.status='';return true">
                    <img height="14" width="14" src="<%=cs_imageDir%>/graphics/common/icon/iconDeleteContent.gif" border="0" alt="<%=ics.GetVar("_XLAT_")%>" title="<%=ics.GetVar("_XLAT_")%>" /></A></td>
                </ics:then>
                <ics:else>
                      <td><img height="14" width="14" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
                      <td><img height="14" width="14" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
                </ics:else>
                </ics:if>
                <td></td>
                <td><string:stream variable="pubtgt:name"/></td>
                <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td>
                  <%
                    args.setValString("NAME", "pubsess:"+String.valueOf(sessionIndex));
                    args.setValString("VARNAME", "pubsess:startdate");
                    ics.runTag("pubsession.getstartdate", args);
                    args.removeAll();
                  %>
                   <dateformat:getdatetime name='_FormatDate_' value='<%=ics.GetVar("pubsess:startdate")%>' valuetype='jdbcdate'  varname='publishdate'/>
                   <string:stream variable="publishdate"/>
                </td>
                <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td>
                  <%
                    args.setValString("NAME", "pubsess:"+String.valueOf(sessionIndex));
                    args.setValString("VARNAME", "pubsess:status");
                    ics.runTag("pubsession.getstatus", args);
                    args.removeAll();
                  %>
                    <ics:if condition='<%=ics.GetVar("pubsess:status").equals("done")%>'>
                    <ics:then><xlat:stream key="dvin/Common/Done"/></ics:then>
                    <ics:else><xlat:stream key="dvin/Common/Failed"/></ics:else>
                    </ics:if>
                </td>
                <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td>
                    <%
                    args.setValString("NAME", "pubsess:"+String.valueOf(sessionIndex));
                    args.setValString("VARNAME", "pubsess:user");
                    ics.runTag("pubsession.getuser", args);
                    args.removeAll();
                    %>
                    <string:stream variable="pubsess:user"/></td>
                <td></td>
               </tr> <%
             }
           %>
           </table>
           </td></tr>
      </ics:else>
      </ics:if>
      
      <tr>
         <td><img height="15" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
      </tr>
      <tr>
         <td class="dark-line-color"><img height="2" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
      </tr>
      <tr>
         <td><img height="5" width="1" src="<%=cs_imageDir%>/graphics/common/screen/dotclear.gif"/></td>
      </tr>
      </table>
    </satellite:form>
</ics:else>
</ics:if>
</cs:ftcs>
