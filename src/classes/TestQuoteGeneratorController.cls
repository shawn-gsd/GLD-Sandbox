@isTest
private class TestQuoteGeneratorController {
    
    static testMethod void methodTestQuoteGeneratorController(){
        
        Account[] accounts =new Account[] {
            new Account(LastName='Test Account'),
            new Account(LastName='Test Account 1')
        };    
        insert accounts; 
        Quote__c[] quotes=new Quote__c[] {
            new Quote__c(Policy_Owner__c=accounts[0].Id,Child_Rider__c=True),
            new Quote__c(Policy_Owner__c=accounts[1].Id)
        };
        insert quotes;
        State__c[] states=new State__c[] {
            new State__c(State_ID__c=01,State_Name__c='Montana',Active__c=True),
            new State__c(State_ID__c=02,State_Name__c='New York',Active__c=True)
        };
        insert states;
        Premiums__c[] premiums=new Premiums__c[] {
            new Premiums__c(Age__c=30,Gender__c='Male',Premium__c=40.31),
            new Premiums__c(Age__c=30,Gender__c='Female',Premium__c=31.94),
            new Premiums__c(Age__c=40,Gender__c='Male',Premium__c=49.87),
            new Premiums__c(Age__c=40,Gender__c='Female',Premium__c=40.57)
        };      
        insert premiums;
        ApexPages.currentPage().getParameters().put('accId',accounts[0].Id);
        ApexPages.StandardController sc = new ApexPages.standardController(quotes[0]);
        QuoteGeneratorController qgc=new QuoteGeneratorController(sc);
        
        qgc.selectedState=qgc.stateId.toPlainString();
        qgc.calculateMonthlyPremium();
        qgc.quote.Age__c=30;
        qgc.quote.Gender__c='Female';
        qgc.quote.Quote_Nickname__c='Nick name';
        qgc.calculateMonthlyPremium();
        qgc.quote.Spousal_Adjustment__c=True;
        qgc.quote.Child_Rider__c=True;
        qgc.calculateMonthlyPremium();
        qgc.quote.Child_Rider_Coverage_Amount__c=4000;
        qgc.quote.Base_Cover_Amount__c=6000;
        qgc.calculateMonthlyPremium();
        qgc.selectedState='02';
        qgc.quote.Spousal_Adjustment__c=False;
        qgc.quote.Include__c=True;
        ApexPages.currentPage().getParameters().put('methodType','Save');
        qgc.calculateMonthlyPremium();
        qgc.calculateSummary();
        ApexPages.currentPage().getParameters().put('mode','edit');
        ApexPages.currentPage().getParameters().put('quoteId',quotes[0].Id);
        QuoteGeneratorController qgc1=new QuoteGeneratorController(sc);
        QuoteGeneratorController.createOpportunity(accounts[0].Id);
        QuoteGeneratorController.createOpportunity(accounts[0].Id);
        ApexPages.currentPage().getParameters().put('mode','clone');
        ApexPages.currentPage().getParameters().put('quoteId',quotes[0].Id);
        QuoteGeneratorController qgc2=new QuoteGeneratorController(sc);

    }
}