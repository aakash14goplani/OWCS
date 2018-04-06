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
	function validateUserProfileForm()
	{
			var errString="";
			// simple javascript to validate username/password
			document.getElementById("FormErrorArea").innerText = "";
			
			if (document.getElementById("<string:stream variable="UsernameAttrName"/>").value == "" )
			{
			    errString += "Username";
			}
			if (document.getElementById("<string:stream variable="PasswordAttrName"/>").value == "" )
			{
				 (errString == "")? errString +="Password" : errString += ", Password";

			}
			if (document.getElementById("<string:stream variable="FirstNameAttrName"/>").value == "" )
			{
					(errString == "")? errString +="Firstname" : errString += ", First name";
			}
			if (document.getElementById("<string:stream variable="LastNameAttrName"/>").value == "" )
			{
			    (errString == "")? errString +="Lastname" : errString += ", Last name";
			}
			
			if (errString == "")
			{
				document.getElementById("FormErrorArea").style.visibility = "hidden";
				return true;
			}
			else
			{
				document.getElementById("FormErrorArea").style.visibility = "visible";
				document.getElementById("FormErrorArea").innerText = "Invalid fields: " + errString ;
				return false;
			}
	}
//]]>
</script>

<%-- Create the form --%>
<render:lookup varname="WrapperVar" key="Wrapper" match=":x" />
<render:lookup varname="LayoutVar" key="Layout" />
<render:gettemplateurlparameters outlist="args" args="c,cid,p" tname='<%=ics.GetVar("LayoutVar")%>' wrapperpage='<%=ics.GetVar("WrapperVar")%>' />
<satellite:form method="post" id="UserProfileForm" onsubmit="return validateUserProfileForm();">
	<fieldset><legend>Content Server form processing fields</legend>
	<ics:listloop listname="args">
		<input type="hidden" name="<string:stream list="args" column="name"/>" value="<string:stream list="args" column="value"/>"/>
	</ics:listloop>
	</fieldset>
	<table>
	<tr>
		<th>Username:</th>
		<td>
			<ics:if condition='<%=ics.GetVar(ics.GetVar("UsernameAttrName")) != null%>'>
			<ics:then>
				<input name='<string:stream variable="UsernameAttrName"/>' value='<string:stream variable='<%=ics.GetVar("UsernameAttrName")%>'/>' type="hidden" /><string:stream variable='<%=ics.GetVar("UsernameAttrName")%>'/>
			</ics:then>
			<ics:else>
				<input name='<string:stream variable="UsernameAttrName"/>' type="text" SIZE="32"/>
			</ics:else>
			</ics:if>
		</td>
	</tr>
	<tr>
		<th>Password:</th>
		<td><input name='<string:stream variable="PasswordAttrName"/>' value='<string:stream variable='<%=ics.GetVar("PasswordAttrName")%>'/>' type="password" SIZE="32" /></td>
	</tr>
	<tr>
		<th>First Name:</th>
		<td><input name='<string:stream variable="FirstNameAttrName"/>' value='<string:stream variable='<%=ics.GetVar("FirstNameAttrName")%>'/>' type="text" SIZE="32" /></td>
	</tr>
	<tr>
		<th>Last Name:</th>
		<td><input name='<string:stream variable="LastNameAttrName"/>' value='<string:stream variable='<%=ics.GetVar("LastNameAttrName")%>'/>' type="text" SIZE="32" /></td>
	</tr>
	<tr>
		<%
		   String[] Options = new String[9];
		   Options[0]  = "20-24";
		   Options[1]  = "25-29";
		   Options[2]  = "30-34";
		   Options[3]  = "35-39";
		   Options[4]  = "40-44";
		   Options[5]  = "45-49";
		   Options[6]  = "50-54";
		   Options[7]  = "55-59";
		   Options[8]  = "60+";
		%>
		<th>Age</th>
		<td>
			<%=createSelectMenu(ics.GetVar("AgeAttrName"), Options, ics.GetVar(ics.GetVar("AgeAttrName")))%>
		</td>
	</tr>
	<tr>
		<%
		   Options = new String[2];
		   Options[0]  = "Female";
		   Options[1]  = "Male";
		%>
		<th>Gender</th>
		<td>
			<%=createSelectMenu(ics.GetVar("GenderAttrName"), Options, ics.GetVar(ics.GetVar("GenderAttrName")))%>
		</td>
	</tr>               
	<tr>
		<%
		   Options = new String[4];
		   Options[0]  = "Single";  
		   Options[1]  = "Divorced";
		   Options[2]  = "Married";
		   Options[3]  = "Seperated";
		%>
		<th>Marital Status</th>
		<td>
			<%=createSelectMenu(ics.GetVar("MaritalStatusAttrName"), Options, ics.GetVar(ics.GetVar("MaritalStatusAttrName")))%>
		</td>
	</tr>                      
	<tr>
		<%
		   Options = new String[3];
		   Options[0]  = "0";
		   Options[1]  = "1-2";
		   Options[2]  = "3+";
		%>
		<th>Number of Children at Home</th>
		<td>
			<%=createSelectMenu(ics.GetVar("NumKidsHomeAttrName"), Options, ics.GetVar(ics.GetVar("NumKidsHomeAttrName")))%>
		</td>
	</tr>                      
	<tr>
		<%
		   Options = new String[4];
		   Options[0]  = "0";
		   Options[1]  = "1";
		   Options[2]  = "2";
		   Options[3]  = "3+";
		%>
		<th>Number of Vehicles</th>
		<td>
			<%=createSelectMenu(ics.GetVar("NumCarsAttrName"), Options, ics.GetVar(ics.GetVar("NumCarsAttrName")))%>
		</td>
	</tr>                      
	<tr>
		<%
		   Options = new String[2];
		   Options[0]  = "Own";
		   Options[1]  = "Rent";
		%>
		<th>Own or Rent</th>
		<td>
			<%=createSelectMenu(ics.GetVar("OwnOrRentAttrName"), Options, ics.GetVar(ics.GetVar("OwnOrRentAttrName")))%>
		</td>
	</tr>                      
	<tr>
		<%
		   Options = new String[6];
		   Options[0]  = "$0 - $24,999";
		   Options[1]  = "$25,000 - $49,999";
		   Options[2]  = "$50,000 - $74,999";
		   Options[3]  = "$75,000 - $99,999";
		   Options[4]  = "$100,000 - $149,999";
		   Options[5]  = "$150,000+";
		%>
		<th>Annual Income</th>
		<td>
			<%=createSelectMenu(ics.GetVar("MedianIncomeAttrName"), Options, ics.GetVar(ics.GetVar("MedianIncomeAttrName")))%>
		</td>
	</tr>                      
	<tr>
	<th>
		<input type="hidden" name="form-to-process" value="<string:stream variable='form-to-process'/>" />
	</th>
	<td>
		<input type="submit" name="Submit" value="Submit" />
	</td>
	</tr>
	</table>
</satellite:form>

<p id="FormErrorArea">&nbsp;</p>

<%!
	/**
	 * This function streams a select form field.  
	 * @param field the name of the form field
	 * @param options[] array of option values
	 * @param selected the value of the selected option. may be null.
	 * @return string containing the output
	 */
	public String createSelectMenu(String field, String[] options, String selected)
	{
	
		StringBuffer output = new StringBuffer("<select name=\"");
		output.append(field).append("\">");
		for (int i = 0; i < options.length; i++)
		{
			// preserve formatting for source-code beauty
			output.append("\n				<option value=\"").append(options[i]).append("\"");
			if (options[i].equals(selected)) {
				output.append(" selected");
			}
			output.append('>').append(options[i]).append("</option>");
		}
		output.append("\n			</select>");
		return output.toString();
	}
%>
</cs:ftcs>