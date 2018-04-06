<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
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
    var currentElement = obj.elements['urlPrefix'];
	var currentName    = "URLPREFIX";

	if (currentElement.value!='')
	    factorElement.value = currentName + "=" + currentElement.value;

    currentElement = obj.elements['dir'];
	currentName    = "DIR";

	if (currentElement.value!='')
	    factorElement.value += "&" + currentName + "=" + currentElement.value;

    currentElement = obj.elements['suffix'];
	currentName    = "SUFFIX";

	if (currentElement.value!='')
	    factorElement.value += "&" + currentName + "=" + currentElement.value;

    currentElement = obj.elements['oldTemplate'];
	currentName    = "OLDTEMPLATE";

	if (currentElement.value!='')
	    factorElement.value += "&" + currentName + "=" + currentElement.value;

	currentElement = obj.elements['verbose'];
	currentName    = "VERBOSE";

	if (currentElement.checked)
	    factorElement.value += "&" + currentName + "=" + currentElement.value;
	else 
	    factorElement.value += "&" + currentName + "=false";

	currentElement = obj.elements['simpleName'];
	currentName    = "SIMPLENAME";

	if (currentElement.checked)
	    factorElement.value += "&" + currentName + "=" + currentElement.value;
	else 
	    factorElement.value += "&" + currentName + "=false";

	currentElement = obj.elements['simpleDir'];
	currentName    = "SIMPLEDIR";

	if (currentElement.checked)
	    factorElement.value += "&" + currentName + "=" + currentElement.value;
	else 
	    factorElement.value += "&" + currentName + "=false";
		
	currentElement = obj.elements['alert'];
	currentName    = "EMAILALERT";

	if (currentElement && currentElement.checked && document.getElementById("emailList").length > 0){
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

    if (currentFactors != '')    
	    factorElement.value += "&" + currentFactors;
    
    if (factorElement.value.length > 0 && factorElement.value.substr(0, 1) == '&')
        factorElement.value = factorElement.value.substr(1);
}
//-->
</script>


<%
if ("type".equals(ics.GetVar("destField")))
{
    if ("details".equals(ics.GetVar("action")))
    {
%>
        <ics:callelement element="OpenMarket/Xcelerate/Admin/Publish/DestEditUI"/>
	</tr>
	<tr>
            <td></td>
            <td></td>
<%    
    }
}
else if ("factors".equals(ics.GetVar("destField")))
{
    java.util.StringTokenizer factors = new java.util.StringTokenizer(ics.GetVar("pubtgt:factors"), "&");
    String[] factorNames = {"DIR", "URLPREFIX", "SUFFIX", "SIMPLENAME", "SIMPLEDIR", "OLDTEMPLATE", "VERBOSE","EMAILALERT","EMAILIDS","PUBLISHOPTION"};
    String[] factorValues = {"","","","","","","false","false","",""};
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
	if(factorValues[7] !=null & factorValues[8].trim().length() > 0){
		java.util.StringTokenizer Ids = new java.util.StringTokenizer(factorValues[8].trim(), ";");
		while(Ids.hasMoreTokens()){
			String emailId = Ids.nextToken().trim();
			IdList.add(emailId);
		}
	}

    /* GRM: this is an edit form if the action is not 'details' */
    if (!"details".equals(ics.GetVar("action")))
    {   
%>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Export-Dir"/>:
                </td>
                <td class="form-inset"><INPUT NAME="dir" TYPE="TEXT" SIZE="32" VALUE='<%=factorValues[0]%>'/></td>
                <td></td>
            </tr>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			
			<tr>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Export-Urlprefix"/>:
                </td>
                <td class="form-inset"><INPUT NAME="urlPrefix" TYPE="text" SIZE="32" VALUE='<%=factorValues[1]%>'/></td>
                <td></td>
            </tr>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Export-Suffix"/>:
                </td>
                <td class="form-inset"><INPUT NAME="suffix" TYPE="text" SIZE="32" VALUE='<%=factorValues[2]%>'/></td>
                <td></td>
            </tr>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Export-Simplename"/>:
                </td>
                <td class="form-inset"><INPUT TYPE="CHECKBOX" NAME="simpleName" VALUE='true'
<%
		     if ("true".equals(factorValues[3])) { %>CHECKED<% }
%>                                                                                            /></td>
                <td></td>
            </tr>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Export-Simpledir"/>:
                </td>
                <td class="form-inset"><INPUT TYPE="CHECKBOX" NAME="simpleDir" VALUE='true'
<%
		     if ("true".equals(factorValues[4])) { %>CHECKED<% }
%>                                                                                            /></td>
                <td></td>
            </tr>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Export-Oldtemplate"/>:
                </td>
                <td class="form-inset"><INPUT NAME="oldTemplate" TYPE="text" SIZE="32" VALUE='<%=factorValues[5]%>'/></td>
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
<%if ("true".equals(factorValues[7])) { %>CHECKED<% }%>                                                                                            /></td>
                <td></td>
            </tr>
	</tbody>
	<tbody id="emailConfig" <%if ("false".equals(factorValues[7])) {%>style="display:none"<%}%>>
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
		     if ("true".equals(factorValues[6])) { %>CHECKED<% }
%>                                                                                            /></td>
                <td></td>
            </tr>
            
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Mirror1Destination-More"/>:
                </td>
                <td class="form-inset"><INPUT NAME="pubtgt:factors" TYPE="TEXT" SIZE="32" MAXLENGTH="800" VALUE='<string:stream value='<%=extraFactors.toString()%>'/>'/></td>
                <td></td>
<%
    }

    if ("details".equals(ics.GetVar("action")))
    {
%>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Export-Dir"/>:
                </td>
                <td class="form-inset"><string:stream value='<%=factorValues[0]%>'/></td>
                <td></td>
            </tr>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Export-Urlprefix"/>:
                </td>
                <td class="form-inset"><string:stream value='<%=factorValues[1]%>'/></td>
                <td></td>
            </tr>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Export-Suffix"/>:
                </td>
                <td class="form-inset"><string:stream value='<%=factorValues[2]%>'/></td>
                <td></td>
            </tr>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Export-Simplename"/>:
                </td>
                <td class="form-inset">
                    <%
                    if ("true".equals(factorValues[3]))
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
                    <xlat:stream key="dvin/UI/Publish/Export-Simpledir"/>:
                </td>
                <td class="form-inset">
                    <%
                    if ("true".equals(factorValues[4]))
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
                    <xlat:stream key="dvin/UI/Publish/Export-Oldtemplate"/>:
                </td>
                <td class="form-inset"><string:stream value='<%=factorValues[5]%>'/></td>
                <td></td>
            </tr>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text" NOWRAP="NOWRAP">
                    <xlat:stream key="dvin/UI/Publish/SendEmailOnFailure"/>:
                </td>
                <td class="form-inset">
                    <%
                    if ("true".equals(factorValues[7]))
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
			<%
		     if ("true".equals(factorValues[7])){
			%> 
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td VALIGN="TOP" NOWRAP="NOWRAP">
                    <xlat:stream key="dvin/UI/Publish/EmailIds"/>:
                </td>
                <td class="form-inset" width="200px"><%
					 for(int p =0;p<IdList.size();p++){
					 if((p>0) && (p%3 == 0))%><BR/><%
					 %><%=IdList.get(p)%><%if(p != IdList.size()-1){%>;<%}}%></td>
                <td></td>
            </tr>
			<%
			}
			%>
            <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
                <td class="form-label-text">
                    <xlat:stream key="dvin/UI/Publish/Mirror1Destination-Verbose"/>:
                </td>
                <td class="form-inset">
                    <%
                    if ("true".equals(factorValues[6]))
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
                <td></td>
<% 
    }
}
%>
</cs:ftcs>
