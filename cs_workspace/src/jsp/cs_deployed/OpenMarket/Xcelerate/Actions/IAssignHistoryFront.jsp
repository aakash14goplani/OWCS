<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="workflowasset" uri="futuretense_cs/workflowasset.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/IAssignHistoryFront
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/Workflow/LazyLoadAssignHistoryFront" outstring="assignHistoryURL">
    <satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
	<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
	<satellite:argument name="cs_imagedir" value='<%=ics.GetVar("cs_imagedir")%>'/>
	<satellite:argument name="AssetType" value='<%=ics.GetVar("AssetType")%>'/>
	<satellite:argument name="id" value='<%=ics.GetVar("id")%>'/>
</satellite:link>
<script type="text/javascript">
function retrieveWorkflowHistory()
{
    var xmlhttp;
    showLoading();
    if (window.XMLHttpRequest)
    {
        xmlhttp=new XMLHttpRequest();
    }
    else
    {
        xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4)
        {
            hideLoading();
            var node = document.getElementById("wfhistorylink");
            var newnode = document.createElement("div");
            newnode.innerHTML=xmlhttp.responseText;
            node.parentNode.insertBefore(newnode,node);
        }
    }
    xmlhttp.open("GET",'<%=ics.GetVar("assignHistoryURL")%>',true);
    xmlhttp.send();
}

function showLoading()
{
    document.getElementById("wfhistorylink").style.display='none';
    document.getElementById("ajaxLoading").style.display='block';
}

function hideLoading()
{
    document.getElementById("ajaxLoading").style.display='none';
}
</script>

<div id="wfhistorylink"><a href="javascript:retrieveWorkflowHistory()"><xlat:stream key="dvin/UI/Showworkflowhistory"/></a></div>
<div id="ajaxLoading" style="width:200px;height:100px; display:none;" bgcolor="white">
    <table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="#ffffff" align="center" style="border: 1px solid rgb(204,204,204);">
    <tbody>
    <tr>
    <td valign="middle" align="center">
    <img src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/wait_ax.gif'/>
    <br/>
    <br/>
    <b>
    <span><xlat:stream key="dvin/UI/Loading"/></span>
    <img src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/short_Progress.gif'/>
    </b>
    <a id="hider2" style="cursor: pointer; text-decoration: underline;"/>
    </td>
    </tr>
    </tbody>
    </table>
</div>
</cs:ftcs>