<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Gator/Scripts/ValidateUITextArea
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
<SCRIPT LANGUAGE="JavaScript">
function textAreaOC(obj, fieldname, len, fieldnameTA){
	var str =  obj._getValueAttr();	
	checkLength(str, len, fieldname);
	var instr = obj._getValueAttr();
	outstr = instr.substring(0,len);
	obj.set('value', outstr);
	var formObj = document.forms[0];
	formObj.elements[fieldnameTA].value = outstr;
}
function checkLengthOfTextOC(F,count) {
	if (F.length > 2000)
	{
		 var replacestr=/Variables.count/ ;
		 var xlatstr='<xlat:stream key="dvin/UI/Error/textenteredLinkcountexceeds2000charlimit" encode="false" escape="true"/>';
		 var replacestr1=/Variables.substring/;
		 xlatstr = xlatstr.replace(replacestr, count);
		 alert(xlatstr.replace(replacestr1,F.substring(1950,2000) ));
		return false;
	}
}
</SCRIPT>

</cs:ftcs>