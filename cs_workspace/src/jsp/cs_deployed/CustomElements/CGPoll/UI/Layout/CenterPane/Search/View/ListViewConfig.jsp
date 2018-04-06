<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<cs:ftcs>
	<listviewconfig>
		<numberofitems>1000</numberofitems>
		<numberofitemsperpage>100</numberofitemsperpage>
		<defaultsortfield></defaultsortfield>
		<defaultsortorder></defaultsortorder>
		<fields>
			<field id="name">
				<fieldname>name</fieldname>
				<displayname><xlat:stream key="CG/Name"/></displayname>
				<formatter>fw.ui.GridFormatter.nameFormatter</formatter>
				<displayintooltip>true</displayintooltip>
			</field>
			<field id="widgetName">
				<fieldname>widgetName</fieldname>
				<displayname><xlat:stream key="CG/WidgetName"/></displayname>
				<displayintooltip>true</displayintooltip>
			</field>
			<field id="question">
				<fieldname>pollQuestion</fieldname>
				<displayname><xlat:stream key="CG/Question"/></displayname>
				<displayintooltip>true</displayintooltip>
			</field>
			<field id="updateddate">
				<fieldname>updateddate</fieldname>
				<displayname><xlat:stream key="CG/Modified"/></displayname>
				<javadateformat>SHORT</javadateformat>
				<displayintooltip>true</displayintooltip>
			</field>
		</fields>
	</listviewconfig>
</cs:ftcs>
