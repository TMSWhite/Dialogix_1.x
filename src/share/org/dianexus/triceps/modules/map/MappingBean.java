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

	private Map map;
	private String mapName;
	private Workbook wb;
	private Sheet ws;
	private String sheetName;
	private ArrayList mapTable = new ArrayList();;
	
	
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
	public boolean loadMap(){
		this.map = new Map();
		return this.map.loadMap();
	}
	public boolean loadWorkBook(Workbook wb, String sheetName){
		this.wb = wb;
		return false;
	}
	public boolean loadWorkSheet(Sheet ws){
		this.ws = ws;
		return false;
	}
	public void loadMapTable(){
		ArrayList items = map.getMapItems();
		for(int i =0; i < items.size();i++){
		MappingItemDAO mapItem = (MappingItemDAO)items.get(i);
		int sColNum = mapItem.getSourceColumn();
		int dColNum = mapItem.getDestinationColumn();
		this.mapTable.set(i, new Integer(dColNum));
		}
		
		
	}
	public boolean importFile(){
		// get cell boundaries 
		int numRows = ws.getRows();
		int numCols = ws.getColumns();
		StringBuffer schedule = new StringBuffer();
		DialogixDAOFactory ddf = DialogixDAOFactory.getDAOFactory(1);
		// get a row from the upload file
		for (int i = 0; i< numRows; i++){
		// check to make sure it is an item row
			// for each item row
			//create, map and populate an instrumentItemsDAO
			InstrumentContentsDAO iidao = ddf.getInstrumentContentsDAO();
			String[] textRow = new String[7];
			//InstrumentTranslationsDAO itdao = ddf.getInstrumentTranslationsDAO();
			for(int j=0; j<numCols;j++){
				//get cell j
				String cellData  = ws.getCell(i,j).getContents();
				// mao to 
				Integer k = (Integer)mapTable.get(j);
				switch(k.intValue()){
				
				case 0:
					break;
				case 1:
					break;
				case 2:
					break;
				case 3:
					// varNum
					iidao.setInstrumentVarNum(new Integer(cellData).intValue());
					
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
					iidao.setGroupNum(new Integer(cellData).intValue());
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
					iidao.setActionType(cellData.charAt(0));
					textRow[4]=cellData;
					
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
					iidao.setIsRequired(new Integer(cellData).intValue());
					break;
				case 20:
					//idMessage
					iidao.setIsMessage(new Integer(cellData).intValue());
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
					iidao.setAnswersNumeric(new Integer(cellData).intValue());
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
				
				}
			}
			iidao.setInstrumentContents();
			
			// also create a string buffer with the schedule text file representation of the item
		}
		// write the schedule text file
		
		return false;
	}
	String makeTextRow(String[] data){
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
	
}
