import COM.FutureTense.Interfaces.ICS
import COM.FutureTense.Interfaces.FTValList
import java.util.*
import java.text.SimpleDateFormat
import org.apache.commons.lang.StringUtils
import com.fatwire.assetapi.data.BlobObject
import java.io.File


public static class Functions
{
        public ICS ics;
        public Functions(ICS ics)
        {
            this.ics = ics;
        }

        public String spaceToUnderscore(String input)
        {
            return input.replaceAll("\\s", "_");
        }

        public String spaceToDash(String input)
        {
            return input.replaceAll("\\s", "-");
        }

        public String formatDate(Date input, String format)
        {
            SimpleDateFormat df = new SimpleDateFormat();
            df.applyPattern(format);
            return df.format(input);
        }

        public String listAsPath(List items, int max)
        {
            StringBuilder buf = new StringBuilder();
            int maxItems = max > items.size() ? items.size() : max;

            for(int x = 0; x < maxItems; x++)
            {
                Object item = items.get(x);
                buf.append(item.toString());
                if(x+1 < maxItems)
                    buf.append("/");
            }
            return buf.toString();
        }

		public String getFileName(BlobObject blob)
		{
     		String fileName = blob.getFilename();
      		if(StringUtils.isNotEmpty(fileName))
      		{
      			// Remove the folder names from the file name"
      			int lastIndex = fileName.lastIndexOf(File.separator);      				      				
      			if(lastIndex> 0)
      			{
      				fileName = fileName.substring(lastIndex+1);
      			}
      			// Remove ,01" from the filenames
      			// filename,10.jpg --> filename.jpg
      			fileName = fileName.replaceAll("(,\\d*)\\.", ".");
      			
      		}
          	return fileName;      		
		}


        public String property(String key, String defaultValue, String files)
        {
			String retVal;

			if(null != files  && files.length() > 0)
			{
			    files = files.replaceAll(",", ";");
				retVal = ics.GetProperty(key, files, true);
			}
			else
			{
				retVal = ics.GetProperty(key);
			}

			return (null == retVal || retVal.trim().length() == 0) ? defaultValue : retVal.trim();
        }


}

    // Use the Functions defined above to be used for expressions.
    Map functionsMap = new HashMap();
    functionsMap.put("f", new Functions(ics));
    ics.SetObj("f", functionsMap);



