<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<cs:ftcs>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head></head>
	<body>
		<script type="text/javascript">
			window.onload = function () {
				var location = self.location.href;
				var index = location.indexOf('#');
				if (index > -1)
				{
					var hash = location.substring(index, location.length);
					parent.parent.location = parent.parent.location + hash;
				}
			};
		</script>
	</body>
</html>
</cs:ftcs>