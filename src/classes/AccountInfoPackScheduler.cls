public class AccountInfoPackScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {
        
        List<Account> accountList = new List<Account>();
        for (Account acct : [SELECT Id,FirstName,LastName,Suffix,
                                BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode,
                                ShippingStreet,ShippingCity,ShippingState,ShippingCountry,ShippingPostalCode,
                                PersonOtherStreet,PersonOtherCity,PersonOtherState,PersonOtherCountry,PersonOtherPostalCode
                            FROM Account WHERE Info_Pack_Submission_Time__c = TODAY AND Info_Pack__c = TRUE ]) {
        
            accountList.add(acct);
        } 
    }
}