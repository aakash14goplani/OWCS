<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="controller" uri="futuretense_cs/controller.tld"
%><cs:ftcs>
<div id='viewContainer_<ics:getvar name="viewId" />' dojoType="dijit.layout.BorderContainer" class="customViewArea">
	<div id='toolbar_<ics:getvar name="viewId" />' dojoType="fw.ui.dijit.Toolbar" region="top"></div>
	<iframe id='contentPane_<ics:getvar name="viewId" />' ></iframe>
</div>
</cs:ftcs>