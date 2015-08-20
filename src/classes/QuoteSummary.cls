public class QuoteSummary {
    public List<Quote__c> quoteList {get;set;}
    public String accountId {get;set;}
    public Decimal totalPremium {get;set;}
    public QuoteSummary() {
        quoteList=new List<Quote__c>();
    }
    public void generateSummary() {
        totalPremium=NULL;
        accountId=ApexPages.currentPage().getParameters().get('accountId');
        System.debug('________________accountId________________________'+accountId);
        if (accountId != NULL) {
            quoteList=[SELECT Id,Name,Child_Rider__c,Base_Annual_Premium__c,Child_Annual_Premium__c,Quote_Nickname__c FROM Quote__c WHERE Policy_Owner__c= :accountId AND Include__c=True];
        }
        if (quoteList != NULL && quoteList.size() > 0) {
            totalPremium=0;
            for (Quote__c q :quoteList) {
            
                if (q.Base_Annual_Premium__c != NULL) 
                totalPremium+=q.Base_Annual_Premium__c;
                if (q.Child_Rider__c == True && q.Child_Annual_Premium__c != NULL) {
                    totalPremium+=q.Child_Annual_Premium__c;    
                } 
            }    
        }
    }
}