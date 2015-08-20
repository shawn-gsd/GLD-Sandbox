public with sharing class PolicySummaryController{

    public string opportunityId{get;set;}
    public string ownerFirstName{get;set;}
    public string ownerLastName{get;set;}
    public string payorFirstName{get;set;}
    public string payorLastName{get;set;}
    public string benFirstName{get;set;}
    public string benLastName{get;set;}
    public string insuredFirstName{get;set;}
    public string insuredLastName{get;set;}    
    
    
    public list<Policy_Participants__c> PolicyParticipantsList{get;set;}
    
    public PolicySummaryController(){
        OpportunityId = '';
        OwnerFirstName = '';
        ownerLastName = '';
        payorFirstName = '';
        payorLastName = '';
        benFirstName = '';
        benLastName = '';
        insuredFirstName = '';
        insuredLastName = '';
        PolicyParticipantsList = New List<Policy_Participants__c>();
        if(ApexPages.currentPage().getParameters().get('OpportunityId') != null){
            OpportunityId = ApexPages.currentPage().getParameters().get('OpportunityId');
            PolicyParticipantsList = [ SELECT Role__c,Account__r.FirstName,Account__r.LastName 
                                        FROM Policy_Participants__c 
                                        WHERE Opportunity__c =:OpportunityId
                                        ];
            if(PolicyParticipantsList.size() > 0){
                for(Policy_Participants__c polpartemp:PolicyParticipantsList){
                    if(polpartemp.Role__c == 'Owner'){
                        ownerFirstName = polpartemp.Account__r.FirstName;
                        ownerLastName = polpartemp.Account__r.LastName;
                    }
                    if(polpartemp.Role__c == 'Primary Insured'){
                        insuredFirstName = polpartemp.Account__r.FirstName;
                        insuredLastName = polpartemp.Account__r.LastName;
                    }
                    if(polpartemp.Role__c == 'Beneficiary'){
                        benFirstName = polpartemp.Account__r.FirstName;
                        benLastName = polpartemp.Account__r.LastName;
                    }
                    if(polpartemp.Role__c == 'Payor'){
                        payorFirstName = polpartemp.Account__r.FirstName;
                        payorLastName = polpartemp.Account__r.LastName;
                    }
                }
            }
        }
        else
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Opportunity Id Not Set')); 
    }
}