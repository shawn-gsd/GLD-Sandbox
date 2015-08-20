public class QuoteGeneratorCSV_crt {
public Blob csvFileBody{get;set;}
public string csvAsString{get;set;}
public String[] csvFileLines{get;set;}
public List<Quote__c> Quotelist{get;set;}
  public QuoteGeneratorCSV_crt (){
    csvFileLines = new String[]{};
    Quotelist= New List<Quote__c>(); 
  }
  
  public void importCSVFile(){
      
           csvAsString = csvFileBody.toString();
           csvFileLines = csvAsString.split('\n'); 
            Account  Acc=new Account();
            Acc.FirstName='Quote Engine';
            
            datetime timedt=system.now();
            string datestr=string.valueOf(timedt);
            Acc.LastName=datestr;
            insert Acc;
           for(Integer i=1;i<csvFileLines.size();i++){
               Quote__c QuotelistObj = new Quote__c() ;
               string[] csvRecordData = csvFileLines[i].split(',');
               system.debug('date '+csvRecordData[0]);
               QuotelistObj.Date_Of_Birth__c=date.parse(csvRecordData[1]);
               QuotelistObj.Age__c= Decimal.valueOf(csvRecordData[2]);             
               QuotelistObj.Gender__c= Quotes_code_csv.GenderCod (csvRecordData[3]);
               QuotelistObj.State__c= Quotes_code_csv.StateCodigo(csvRecordData[4]);
               QuotelistObj.Base_Cover_Amount__c=Decimal.valueOf(csvRecordData[5]);
               QuotelistObj.Spousal_Adjustment__c=csvRecordData[6]=='Y' ? true : false;
               QuotelistObj.Child_Rider__c=csvRecordData[7]!='' ? true : false;
               QuotelistObj.Child_Rider_Coverage_Amount__c=csvRecordData[7] != '' ? Decimal.valueOf(csvRecordData[7]):0;
               QuotelistObj.Policy_Owner__c = Acc.id; 
               
                                                                                
               Quotelist.add(QuotelistObj);   
           }
        insert Quotelist;
         try{
        }
        catch (Exception e)
        {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importing data. Please make sure input csv file is correct.');
            ApexPages.addMessage(errorMessage);
        }  
        Set<String>  idsQuote= new Set<String>();

        for(Quote__c  temp:Quotelist)
        {
        idsQuote.add(temp.id);
        }

         QuoteGeneratorDataBatch Createdata= new QuoteGeneratorDataBatch (idsQuote);  
        
        Id batchInstanceId = Database.executeBatch(Createdata, 1);  
        
  }
}