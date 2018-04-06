<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"%><%@page trimDirectiveWhitespaces="true" %><%@page import="java.util.Date, java.io.FileOutputStream, java.io.ByteArrayOutputStream, java.io.OutputStream, java.text.SimpleDateFormat, java.util.Calendar, org.apache.poi.hssf.usermodel.HSSFWorkbook, org.apache.poi.hssf.usermodel.HSSFSheet, org.apache.poi.hssf.usermodel.HSSFFont, org.apache.poi.ss.usermodel.CellStyle, org.apache.poi.ss.usermodel.IndexedColors, org.apache.poi.hssf.usermodel.HSSFCellStyle, org.apache.poi.ss.usermodel.Row, org.apache.poi.ss.usermodel.Cell, org.jsoup.select.Elements, org.jsoup.nodes.Element, org.jsoup.Jsoup, org.jsoup.nodes.Document"%><cs:ftcs><ics:if condition='<%=ics.GetVar("seid") != null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry" /></ics:then></ics:if><ics:if condition='<%=ics.GetVar("eid") != null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement" /></ics:then></ics:if><a href="">Download CSV file</a><ics:getvar name="tableData" /><%
	try{
		Calendar cal = Calendar.getInstance();
		String currTime = new SimpleDateFormat("HH_mm_ss").format(cal.getTime());
		String currDate = new SimpleDateFormat("yyyy_MM_dd").format(new Date());
		String fileName = "BusinessPageOwnerReport_" + currTime;
		//String downloadPath = "C:\\Users\\aakash.goplani\\JSK12Workspace\\" + ics.GetVar("site") + "\\" + currDate + "\\";
		String downloadPath = "C:\\Users\\aakash.goplani\\JSK12Workspace\\";
		
		//create sheet in a workbook
		HSSFWorkbook workBook = new HSSFWorkbook();			
		HSSFSheet excelSheet = workBook.createSheet();
		
		//set font forheader -> applicable to th
		HSSFFont headerFont = workBook.createFont();
		headerFont.setBoldweight(headerFont.BOLDWEIGHT_BOLD);
		headerFont.setFontHeightInPoints((short) 12);
		
		//set alignment and border for header(th)
		CellStyle headerStyle = workBook.createCellStyle();
		headerStyle.setFillBackgroundColor(IndexedColors.BLACK.getIndex());
		headerStyle.setAlignment(headerStyle.ALIGN_CENTER);
		headerStyle.setFont(headerFont);
		headerStyle.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
		headerStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
		headerStyle.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
		
		int rowCount = 0;
		Row header;
		Cell cell;
		String tableData =  ics.GetVar("tableData");
		Document doc = Jsoup.parse(tableData);
		
		for (Element table : doc.select("table")) {
			//rowCount++;
			// loop through all tr of table
			for (Element row : table.select("tr")) {
				// create row for each
				header = excelSheet.createRow(rowCount);
				// loop through all th
				Elements ths = row.select("th");
				int count = 0;
				for (Element element : ths) {
					// set header style
					cell = header.createCell(count);
					cell.setCellValue(element.text());
					cell.setCellStyle(headerStyle);
					count++;
				}
				// now loop through all td tag
				Elements tds = row.select("td");
				count = 0;
				for (Element element : tds) {
					// create cell for each
					cell = header.createCell(count);
					cell.setCellValue(element.text());
					count++;
				}
				rowCount++;
				// set auto size column for excel sheet
				excelSheet = workBook.getSheetAt(0);
				for (int j = 0; j < row.select("td").size(); j++) {
					excelSheet.autoSizeColumn(j);
				}
			}
		}
		ByteArrayOutputStream outByteStream = new ByteArrayOutputStream();
		workBook.write(outByteStream);
		byte[] outArray = outByteStream.toByteArray();
		response.setContentType("application/ms-excel");
		response.setContentLength(outArray.length);
		response.setHeader("Expires:", "0"); /* eliminates browser caching*/
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName + ".xls");			
		OutputStream outStream = new FileOutputStream(downloadPath + fileName + ".xls");
		outStream.write(outArray);
		outStream.flush();
	}
	catch (Exception e){
		out.println("Exception Occured: " + e.getMessage() + " " + e);
	}
%></cs:ftcs>