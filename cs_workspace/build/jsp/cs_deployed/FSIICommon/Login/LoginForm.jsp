<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld" 
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld" 
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" 
%><%@ page import="COM.FutureTense.Interfaces.*" %><cs:ftcs>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>'   c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>'   c="CSElement"/></ics:then></ics:if>
    
<script type="text/javascript">
// <![CDATA[
	function validateLoginForm()
	{
			// simple javascript to validate username/password
			document.getElementById("FormErrorArea").innerText = "";
			if (document.getElementById("Username").value == "" )
			{
					document.getElementById("FormErrorArea").style.visibility = "visible";
					document.getElementById("FormErrorArea").innerText = "Invalid username";
					document.getElementById("Username").focus();
					return false;
			}
			else if(document.getElementById("Password").value == "")
			{
					document.getElementById("FormErrorArea").style.visibility = "visible";
					document.getElementById("FormErrorArea").innerText = "Invalid password";
					document.getElementById("Password").focus();
					return false;
			}
			else
			{
				document.getElementById("FormErrorArea").style.visibility = "hidden";
				return true;
			}
	}
//]]>
</script>

<render:lookup varname="WrapperVar" key="Wrapper"  match=":x"/>
<render:lookup varname="LayoutVar" key="Layout" />
<render:gettemplateurlparameters outlist="args" args="c,cid,p" tname='<%=ics.GetVar("LayoutVar")%>' wrapperpage='<%=ics.GetVar("WrapperVar")%>' />

<satellite:form method="post" id="LoginForm" onsubmit="return validateLoginForm();">
	<fieldset><legend>Content Server form processing fields</legend>
	<ics:listloop listname="args">
		<input type="hidden" name="<string:stream list="args" column="name"/>" value="<string:stream list="args" column="value"/>"/>
	</ics:listloop>
	</fieldset>

	<%-- Tell the wrapper page which form to process --%>
	<table>
	<tr>
		<th>User name:</th>
		<td><input name="Username" type="text" SIZE="32" id="Username"/></td>
	</tr>
	<tr>
		<th>Password:</th>
		<td><input name="Password" type="password" SIZE="32" id="Password"/></td>
	</tr>
	<tr>
		<th><input type="hidden" name="form-to-process" value="LoginPost" /></th>
		<td><input type="submit" name="Login" value="Login"/></td>
	</tr>
	<tr>
		<td colspan="2" id="FormErrorArea">&nbsp;</td>
	</tr>
	</table>
	
</satellite:form>


</cs:ftcs>