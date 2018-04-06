<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<cs:ftcs>
	<gridconfig>
		<columns>
		 	<column id="name">
		    	<fieldname>name</fieldname>
		    	<columnname>Name</columnname>
		    	<width>200px</width>
				<formatter>fw.ui.GridFormatter.nameFormatter</formatter>
		    </column>
		    <column id="type">
		    	<fieldname>type</fieldname>
		    	<columnname>Type</columnname>
		    	<width>auto</width>
		    	<formatter></formatter>
		    </column>
		</columns>
	</gridconfig>	
</cs:ftcs>
