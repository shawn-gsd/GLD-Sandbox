/*
 * Start Class
 *  Autor: Ricardo Parra
 * Created Date: 13/08/2015
 * Modified Date: 13/08/2015
 ** 
 */
global class QuoteGeneratorDataBatch implements Database.Batchable<sObject>, Database.Stateful 
{
    global Set<String>  setIdQuote= new Set<String>();
    global final string query;
    global String strCSV_Processed ;
    global Integer iCntQuoteAsig;  
    
    global QuoteGeneratorDataBatch (Set<String> IdQuote){
        
        iCntQuoteAsig=1;
        this.setIdQuote= IdQuote;
        
   strCSV_Processed ='ID,DOB,Age,Gender,State,Coverage,Spouse,ChildCoverage,Minimum Sum Assured,Monthly Base Premium,Child Monthly Premium,Total Monthly Premium,Error\n';


    }
    
    //Start
    global Database.querylocator start(Database.BatchableContext BC)
    {
            system.debug('--Start--');
            system.debug('--setIdQuote--'+setIdQuote);
            return Database.getQueryLocator([SELECT Age__c,Base_Annual_Premium__c,Base_Bi_Weekly_Premium__c,
            Base_Cover_Amount__c,Base_Minimum_Cover_Amount__c,Base_Monthly_Premium__c,Child_Age__c,
            Child_Annual_Premium__c,Child_Rider_Bi_Weekly_Premium__c,Child_Rider_Coverage_Amount__c,
            Child_Rider_Monthly_Premium__c,Child_Rider__c,CreatedById,CreatedDate,Date_Of_Birth__c,
            Financially_Dependent__c,Gender__c,Id,Include__c,Inflation_Fighter__c,
            IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,
            LastViewedDate,Legal_Child__c,Name,Policy_Owner__c,Quote_Nickname__c,Relationship__c,Role__c,
            Spousal_Adjustment__c,State__c,SystemModstamp FROM Quote__c where id=:setIdQuote]);
    }
       
   
    //Execute
    global void execute(Database.BatchableContext BC,List<sObject> scope)
    {    system.debug('EN --Execute--');
           
            List<Quote__c> Quote_Object= new List<Quote__c>();
     

       for(sObject s : scope){
           Quote__c c= (Quote__c)s;
           Quote_Object.add(c);
                
       }
           
           
            ApexPages.StandardController sc = new ApexPages.StandardController(Quote_Object[0]);    
            QuoteGeneratorController Controler = new QuoteGeneratorController(sc);

            Controler.methodType='validate';
            Controler.calculateMonthlyPremium();
            Controler.methodType='save';
            Controler.calculateMonthlyPremium();
       
      Quote__c result= controler.quote;
      
      system.debug('controler.quote '+controler.quote);
      string error_mesg=controler.errorMsg;
      
      decimal Total_Monthly_Premium = result.Base_Monthly_Premium__c !=null ? result.Base_Monthly_Premium__c : 0 + result.Child_Rider_Monthly_Premium__c != null ? result.Child_Rider_Monthly_Premium__c : 0;
      system.debug('strCSV_Processed  1'+strCSV_Processed );
            strCSV_Processed += '"'+iCntQuoteAsig+'","'+
            result.Date_Of_Birth__c+'","'+
            result.Age__c+'","'+
            result.Gender__c+'","'+
            result.State__c+'","'+
            result.Base_Cover_Amount__c+'","'+
            result.Spousal_Adjustment__c+'","'+
            ''+'","'+
            result.Base_Minimum_Cover_Amount__c+'","'+
            result.Base_Monthly_Premium__c+'","'+
            result.Child_Rider_Monthly_Premium__c+'","'+
            Total_Monthly_Premium+'","'+
            error_mesg+'"\n'; 
       system.debug('strCSV_Processed  2'+strCSV_Processed );
       iCntQuoteAsig++;
    }
    
    //Finish
    global void finish(Database.BatchableContext BC)
    {
        
         List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      
    // Get Email of Current logged in user
        String userEmail = UserInfo.getUserEmail();
        //String userEmail = 'ricardo@gsdcompany.com';
    
    // Step 2: Set list of people who should get the email
      List<String> sendTo = new List<String>();
      sendTo.add(userEmail);
      mail.setToAddresses(sendTo);
        
    // Step 3: Set who the email is sent from

        mail.setSenderDisplayName('Salesforce Data Load Notification');
                    
    // Step 4. Set email contents - you can use variables!
        mail.setSubject('Salesforce Quote Generator data ');
        
        
        String body = 'Hi ' + UserInfo.getName()+',<br/><br/> ';
        body +='The Data Quote creation is finished, please consult the attachment files for more information';
        mail.setHtmlBody(body);
          
        Messaging.EmailFileAttachment csvAttcSuccess = new Messaging.EmailFileAttachment();
        system.debug('strCSV_Processed  3'+strCSV_Processed );
        blob csvBlobSuccess = Blob.valueOf(strCSV_Processed);
        csvAttcSuccess.setFileName('Success.csv');
        csvAttcSuccess.setBody(csvBlobSuccess);
        
         mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttcSuccess});
         
         mails.add(mail);
         
          if (!Test.isRunningTest())
        Messaging.sendEmail(mails);
        
        system.debug('EN --finish--');
        
        list<Quote__c> listQuoteDeleate =[SELECT id,Policy_Owner__c FROM Quote__c where id=:setIdQuote limit 1];
        
        if(listQuoteDeleate.size()>0)
        {
             Account  AccDeleate=new Account();
             AccDeleate.id=listQuoteDeleate[0].Policy_Owner__c;
             Delete AccDeleate;
        
        }
        
        
    }
    
}