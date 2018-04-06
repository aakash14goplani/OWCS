<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// FutureTense/Apps/AdminForms/SiteplanMgt/header
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
<cs:ftcs>
<script type="text/javascript">
	(function() {		
		dojo.style(dojo.body(), {"overflow": "hidden"});
	})();
</script>
<ics:callelement element="OpenMarket/Xcelerate/Scripts/ValidateInputForXSS"/>
<SCRIPT LANGUAGE="JavaScript">

	function onSuffixSelect() {
		var dglistJson = document.getElementById("deviceGroupList");
		var dgList = dojo.fromJson(dglistJson.value);
		var dgSelectBox = document.getElementById("DGList");
		var suffixSelectBox = document.getElementById("SuffixList");
		var i, j, cnt = 0, SelectedSuffixes = [], l = dgSelectBox.options.length;
		for (i = 0; i < l; i++)
			dgSelectBox.remove(0);
		
		for (i = 0; i < dgList.length; i++)
		{
			for (j = 0; j < suffixSelectBox.options.length; j++)
			{
				if(suffixSelectBox.options[j].selected && suffixSelectBox.options[j].value == dgList[i].deviceGroupSuffix)
				{
					dgSelectBox.options[cnt] = new Option(dgList[i].name, dgList[i].id);
					dgSelectBox.options[cnt].style.color = 'black';
					dgSelectBox.options[cnt].disabled = true;
					cnt++;
				}
					
			}
		}
	}

	function isSelectedForDelete(form)
	{
		for(i = 0; i < form.length; i++)
		{
			if(form[i].name=="siteplanid" && form[i].checked==true)
			{
				var result = confirm('<xlat:stream key="dvin/UI/Common/DeleteConfirm" encode="false" escape="true"/>');
				if(result == true)
					return true;
				else
					return false;
			}
		}
		alert('<xlat:stream key="dvin/UI/MobilitySolution/Siteplan/selectSitePlanToDelete" encode="false" escape="true"/>');
		return false;
	}
	
	function canSubmit(form)
	{
		for(i = 0; i < form.length; i++)
		{
			if(form[i].name=="form" && form[i].checked==true)
			{
				if(form[i].value=="Create")
					return true;
				if(form[i].value=="DeleteSiteplanList")
					return true;
				if(form[i].value=="ModifySiteplanList")
					return true;
			}
		}
	}
	
	function createInputNodes(form) {
		var dgSelectBox = document.getElementById("DGList");
		if (dgSelectBox)
			for (i = 0; i < dgSelectBox.options.length; i++)
			{
				var element = document.createElement("input");
				element.setAttribute("type", "hidden");
				element.setAttribute("value", dgSelectBox.options[i].value);
				element.setAttribute("name", "DGList");
				form.appendChild(element);
			}
		return true;
	}
	
	function chkMandatoryFields(form)
	{
		for(i = 0; i < form.length; i++)
		{
			if(form[i].name=="name" && ""== form[i].value.trim())
			{
				alert('<xlat:stream key="dvin/UI/MobilitySolution/Siteplan/enterName" encode="false" escape="true"/>');
				return false;
			}

			if(form[i].name=="name" && !isCleanString(form[i].value, '<\'">\\/&?;:',true))
			{
				alert('<xlat:stream key="dvin/FlexibleAssets/Attributes/ApostropheNotAllowed" encode="false" escape="true"/>');
				return false;
			}
		}
		return createInputNodes(form);
	}
	
	String.prototype.trim = function() {
		return this.replace(/^\s+|\s+$/g, "");
	};
	
</SCRIPT>

</cs:ftcs>