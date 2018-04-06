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
		</fields>
	</listviewconfig>
</cs:ftcs>
