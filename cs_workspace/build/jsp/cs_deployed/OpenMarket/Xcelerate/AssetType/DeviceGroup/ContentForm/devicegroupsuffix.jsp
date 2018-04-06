<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/DeviceGroup/ContentForm/devicegroupsuffix
//
// INPUT
//
// OUTPUT - If its NEW  DeviceGroup page, show both - text-box to enter new suffix and a drop-down for selecting existing suffix.
//            If its edit page, just show a read only label with suffix value.
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage,java.util.List,java.util.ArrayList"%>
<cs:ftcs>

<% ics.SetVar("name", ics.GetVar("fielddescription")); %>
<xlat:lookup key="dvin/UI/MobilitySolution/Suffix/enterNewSuffix" varname="enterNewSuffix" encode="false" escape="true"/>
<xlat:lookup key="dvin/UI/MobilitySolution/Suffix/emptySuffixMsg" varname="emptySuffixMsg" />
<xlat:lookup key="UI/MobilitySolution/DeviceGroup/Suffix/invalidchars" varname="invalidchars" encode="false" escape="true"/>
 
<%
String editMode = "editfront";
boolean isEdit = false;
if(editMode.equalsIgnoreCase(ics.GetVar("updatetype")))
isEdit = true;

String defaultVal = ics.GetVar("enterNewSuffix"),currentValue = ics.GetVar("fieldvalue"),boxWidth="60px";
String value = (currentValue != null)?currentValue:defaultVal;
%>

<script language="javascript" type="text/javascript">

    String.prototype.trim = function() {
        return this.replace(/^\s+|\s+$/g, "");
    };

    function validateSuffix()
    {
        var isEditMode = '<%=isEdit%>';
        if(isEditMode == 'false')
        {
            var textBox = document.getElementById('<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>');
            var dropDown = document.getElementById("ExistingSuffices");

            if(textBox.value == '<%=defaultVal%>' || (textBox.value).trim() == "")
            {
            	alert('<%=ics.GetVar("emptySuffixMsg")%>');
            	return false;
            }

            //Restricting invalid characters and they are as per below:
            // ' " : ; ? < > % # & = _		
            if (!isCleanString(textBox.value,'#&=_'))
            {
            	alert('<%= ics.GetVar("invalidchars") %>');
            	return false;
            }		

            if(dropDown.value != '<%=defaultVal%>')
            {
                document.getElementById('<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>').value = dropDown.value;
                return true;
            }
        }
        return true;
    }
</script>
<style>
	.fw .deviceGroupSuffix .UIComboBox {
		width: 214px;
	}
</style>
<body>
<script>
dojo.addOnLoad(function() {
	loadList();
	loadCapabilities();
	loadScreenDimensions();
	loadSortedFilterNames();
	makeCategoryReadOnly();
	criteriaFieldEnableDisable()
}
);
</script>
<div class="deviceGroupSuffix" style="position: relative;width:650px;">

<!-- div  dojoType='fw.ui.dijit.Button' title="Auto-Generate Templates" label= "Auto-Generate Templates" ></div --> 
<%
    if(!isEdit)
	{
        String sql = "SELECT DISTINCT devicegroupsuffix from " + ics.GetVar("AssetType") + " where status!='VO'";
        %>

        <ics:sql sql="<%=sql%>" listname="suffixes" table='<%=ics.GetVar("AssetType")%>'/>
        <input name='<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>' type="hidden" maxlength="10" id='<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>' value='<%=value%>'/>
		<%
			String dojoProps = "placeHolder:\"" + defaultVal + "\" , value:\"\"";
		%>
		<ics:if condition='<%=ics.GetVar("CopyidEnc")!= null%>'>
		<ics:then>
			<%
				dojoProps = "";
			%>
		</ics:then>
		</ics:if>
        <select data-dojo-type="fw.dijit.UIComboBox" name="ExistingSuffices" id="ExistingSuffices" data-dojo-props='<%=dojoProps%>'>
            <ics:if condition='<%=ics.GetErrno() != -101%>'>
                <ics:then>
                    <ics:listloop listname="suffixes">
                        <ics:listget listname="suffixes" fieldname="devicegroupsuffix" output="suffix" />
                        <ics:if condition='<%=Utilities.goodString(ics.GetVar("suffix"))%>'>
                        <ics:then>
							<ics:if condition='<%=ics.GetVar("ContentDetails:devicegroupsuffix")!= null && ics.GetVar("ContentDetails:devicegroupsuffix").equalsIgnoreCase(ics.GetVar("suffix"))%>'>
							<ics:then>
								<option selected="selected" value='<%=ics.GetVar("suffix")%>' title='<%=ics.GetVar("suffix")%>'> <%=ics.GetVar("suffix")%></option>
							</ics:then>
							<ics:else>
								<option value='<%=ics.GetVar("suffix")%>' title='<%=ics.GetVar("suffix")%>'> <%=ics.GetVar("suffix")%></option>
							</ics:else>
							</ics:if>
                        </ics:then>
                        </ics:if>      
                    </ics:listloop>
                </ics:then>
            </ics:if>
        </select>    

        <xlat:lookup key="dvin/UI/MobilitySolution/Suffix/instruction" varname="suffixInstruction" />
        <img title='<%=ics.GetVar("suffixInstruction")%>' alt='<%=ics.GetVar("suffixInstruction")%>' src='<%=request.getContextPath()+"/Xcelerate/graphics/common/icon/help_new.png"%>' style="vertical-align: middle; margin-left: 10px;"> &nbsp; &nbsp;
        <br>
        <%
    }
    else
    {
        %>
            <string:stream value='<%=ics.GetVar("fieldvalue")%>' />
            <input name='<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>' type="hidden" maxlength="10" id='<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>' />
        <%
    }
%>

<script language="javascript" type="text/javascript">
function updateDeviceGroupSuffix() {
    var existingSuffices = dijit.byId('ExistingSuffices');
    if (existingSuffices)
        dojo.byId('<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>').value = existingSuffices.value; 
	else
		dojo.byId('<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>').value='<%=value%>';
}
</script>
</div>

</div>

</body>

</cs:ftcs>