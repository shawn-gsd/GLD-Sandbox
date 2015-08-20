public class QuoteGeneratorController {

    public Quote__c quote {get;set;}
    public List<Quote__c> quoteList {get;set;}
    public List<SelectOption> states {get;set;}
    public Integer childMinimumCoverage {get;set;}
    public String selectedState{get;set;}
    public Id accountId {get;set;}
    public String errorMsg{get;set;}
    public String methodType {get;set;}
    public Decimal stateId;
    public Decimal totalPremium {get;set;}
    public String birthDate {get;set;}
    public Account account {get;set;}

    public Boolean allowSpouseQuote { get; set; }
    public String includeQuoteIdString { get; set; }

    public QuoteGeneratorController(ApexPages.StandardController controller) {
    String mode;
    Id quoId;
        if(ApexPages.currentPage() != null)
        {
                quoId=ApexPages.currentPage().getParameters().get('quoteId');
                mode=ApexPages.currentPage().getParameters().get('mode');
                accountId=ApexPages.currentPage().getParameters().get('accId');
        }
        else{
            Quote__c QuoteContoller = (Quote__c)controller.getRecord();
            quoId=QuoteContoller.id;
            mode='edit';
        }
        system.debug('quoId= '+quoId);
        quote=new Quote__c();
        states=stateOption();
        for(State__c state : [SELECT Id,State_Name__c,State_ID__c FROM State__c WHERE State_Name__c = 'Montana' LIMIT 1]) {
                stateId=state.State_ID__c;
        }
        if(quoId == NULL) {
            quoId=ApexPages.currentPage().getParameters().get('Id');
            mode='edit';
        }
        if(quoId != NULL) {
            
            Quote__c q=[SELECT Id,Base_Minimum_Cover_Amount__c,Date_Of_Birth__c,Base_Cover_Amount__c,Quote_Nickname__c,Base_Monthly_Premium__c,Child_Rider_Monthly_Premium__c,
                   Child_Rider_Coverage_Amount__c,Child_Rider__c,Policy_Owner__c,Spousal_Adjustment__c,Age__c,Child_Annual_Premium__c,Base_Annual_Premium__c,Gender__c,State__c,Include__c,Inflation_Fighter__c,Name  FROM Quote__c WHERE Id = :quoId LIMIT 1];       
            if(mode =='edit') {
                quote=q;
                if(q.Child_Rider__c == True) {
                    childMinimumCoverage =1000;
                } 
                selectedState=q.State__c;  
                if(q.Date_Of_Birth__c != NULL) {
                     birthDate=q.Date_Of_Birth__c.format();
                } 
            }else if(mode =='clone') {
                quote.Age__c=q.Age__c;
                quote.Gender__c=q.Gender__c;
                quote.State__c=q.State__c;
                selectedState=q.State__c;
                quote.Age__c=q.Age__c;
                if(q.Date_Of_Birth__c != NULL) {
                    birthDate=q.Date_Of_Birth__c.format();
                }
                calculateMonthlyPremium();
            }else if(mode == 'addNew') {
                quote.Include__c=true;
            }           
            
            accountId=q.Policy_Owner__c;
        }else  {
            quote.Include__c=True;
            birthDate = date.Today().addYears(-30).format();
        }
        if(accountId != NULL) {
           account=[SELECT Id,ShippingCity,ShippingStreet,ShippingPostalCode,ShippingCountry,ShippingState FROM Account WHERE Id = :accountId];
           calculateSummary();
        } 

        List<Quote__c> qList=[Select Id FROM Quote__c WHERE Spousal_Adjustment__c =FALSE AND Include__c = TRUE AND Policy_Owner__c = :accountId];
        if(qList == NULL || qList.size() == 0 || (qList.size() == 1 && quote.Id != NULL && qlist.get(0).Id == quote.Id)) {
            allowSpouseQuote = false;
        }else{
            allowSpouseQuote = true;
        }
    }

    public void accountAddress() {
        if(accountId != NULL) {
            account=[SELECT Id,ShippingCity,ShippingStreet,ShippingPostalCode,ShippingCountry,ShippingState FROM Account WHERE Id = :accountId];
        }
    }
    @RemoteAction
    public Static String saveAddress(String accId,String shippingStreet,String shippingCity,String shippingState,String shippingPostalCode,String shippingCountry) {
        try {
            if(accId != NULL) {
            
                Account shippingAccount=new Account();
                shippingAccount.ShippingStreet=shippingStreet;
                shippingAccount.ShippingCity=shippingCity;
                shippingAccount.ShippingState=shippingState;
                shippingAccount.ShippingPostalCode=shippingPostalCode;
                shippingAccount.ShippingCountry=shippingCountry;
                shippingAccount.Id=accId;
                upsert shippingAccount; 
                
            }
           return 'Success'; 
        }catch(Exception e) {
            System.debug('error____________');
            return e.getMessage();
        }
    }
    public PageReference calculateSummary() {
        
        totalPremium=NULL;
        quoteList=[SELECT Id,Quote_Nickname__c,Include__c,Date_Of_Birth__c,Base_Monthly_Premium__c,Child_Rider_Monthly_Premium__c,Base_Annual_Premium__c,Child_Annual_Premium__c,Child_Rider__c FROM Quote__c WHERE Policy_Owner__c = :accountId AND Include__c = True];    

        if(quoteList != NULL && quoteList.size() > 0) {
            totalPremium=0;
            Integer x = 0;
            includeQuoteIdString = '';
            for(Quote__c q:quoteList) {
                if(x>0) includeQuoteIdString += ',';
                includeQuoteIdString += q.Id;
                if(q.Base_Monthly_Premium__c!= NULL) {
                    totalPremium+=q.Base_Monthly_Premium__c;
                } 
                if(q.Child_Rider__c == True && q.Child_Rider_Monthly_Premium__c!= NULL) {
                    totalPremium+=q.Child_Rider_Monthly_Premium__c;
                }
                x++;
            }   
        }
        if(totalPremium != NULL)
        totalPremium=totalPremium.setScale(2); 
        return null;
    }
    public List<SelectOption> stateOption() {
    
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        for(State__c state : [SELECT Id,State_Name__c,State_ID__c FROM State__c]) {
            options.add(new SelectOption(state.State_ID__c.toPlainString(),state.State_Name__c));
        }
        return options;
    }
    
    public PageReference calculateMonthlyPremium() {
       
        errorMsg='';
       
        methodType=ApexPages.currentPage() !=Null ? ApexPages.currentPage().getParameters().get('methodType') : methodType;
        System.debug('-------------------selected DATE OF BIRTH ------------------------------'+birthDate );
        String[] strDate = birthDate.split('/');
        quote.Date_Of_Birth__c=Date.newInstance(Integer.valueOf(strDate[2]),Integer.valueOf(strDate[0]), Integer.valueOf(strDate[1]));
        Integer monthsBetween = quote.Date_Of_Birth__c.monthsBetween(System.today());
        System.debug('___________monthsBetween _______________________'+monthsBetween);
        quote.Age__c=Integer.valueOf(monthsBetween/12);
        String query='SELECT Age__c,Gender__c,Id,Premium__c FROM Premiums__c WHERE Premium__c != NULL AND '; 
        query+='Age__c = '+quote.Age__c+' AND ';
        System.debug('-------------------selectedState ------------------------------'+selectedState );
        System.debug('-------------------stateId------------------------------'+stateId);
        System.debug('Quote'+quote.Date_Of_Birth__c);
        if(selectedState != NULL && stateId != NULL && selectedState == stateId.toPlainString()) {
            query+='Gender__c ='+'\'Male\' LIMIT 1' ;
        }else {
            query+='Gender__c ='+'\''+quote.Gender__c+'\' LIMIT 1' ;
        }
        System.debug('<----------------QUERY--------------------->'+query);
        
        List<Premiums__c> premiumList=new List<Premiums__c>();
        premiumList=Database.query(query);
        if(premiumList != NULL && premiumList.size() > 0) {
            Premiums__c premium=premiumList.get(0);

            // Calculate base minimum coverage amount.  Must result in $10 monthly
            if(quote.Spousal_Adjustment__c) {
                quote.Base_Minimum_Cover_Amount__c=(120*1000/premium.Premium__c).setScale(2);
            }else {
                quote.Base_Minimum_Cover_Amount__c=((120-24)*1000/premium.Premium__c).setScale(2);
            }

            // If no coverage amount is selected, calculate with minimum coverage,
            // otherwise use selected amount.
            Decimal coverageAmountForCalculation;
            if(quote.Base_Cover_Amount__c == NULL){
                coverageAmountForCalculation = quote.Base_Minimum_Cover_Amount__c;
            }else{
                coverageAmountForCalculation = quote.Base_Cover_Amount__c;
            }

            // Calculate Annual Premium
            quote.Base_Annual_Premium__c = (premium.Premium__c * coverageAmountForCalculation / 1000).setScale(2);              

            // Add admin fee if the quote isn't a spouse-bundled quote
            if(!quote.Spousal_Adjustment__c) quote.Base_Annual_Premium__c += 24;

            // Calculate Monthly premium
            quote.Base_Monthly_Premium__c = (quote.Base_Annual_Premium__c * 0.08333).setScale(2);

            // Calculate Bi-Weekly Premium
            quote.Base_Bi_Weekly_Premium__c=(quote.Base_Annual_Premium__c * 0.03846).setScale(2);

            // Calculate Child Rider Amounts
            if(quote.Child_Rider__c) {
                // If no coverage amount is selected, calculate with minimum coverage,
                // otherwise use selected amount.
                Decimal childCoverageAmountForCalculation;
                if(quote.Child_Rider_Coverage_Amount__c == NULL){
                    coverageAmountForCalculation = 1000;
                    childMinimumCoverage = 1000;
                }else{
                    coverageAmountForCalculation = quote.Child_Rider_Coverage_Amount__c;
                }

                // Calculate Child Rider Annual Premium
                quote.Child_Annual_Premium__c = (coverageAmountForCalculation/1000/0.08333).setScale(2);

                // Calculate Child Rider Monthly Premium
                quote.Child_Rider_Monthly_Premium__c= (coverageAmountForCalculation/1000).setScale(2);

                //Calculate Child Rider Bi-Weekly Premium
                quote.Child_Rider_Bi_Weekly_Premium__c=(quote.Child_Annual_Premium__c*0.03846).setScale(2);
            }else {
                quote.Child_Rider_Bi_Weekly_Premium__c=NULL;
                quote.Child_Rider_Monthly_Premium__c=NULL;
                quote.Child_Annual_Premium__c=NULL;
                childMinimumCoverage=NULL;
            }

            System.debug('---------------Child_Rider_Monthly_Premium__c-------------------'+quote.Child_Rider_Monthly_Premium__c);
            if(methodType != NULL && (methodType == 'save' || methodType == 'clone' || methodType == 'addNew')) {
                
                if(accountId != null) {
                
                    quote.State__c=selectedState;
                    if(quote.Id == null) {
                    
                        quote.Policy_Owner__c=accountId; // REWRITEABLE ERROR
                    }
                    
                    upsert quote;   
                }    
            }
        }else {
            quote.Child_Rider_Monthly_Premium__c=NULL;
            quote.Child_Rider_Coverage_Amount__c=NULL;
            childMinimumCoverage=NULL;
            quote.Base_Monthly_Premium__c=NULL;
            quote.Base_Minimum_Cover_Amount__c=NULL; 
            quote.Base_Cover_Amount__c=NULL;
            quote.Base_Bi_Weekly_Premium__c=NULL;
            errorMsg='ERROR: Coverage not offered for this Age';
        } 
        System.debug('Enter-------------------------------->'+methodType);
        return null;
    }
    @RemoteAction
    public static String  createOpportunity(String accId) {
    
        String oppListString;
        List<Quote__c> quotesList =new List<Quote__c>();
        List<Opportunity> oppList=new List<Opportunity>();
        List<Policy_Participants__c> ppList=new List<Policy_Participants__c>();
        Set<Id> quoteIdSet=new Set<Id>();
        Map<Id,Id> quoteIdAndOppId=new Map<Id,Id>();
        quotesList=[SELECT Id,Quote_Nickname__c,Include__c,Base_Bi_Weekly_Premium__c,Date_Of_Birth__c,Child_Rider_Coverage_Amount__c,Base_Monthly_Premium__c,Base_Annual_Premium__c,Base_Cover_Amount__c,Base_Minimum_Cover_Amount__c,
                    Child_Rider_Bi_Weekly_Premium__c,Policy_Owner__c,Child_Rider_Monthly_Premium__c,Spousal_Adjustment__c,Child_Annual_Premium__c,Child_Rider__c FROM Quote__c WHERE Policy_Owner__c = :accId AND Include__c = True];        
        
        if(quotesList != NULL && quotesList.size() > 0) {
            for(Quote__c q:quotesList) {
                quoteIdSet.add(q.Id);    
            } 
            for(Opportunity opp:[SELECT Id,Quote__c FROM Opportunity WHERE Quote__c IN :quoteIdSet]) {
                quoteIdAndOppId.put(opp.Quote__c,opp.Id);    
            }
            for(Quote__c q:quotesList) {
                
                Opportunity opp=new Opportunity();
                if(quoteIdAndOppId.containsKey(q.Id)) {
                    opp.Id=quoteIdAndOppId.get(q.Id);
                }
                opp.Name=q.Quote_Nickname__c;
                opp.StageName='Prospecting';
                opp.CloseDate=System.today(); 
                opp.AccountId=q.Policy_Owner__c;
                opp.Insured_Base_Coverage_Amount__c=q.Base_Cover_Amount__c;
                opp.Base_Annual_Premium__c=q.Base_Annual_Premium__c;
                opp.Insured_Base_Minimum_Cover_Amount__c=q.Base_Minimum_Cover_Amount__c;
                opp.Base_Bi_Weekly_Premium__c=q.Base_Bi_Weekly_Premium__c;
                opp.Base_Monthly_Premium__c=q.Base_Monthly_Premium__c;
                opp.Child_Annual_Premium__c=q.Child_Annual_Premium__c;
                opp.Child_Rider_Cover_Amount__c=q.Child_Rider_Coverage_Amount__c;
                opp.Child_Rider_Bi_weekly_Premium__c=q.Child_Rider_Bi_Weekly_Premium__c;
                opp.Child_Rider_Monthly_Premium__c=q.Child_Rider_Monthly_Premium__c;
                opp.Spousal_Adjustment__c=q.Spousal_Adjustment__c;
                opp.Quote__c=q.Id;
                opp.Child_Rider__c = q.Child_Rider__c;
                oppList.add(opp);     
            }
            upsert oppList;
            for(Opportunity o:oppList) {
                Policy_Participants__c pp=new Policy_Participants__c();
                pp.Account__c=accId;
                pp.Opportunity__c=o.Id;
                pp.Relation_to_Primary_Insured__c='Self';
                pp.Role__c='Owner';
                ppList.add(pp);
            }
            insert ppList;
            oppListString=JSON.serialize(oppList);
        }
        return oppListString;
    }
   
}