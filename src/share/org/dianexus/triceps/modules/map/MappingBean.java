package org.dianexus.triceps.modules.map;
import java.util.ArrayList;

import org.dianexus.triceps.modules.data.DialogixDAOFactory;
import org.dianexus.triceps.modules.data.InstrumentContentsDAO;
import org.dianexus.triceps.modules.data.InstrumentTranslationsDAO;
import org.dianexus.triceps.modules.data.MappingItemDAO;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.write.WritableWorkbook;

public class MappingBean {

	private Map contentsMap;
	private Map translationsMap;
	private String mapName;
	private Workbook wb;
	private Sheet ws;
	private String sheetName;
	private ArrayList contentsMapTable = new ArrayList();
	private ArrayList translationsMapTable = new ArrayList();
	StringBuffer schedule = new StringBuffer();
	
	
	public MappingBean(){
		
	}
	public MappingBean(Workbook wb, String sheetName){
		this.loadWorkBook(wb, sheetName);
	}
	public MappingBean(Sheet sh){
		this.loadWorkSheet(ws);
	}
	
	public void setMapName(String mapName){
		this.mapName = mapName;
	}
	public boolean loadContentsMap(){
		this.contentsMap = new Map();
		this.contentsMap.setMapName(this.mapName);
		this.contentsMap.setTableName("instrument_items");
		return this.contentsMap.loadMap();
		
	}
	public boolean loadTranslationsMap(){
		this.translationsMap = new Map();
		this.translationsMap.setMapName(this.mapName);
		this.translationsMap.setTableName("instrument_translations");
		return this.translationsMap.loadMap();
	}
	public boolean loadWorkBook(Workbook wb, String sheetName){
		this.wb = wb;
		this.sheetName = sheetName;
		this.ws = this.wb.getSheet(this.sheetName);
		return true;
	}
	public boolean loadWorkSheet(Sheet ws){
		this.ws = ws;
		return true;
	}
	public void loadContentsMapTable(){
		ArrayList items = contentsMap.getMapItems();
		System.out.println("MappingBean.loadContentsMapTable() items.size is :"+items.size());
		for(int i =0; i < items.size();i++){
		MappingItemDAO mapItem = (MappingItemDAO)items.get(i);
		int sColNum = mapItem.getSourceColumn();
		System.out.println("MappingBean.loadContentsMapTable() sColNum is :"+sColNum);
		int dColNum = mapItem.getDestinationColumn();
		System.out.println("MappingBean.loadContentsMapTable() dColNum is :"+dColNum);
		System.out.println("MappingBean.loadContentsMapTable() i  is :"+i);
		this.contentsMapTable.add(i, new Integer(dColNum));
		}
	}
		
	public void loadTranslationsMapTable(){
			ArrayList items = translationsMap.getMapItems();
			for(int i =0; i < items.size();i++){
			MappingItemDAO mapItem = (MappingItemDAO)items.get(i);
			int sColNum = mapItem.getSourceColumn();
			int dColNum = mapItem.getDestinationColumn();
			this.translationsMapTable.add(i, new Integer(dColNum));
			}
		
		
	}
	public boolean importFile(){
		if(!this.loadContentsMap()){
			System.out.println("MappingBean:importFile: loadContentsMap() FAILED");
			return false;
		}
		//if(!this.loadTranslationsMap()){
		//	System.out.println("MappingBean:importFile: loadTranslationsMap() FAILED");
		//	return false;
		//}
		this.loadContentsMapTable();
		System.out.println("MappingBean:importFile: loadContentsMapTable() OK");
		//this.loadTranslationsMapTable();
		//System.out.println("MappingBean:importFile: loadTranslationsMapTable(); OK");
		// get cell boundaries 
		int numRows = ws.getRows();
		System.out.println("num rows is "+numRows);
		int numCols = ws.getColumns();
		System.out.println("num cols is "+numCols);
		
		DialogixDAOFactory ddf = DialogixDAOFactory.getDAOFactory(1);
		// get a row from the upload file
		for (int i = 0; i< numRows; i++){
		// check to make sure it is an item row
			String cellTest  = ws.getCell(0,i).getContents();
			if(!cellTest.startsWith("RESERVED") && !cellTest.startsWith("COMMENT")){
				
				
			// for each item row
			//create, map and populate an instrumentItemsDAO
			InstrumentContentsDAO iidao = ddf.getInstrumentContentsDAO();
			InstrumentTranslationsDAO itdao = ddf.getInstrumentTranslationsDAO();
			String[] textRow = new String[7];
			
			for(int j=0; j<(numCols-1);j++){
				//get cell j
				String cellData  = ws.getCell(j,i).getContents();
				// mao to 
				System.out.println("MappingBean:importFile: in j loop j="+j+" i = "+i);
				Integer k = (Integer)contentsMapTable.get(j);
				System.out.println("MappingBean:importFile:contents of map table :k="+k.intValue());
				switch(k.intValue()){
				
				case 0:
					break;
				case 1:
					break;
				case 2:
					break;
				case 3:
					// varNum
					if(cellData != null && !cellData.equals("")){
					iidao.setInstrumentVarNum(new Integer(cellData).intValue());
					}
					break;
				case 4:
					//varName
					iidao.setInstrumentVarName(cellData);
					textRow[1]=cellData;
					break;
				case 5:
					//c8name
					iidao.setInstrumentC8Name(cellData);
					
					break;
				case 6:
					//displayName
					iidao.setDisplayName(cellData);
					textRow[2] = cellData;
					break;
				case 7:
					//groupNum
					if(cellData != null && !cellData.equals("")){
					iidao.setGroupNum(new Integer(cellData).intValue());
					}
					break;
				case 8:
					//concept
					iidao.setConcept(cellData);
					textRow[0]=cellData;
					break;
				case 9:
					//relevance
					iidao.setRelevance(cellData);
					textRow[3]= cellData;
					break;
				case 10:
					//actionType
					if(cellData != null && !cellData.equals("")){
					iidao.setActionType(cellData.charAt(0));
					textRow[4]=cellData;
					}
					
					break;
				case 11:
					//validation
					iidao.setValidation(cellData);
					break;
				case 12:
					//returnType
					iidao.setReturnType(cellData);
					break;
				case 13:
					//minVal
					iidao.setMinValue(cellData);
					break;
				case 14:
					//maxVal
					iidao.setMaxValue(cellData);
					break;
				case 15:
					//otherVals
					iidao.setOtherValues(cellData);
					break;
				case 16:
					//inputMask
					iidao.setInputMask(cellData);
					break;
				case 17:
					//formatMask
					iidao.setFormatMask(cellData);
					break;
				case 18:
					//displayType
					iidao.setDisplayType(cellData);
					break;
				case 19:
					//isRequired
					if(cellData != null && !cellData.equals("")){
					iidao.setIsRequired(new Integer(cellData).intValue());
					}
					break;
				case 20:
					//idMessage
					if(cellData != null && !cellData.equals("")){
					iidao.setIsMessage(new Integer(cellData).intValue());
					}
					break;
				case 21:
					//level
					iidao.setLevel(cellData);
					break;
				case 22:
					//spssformat
					iidao.setSPSSFormat(cellData);
					break;
				case 23:
					//sasinformat
					iidao.setSASInformat(cellData);
					break;
				case 24:
					//sasformat
					iidao.setSASFormat(cellData);
					break;
				case 25:
					//answersnumeric
					if(cellData != null && !cellData.equals("")){
					iidao.setAnswersNumeric(new Integer(cellData).intValue());
					}
					break;
				case 26:
					//defaultAnswer
					iidao.setDefaultAnswer(cellData);
					break;
				case 27:
					//defaultComment
					iidao.setDefaultComment(cellData);
					break;
				case 28:
					//LOINCProperty
					iidao.setLOINCProperty(cellData);
					break;
				case 29:
					//LOINCtimeAspect
					iidao.setLOINCTimeAspect(cellData);
					break;
				case 30:
					//LOINCsystem
					iidao.setLOINCSystem(cellData);
					break;
				case 31:
					//LOINCscale
					iidao.setLOINCScale(cellData);
					break;
				case 32:
					//LOINCmethod
					iidao.setLOINCMethod(cellData);
					break;
				case 33:
					//LOINCnum
					iidao.setLOINCNum(cellData);
					break; 
			
				default:
					break;
				
				}/*
				Integer m = (Integer)translationsMapTable.get(j);
				switch(m.intValue()){
				
				case 0:
					break;
				case 1:
					break;
				case 2:
					itdao.setInstrumentName(cellData);// example REMOVE
					break;
				case 3:
					// languageNum
					itdao.setLanguageNum(new Integer(cellData).intValue());
					break;
				case 4:
					// languageName
					itdao.setLanguageName(cellData);
					break;
				case 5:
					//varNum
					itdao.setVarNum(new Integer(cellData).intValue());
					break;
				case 6:
					//varName
					itdao.setVarName(cellData);
					break;
				case 7:
					//c8name
					itdao.setC8Name(cellData);
					break;
				case 8:
					//actionType
					itdao.setActionType(cellData.charAt(0));
					break;
				case 9:
					// readback
					itdao.setReadback(cellData);
					break;
				case 10:
					//actionPhrase
					itdao.setActionPhrase(cellData);
					textRow[5]=cellData;
				case 11:
					//displayType
					itdao.setDisplayType(cellData);
					break;
				case 12:
					//answerOptions
					itdao.setAnswerOptions(cellData);
					textRow[6]=cellData;
					break;
				case 13:
					//helpURL
					itdao.setHelpURL(cellData);
					break;
				case 14:
					//QuestionLen
					itdao.setQuestionLen(new Integer(cellData).intValue());
					break;
				case 15:
					//answerLen
					itdao.setAnswerLen(new Integer(cellData).intValue());
					break;
				case 16:
					//questionMD5
					itdao.setQuestionMD5(cellData);
					break;
				case 17:
					//answerMD5
					itdao.setAnswerMD5(cellData);
					break;
				default:
					break;
				}*/
			}
			iidao.setInstrumentName("MDS");
			iidao.setInstrumentContents();
			//itdao.setInstrumentTranslations();
			
			// also create a  file representation of the item
			writeLine(textRow);
			
		}
		}
		// write the schedule text file
		
		return false;
	}
	public String makeTextRow(String[] data){
		StringBuffer sb = new StringBuffer();
		for (int i =0; i<7;i++){
			if(i<6){
				sb.append(data[i]+"\t");
				
			}else{
				sb.append(data[i]+"\n");
			}
		}
		return sb.toString();
	}
	public void writeLine (String[] line){
		
		schedule.append(makeTextRow(line));
		
	}
	public String toString(){
		return schedule.toString();
	}
}
