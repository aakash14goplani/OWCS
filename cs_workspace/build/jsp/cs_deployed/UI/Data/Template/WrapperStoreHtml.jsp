<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ page import="java.util.*"
%><%@ page import="com.fatwire.services.ui.beans.UIPreviewWrapperBean"
%><cs:ftcs><%
	List<UIPreviewWrapperBean> wrapperList = (List<UIPreviewWrapperBean>)request.getAttribute("wList");
	for(UIPreviewWrapperBean wrapperBean : wrapperList){
		String wrapperName = wrapperBean.getName();
%>			
			<div dojoType="fw.ui.dijit.CheckedMenuItem" previewWrapper="true" id='<%=wrapperName%>' class="previewWrapperMenuItem">
			<%=wrapperName%>
				<script type="dojo/connect" event="onClick">
					SitesApp.event('active', 'changeWrapper', '<%=wrapperName%>');
				</script>
				<script type="dojo/connect" event="startup"> 
					var view = SitesApp.getActiveView(),
						self = this;
					this.set('checked', view.get('wrapper') === '<%=wrapperName%>');
					// hook callbacks for whenever the underlying model changes in the
					// current view (e.g. user navigates to a different asset in web mode)
					SitesApp.menuController.watch('model', function(view) {
						console.debug('menu controller watch!', view);
						self.set('checked', view.get('wrapper') === '<%=wrapperName%>');
					});
				</script>
			</div>
<%}if(wrapperList.size() == 0){%>
	<div dojoType="fw.dijit.UIMenuItem">
	<xlat:stream key="UI/UC1/Layout/NoPreviewWrappers" escape="true"/>
	</div>
<%}%>
</cs:ftcs>