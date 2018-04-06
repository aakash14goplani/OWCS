<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%//
// OpenMarket/Xcelerate/Util/SetBLOBFolder
//
// INPUT
//  cs_InstanceName
//  cs_FieldName
//  cs_IsMultiple
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>

<asset:scatter name='<%=ics.GetVar("cs_InstanceName")%>' prefix='attrScatter' fieldlist='<%=ics.GetVar("cs_FieldName")%>'/> <%

if (ics.GetVar("cs_IsMultiple")!=null && ics.GetVar("cs_IsMultiple").equals("true")) {
    if (!ics.GetVar("attrScatter:"+ics.GetVar("cs_FieldName")+":Total").equals("0")) {
        for (int i = 0; i < Integer.parseInt(ics.GetVar("attrScatter:"+ics.GetVar("cs_FieldName")+":Total")); i++) { %>
            <ics:callelement element='OpenMarket/Xcelerate/Util/GetBLOBFolder'>
              <ics:argument name='cs_GBF_filename' value='<%=ics.GetVar("attrScatter:"+ics.GetVar("cs_FieldName")+":"+String.valueOf(i)+"_file")%>'/>
              <ics:argument name='varname' value='cs_GBF_folder'/>
            </ics:callelement> <%
            ics.SetVar("attrScatter:"+ics.GetVar("cs_FieldName")+":"+String.valueOf(i)+"_folder", ics.GetVar("cs_GBF_folder"));
        }
    }
} 
else 
{ 
	if (ics.GetVar("attrScatter:"+ics.GetVar("cs_FieldName")+"_file")==null)
	{
		ics.SetVar("ISBLOBVALID", "false");
	}else {	%>
    <ics:callelement element='OpenMarket/Xcelerate/Util/GetBLOBFolder'>
        <ics:argument name='cs_GBF_filename' value='<%=ics.GetVar("attrScatter:"+ics.GetVar("cs_FieldName")+"_file")%>'/>
        <ics:argument name='varname' value='cs_GBF_folder'/>
    </ics:callelement> <%
    ics.SetVar("attrScatter:"+ics.GetVar("cs_FieldName")+"_folder", ics.GetVar("cs_GBF_folder")); }
}
%>
<asset:gather name='<%=ics.GetVar("cs_InstanceName")%>' prefix='attrScatter' fieldlist='<%=ics.GetVar("cs_FieldName")%>'/>

</cs:ftcs>