<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// OpenMarket/Xcelerate/PrologActions/Publish/AdvPub/DestEditUI
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
<%@ page import="java.util.ArrayList"%>
<cs:ftcs>
<script type="text/javascript">
<!--
// checkFactors function is called by OpenMarket/Xcelerate/Admin/Publish/DestEdit when saving|editing a destination
// TODO: add error checking
function checkFactors() {
    // GRM: factors should be assembled into a URL string before submission 
	var obj = document.forms[0];
    var factorElement  = obj.elements['pubtgt:factors'];

    var currentFactors = factorElement.value;
    //Now reset the value and populate it for each field
	factorElement.value='';
    var currentElement;
	var currentName;
	
	currentElement = obj.elements['remoteUser'];
	currentName    = "REMOTEUSER";
	
	if (currentElement.value!='')
	    factorElement.value = currentName + "=" + currentElement.value;

	currentElement = obj.elements['realTimeDir'];
	currentName    = "REALTIMEDIR";
	if (currentElement.value!='')
	    factorElement.value += "&" + currentName + "=" + currentElement.value;

	
	currentElement = obj.elements['verbose'];
	currentName    = "VERBOSE";
	if (currentElement.checked)
	    factorElement.value += "&" + currentName + "=" + currentElement.value;
	else 
	    factorElement.value += "&" + currentName + "=false";
	
	currentElement = obj.elements['PubOptions'];
	currentName    = "PUBLISHOPTION";
	for (var i=0;i< currentElement.length;i++) {
		if (currentElement[i].checked) {
			factorElement.value += "&" + currentName + "=" + currentElement[i].value;
		}
	}
	
	currentElement = obj.elements['alert'];
	currentName    = "EMAILALERT";

	if (currentElement.checked && document.getElementById("emailList").length > 0){
	    factorElement.value += "&" + currentName + "=" + currentElement.value;
		var emailList=document.getElementById("emailList");
			var emailStr="";
			for (i=0;i < emailList.length;i++){
				if(i==0){
					emailStr+=emailList.options[i].text;
				} else{
					emailStr+=";" + emailList.options[i].text;
				}
			}
			factorElement.value += "&EMAILIDS=" + emailStr;
	} else 
	    factorElement.value += "&" + currentName + "=false";

	currentElement = obj.elements['remotePassword'];
	currentName    = "REMOTEPASS";
	if (currentElement.value!='')
	    factorElement.value += "&" + currentName + "=" + currentElement.value;
	if (currentFactors != '')    
	    factorElement.value += "&" + currentFactors;
}

//-->
</script>
<%if ("type".equals(ics.GetVar("destField")))
{
    if ("details".equals(ics.GetVar("action")))
    {
	java.util.StringTokenizer factors = new java.util.StringTokenizer(ics.GetVar("pubtgt:factors"), "&");
    String[] factorNames = {"PUBLISHOPTION"};
    String[] factorValues = {""};
    StringBuffer extraFactors = new StringBuffer();

    while (factors.hasMoreTokens())
    {
	String nextFactor = factors.nextToken().trim();
	for (int i=0;i<factorNames.length;i++) {
	    String search = factorNames[i] + "=";
	    if (nextFactor.startsWith(search)) {
		factorValues[i] = nextFactor.substring(search.length());
		}
	}
    }%>
	<ics:setvar name="PUBLISHOPTION" value="<%=factorValues[0]%>"/>
	
	<ics:callelement element="OpenMarket/Xcelerate/Admin/Publish/DestEditUI"/>
			</tr>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td></td>
				<td class="form-inset">
					<xlat:lookup key="dvin/UI/Admin/InitializeMirrorDestination" varname="alt"/>
					<xlat:lookup key="dvin/UI/Admin/InitializeMirrorDestination" varname="_XLAT_" escape="true"/>
					<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Admin/Publish/TargetSiteEdit" outstring="urltargsiteedit">
						<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
						<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
						<satellite:argument name="id" value='<%=ics.GetVar("pubtgt:id")%>'/>
					</satellite:link>
			         <A HREF='<%=ics.GetVar("urltargsiteedit")%>'  onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/InitializeRealtimeDest"/></ics:callelement>
					</A>
				</td>
<%}
}
else if ("factors".equals(ics.GetVar("destField")))
{
    java.util.StringTokenizer factors = new java.util.StringTokenizer(ics.GetVar("pubtgt:factors"), "&");
    String[] factorNames = {"REMOTEUSER", "REMOTEPASS", "VERBOSE", "DIR", "URLPREFIX", "SUFFIX", "SIMPLENAME", "SIMPLEDIR", "OLDTEMPLATE","EMAILALERT","EMAILIDS","PUBLISHOPTION","REALTIMEDIR"};
    String[] factorValues = {"fwadmin","","false","","","","","","","false","","",""};
	ArrayList IdList = new ArrayList();
    StringBuffer extraFactors = new StringBuffer();

    while (factors.hasMoreTokens())
    {
	String nextFactor = factors.nextToken().trim();
	boolean isExtra = true;
	for (int i=0;i<factorNames.length;i++) {
	    String search = factorNames[i] + "=";
		if (nextFactor.startsWith(search)) {
		factorValues[i] = nextFactor.substring(search.length());
		isExtra = false;
	    }
	}
        if (isExtra) 
	    extraFactors.append(nextFactor).append('&');
    }
	if(factorValues[10] !=null & factorValues[10].trim().length() > 0){
		java.util.StringTokenizer Ids = new java.util.StringTokenizer(factorValues[10].trim(), ";");
		while(Ids.hasMoreTokens()){
			String emailId = Ids.nextToken().trim();
			IdList.add(emailId);
		}
	}
	/* GRM: this is an edit form if the action is not 'details' */
    if (!"details".equals(ics.GetVar("action")))
    {%>
	</tr>
	</tbody>
	<tbody id="exportToDiskOption" style="display:<%if (factorValues[11].trim().equals("Export")){%>;<%}else{%>none;<%}%>">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
			<td class="form-label-text">
				<xlat:stream key="dvin/UI/Publish/Export-Dir"/>:
				</td>
				<td class="form-inset"><INPUT NAME="realTimeDir" TYPE="TEXT" SIZE="32" VALUE='<%=factorValues[12]%>'/></td>
				<td></td>
			</tr>
	</tbody>
	<tbody id="mirrorRows" style="display:<%if (factorValues[11].trim().equals("Export")){%>none;<%}%>">
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
		<tr>
			<td class="form-label-text">
				<span class="alert-color">*</span><xlat:stream key="dvin/UI/Admin/Destinationaddress"/>:
				</td>
				<td class="form-inset">
					<INPUT NAME="pubtgt:dest" TYPE="TEXT" SIZE="32" VALUE='<%=ics.GetVar("pubtgt:dest")%>'/>
				</td><td></td>
			</tr>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text">
                    <span class="alert-color">*</span><xlat:stream key="dvin/UI/Publish/Mirror1Destination-RemoteUser"/>:
                </td>
                <td class="form-inset"><INPUT NAME="remoteUser" TYPE="TEXT" SIZE="32" VALUE='<%=factorValues[0]%>'/></td>
                <td></td>
            </tr>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text">
                    <span class="alert-color">*</span><xlat:stream key="dvin/UI/Publish/Mirror1Destination-RemotePassword"/>:
                </td>
                <td class="form-inset"><INPUT NAME="remotePassword" TYPE="PASSWORD" SIZE="32" VALUE='<%=factorValues[1]%>'/></td>
                <td></td>
            </tr>
	</tbody>
	<tbody>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
               <td class="form-label-text" NOWRAP="NOWRAP">
                  <xlat:stream key="dvin/UI/Publish/SendEmailOnFailure"/>:
                </td>
                <td class="form-inset"><INPUT TYPE="CHECKBOX" NAME="alert" VALUE='true' onClick="showHideEmailConfig(this.checked)"
<%if ("true".equals(factorValues[9])) { %>CHECKED<% }%>                                                                                            /></td>
                <td></td>
            </tr>
	</tbody>
	<tbody id="emailConfig" <%if ("false".equals(factorValues[9])) {%>style="display:none"<%}%>>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/EmailIds"/>:
                </td>
                <td class="form-inset"><INPUT TYPE="text" NAME="emailInput" /></td>
                <td></td>
            </tr>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td></td>
                <td VALIGN="TOP"><table><tr><td rowSpan="2"><select id="emailList" size="5" multiple="multiple" STYLE="width: 250px">
					<%
					 for(int p =0;p<IdList.size();p++){
					 if(p==0){%>
						<option selected value="<%=IdList.get(p)%>"><%=IdList.get(p)%></option>
					 <%} else {
					 %>
						<option value="<%=IdList.get(p)%>"><%=IdList.get(p)%></option>
					 <%
					 }}
					%>
					</select></td><td>&nbsp;<A href="#" onclick="validateAndInsertEmail('0','emailInput');return false;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Add"/></ics:callelement></A></td></tr>
					<tr><td>&nbsp;<A href="#" onclick="removeEmail(document.forms[0].emailList);return false;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Remove"/></ics:callelement></A></td></tr></table></td>
                <td></td>
            </tr>
	</tbody>
	<tbody>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Mirror1Destination-Verbose"/>:
                </td>
                <td class="form-inset"><INPUT TYPE="CHECKBOX" NAME="verbose" VALUE='true'
<%
		     if ("true".equals(factorValues[2])) { %>CHECKED<% }
%>                                                                                            /></td>
                <td></td>
            </tr>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Mirror1Destination-More"/>:
                </td>
                <td class="form-inset"><INPUT NAME="pubtgt:factors" TYPE="TEXT" SIZE="32" MAXLENGTH="800" VALUE='<string:stream value='<%=extraFactors.toString()%>'/>'/></td>
                <td></td><%
    }

    if ("details".equals(ics.GetVar("action")))
    {
	if(factorValues[11].trim().equals("Export")){%>
			<td class="form-label-text">
				<xlat:stream key="dvin/UI/Publish/Export-Dir"/>:
				</td>
				<td class="form-inset"><string:stream value='<%=factorValues[12]%>'/></td>
				<td></td>
			</tr>
	<%} else {%>
			<td class="form-label-text">
				<xlat:stream key="dvin/UI/Admin/Destinationaddress"/>:
				</td>
				<td class="form-inset">
					<string:stream value='<%=ics.GetVar("pubtgt:dest")%>'/>
				</td><td></td>
			</tr>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Mirror1Destination-RemoteUser"/>:
                </td>
                <td class="form-inset"><string:stream value='<%=factorValues[0]%>'/></td>
                <td></td>
            </tr>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Mirror1Destination-RemotePassword"/>:
                </td>
                <td class="form-inset"><xlat:stream key="dvin/UI/Publish/Mirror1Destination-RemotePasswordBlank"/></td>
                <td></td>
            </tr>
	<%}%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text" NOWRAP="NOWRAP">
                    <xlat:stream key="dvin/UI/Publish/SendEmailOnFailure"/>:
                </td>
                <td class="form-inset">           
                    <%
                    if ("true".equals(factorValues[9]))
                    {
                    %>  <xlat:stream key="dvin/AT/Common/true" encode="false"/><%
                    }
                    else
                    {
                    %>  <xlat:stream key="dvin/AT/Common/false" encode="false"/><%
                    }
                    %>
                    </td>
                <td></td>
            </tr><%
		     if ("true".equals(factorValues[9])){%> 
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text" NOWRAP="NOWRAP">
                    <xlat:stream key="dvin/UI/Publish/EmailIds"/>:
                </td>
                <td class="form-inset" width="200px"><%
					 for(int p =0;p<IdList.size();p++){
					 if((p>0) && (p%3 == 0))%><BR/><%=IdList.get(p)%><%if(p != IdList.size()-1){%>;<%}}%></td>
                <td></td>
            </tr><%}%>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Mirror1Destination-Verbose"/>:
                </td>
                <td class="form-inset">
                    <%
                    if ("true".equals(factorValues[2]))
                    {
                    %>  <xlat:stream key="dvin/AT/Common/true" encode="false"/><%
                    }
                    else
                    {
                    %>  <xlat:stream key="dvin/AT/Common/false" encode="false"/><%
                    }
                    %>
                </td>
                <td></td>
            </tr>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Mirror1Destination-More"/>:
                </td>
                <td class="form-inset"><string:stream value='<%=extraFactors.toString()%>'/></td>
                <td></td><%}
} else if ("getPublishOption".equals(ics.GetVar("PublishOptAction")))
    {
	java.util.StringTokenizer factors = new java.util.StringTokenizer(ics.GetVar("pubtgt:factors"), "&");
    String pubOption = "PUBLISHOPTION";
    String pubOptionVal = "";
    while (factors.hasMoreTokens())
    {
	String nextFactor = factors.nextToken().trim();
	String search = pubOption + "=";
    if (nextFactor.startsWith(search)) {
		pubOptionVal = nextFactor.substring(search.length());
	}
    }
%>
<xlat:stream key="dvin/UI/Publish/SelectDesiredPubOption"/><BR/>
<INPUT type="radio" name="PubOptions" value="Complete" onclick="checkExportOption(this)" <%if ("Complete".equals(pubOptionVal)){ %>CHECKED<% }%>/><xlat:stream key="dvin/UI/Publish/CompletePublish"/><br/>
<INPUT type="radio" name="PubOptions" value="Delayed" onclick="checkExportOption(this)" <%if ("Delayed".equals(pubOptionVal)){ %>CHECKED<% }%>/><xlat:stream key="dvin/UI/Publish/DelayedPublish"/><br/>
<%--<INPUT type="radio" name="PubOptions" value="Export" onclick="checkExportOption(this)" <%if ("Export".equals(pubOptionVal)){ %>CHECKED<% }%>/><xlat:stream key="dvin/UI/Publish/ExportToLocalDisk"/><br/>--%>
<%}%>
</cs:ftcs>
