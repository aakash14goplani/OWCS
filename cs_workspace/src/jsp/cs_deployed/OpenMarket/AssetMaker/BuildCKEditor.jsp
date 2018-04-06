<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%
//OpenMarket/AssetMaker/BuildCKEditor.jsp

/*
	Input:
		ICS variables: fieldname (usually fckeditor), fieldvalue (if it exists in the database, usually string value)
		Also assettype which is read from the loaded asset.		

	Comments:
		This element is called to Build an FCK Editor into an asset editor form.
		This JSP element sets up certain parameters like default width, default height, basepath, etc 
		and calls another element BuildFCKEditor_XML.xml which actually builds up the FCK Editor on screen.
	
	-Sathish Paul Leo
*/
%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
	<ics:getproperty name="xcelerate.ckeditor.basepath" file="futuretense_xcel.ini" output="basepath"/>
	<ics:getproperty name="ft.cgipath" file="futuretense.ini" output="cgipath"/>
	<%
		final String cgiPath = ics.GetVar("cgipath");
	%>
<ics:if condition='<%=!Utilities.goodString(ics.GetVar("basepath"))%>'>
<ics:then>
    <ics:setvar name="basepath" value='<%=ics.GetVar("cgipath") + "ckditor/"%>' />
</ics:then>
</ics:if>

	<%
		String locale = ics.GetSSVar("locale");
		locale = locale.toLowerCase().replace('_','-');
		//Generate the ids for the fckeditor so that if there are muliple instances(In different fields and not as in multi value) 
		//on the same form they can be handled idependently
		String generatedId = String.valueOf((int) (Math.random()*10000000));
	%>
	
	 <ics:setvar name="ckeditorlocale" value='<%=locale%>' />
	 <%
	//Take the width and height if they come with px else add it.
	if(ics.GetVar("assetmaker/property/" + ics.GetVar("fieldname") + "/inputform/width") != null){
		String _WIDTH = ics.GetVar("assetmaker/property/" + ics.GetVar("fieldname") + "/inputform/width").trim();		
		String WIDTH = _WIDTH.endsWith("px")?_WIDTH:_WIDTH+"px";		
		ics.SetVar("WIDTH",WIDTH);
	}
	if(ics.GetVar("assetmaker/property/" + ics.GetVar("fieldname") + "/inputform/height") != null){
		String _HEIGHT = ics.GetVar("assetmaker/property/" + ics.GetVar("fieldname") + "/inputform/height").trim();
		String HEIGHT=_HEIGHT.endsWith("px")?_HEIGHT:_HEIGHT+"px";		
		ics.SetVar("HEIGHT",HEIGHT);
	}
	/*
		Retrieve the servlet name from futuretense.ini and include the FCKEditor script based on that.
	*/
%>	

<script type="text/javascript" src="<ics:getvar name="basepath"/>ckeditor.js"></script>
	
<ics:callelement element="OpenMarket/AssetMaker/BuildCKEditor_XML">
	  <ics:argument name="_genId" value='<%=generatedId%>'/>
      <ics:argument name="basepath" value='<%=ics.GetVar("basepath")%>'/>
      <ics:argument name="assetType" value='<%=ics.GetVar("AssetType")%>' />
	  <ics:argument name="fieldname" value='<%=ics.GetVar("fieldname")%>' />
	  <ics:argument name="ckeditorlocale" value='<%=ics.GetVar("ckeditorlocale")%>' />
</ics:callelement>

</cs:ftcs>