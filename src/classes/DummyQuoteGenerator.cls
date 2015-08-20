public class DummyQuoteGenerator {
    
    public Quote__c quote{get;set;}
    public String quoId {get;set;}
    public String accountId{get;set;}
    public DummyQuoteGenerator(ApexPages.StandardController controller) {
        Quote__c quote=new Quote__c();
         quoId=ApexPages.currentPage().getParameters().get('Id');
        System.debug('quoId______________'+quoId);
        if( quoId != NULL) {
            quote=[SELECT Id,Policy_Owner__c FROM Quote__c WHERE Id = :quoId LIMIT 1];
            accountId=quote.Policy_Owner__c;
            System.debug('quote______________'+quote.Id);
        }
    }
}