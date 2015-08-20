public class PolicyParticipantController {
    public Policy_Participants__c ppForPayor{get;set;}
    public Policy_Participants__c ppForBeneficiary{get;set;}
    public Policy_Participants__c ppForOwner{get;set;}
    public Policy_Participants__c ppForInsured{get;set;}
    
    public List<SelectOption> beneficiaryRadio{get;set;}
    public String beneficiaryRadioValue {get;set;}
    public String insuredRadioValue {get;set;}
    
    public Opportunity opp{get;set;}
    public String oppId {get;set;}
    
    public Account payorAcc{get;set;}
    public Account insuredAcc{get;set;}
    public Account beneficiaryAcc{get;set;}
    public Account ownerAcc{get;set;}
    
    public Boolean sameAsOwnerInPayor {get;set;}
    public Boolean sameAsPayorInOwner {get;set;}
    
    public Decimal payorAge {get;set;}
    public Decimal ownerAge {get;set;}
    public Decimal insuredAge {get;set;}
    public Decimal beneficiaryAge {get;set;} 
    
    public String methodType {get;set;}
    public List<ChildRiderInformation> criList {get;set;}
    public List<ChildRiderInformation> criDelList {get;set;}
    public Boolean secondaryAddressFlag {get;set;}
    public Set<Decimal> ageSet;
    public String  ageString {get;set;}
    public Integer criListSize {get;set;}
    public PolicyParticipantController(ApexPages.StandardController controller) {
         beneficiaryRadio=beneficiaryRadioOptions();
         secondaryAddressFlag=False;
         oppId=ApexPages.currentPage().getParameters().get('oppId');
         if(oppId == NULL) {
             oppId=ApexPages.currentPage().getParameters().get('Id');
         }
         if(oppId != NULL) {
         
             criList=new List<ChildRiderInformation>();
             criDelList=new List<ChildRiderInformation>();
             ageSet=new Set<Decimal>();
             ageString='';
             for(Premiums__c p : [SELECT Age__c,Gender__c,Id,Premium__c FROM Premiums__c]) {
                 ageSet.add(p.Age__c); 
                 ageString+=String.valueOf(p.Age__c)+';';   
             }
             if(ageString != '') {
                 ageString.removeEnd(';');
             }
             payorAge =NULL;
             ownerAge =NULL;
             insuredAge =NULL;
             beneficiaryAge =NULL;
             
             ppForPayor=new Policy_Participants__c();
             ppForBeneficiary=new Policy_Participants__c(); 
             ppForOwner=new Policy_Participants__c();
             ppForInsured=new Policy_Participants__c();
             
             payorAcc=new Account();
             beneficiaryAcc=new Account();
             ownerAcc=new Account();
             insuredAcc=new Account();
             
             opp=[SELECT Id,AccountId,Quote__r.Policy_Owner__r.BillingCity,Quote__r.Policy_Owner__r.BillingCountry,Quote__r.Policy_Owner__r.BillingState,Quote__r.Policy_Owner__r.BillingPostalCode,Quote__r.Policy_Owner__r.ShippingStreet,Quote__r.Base_Minimum_Cover_Amount__c,Quote__r.Base_Cover_Amount__c,Inflation_Fighter__c,
                  Quote__r.Policy_Owner__r.BillingStreet,Quote__r.Policy_Owner__r.ShippingCity,Quote__r.Policy_Owner__r.ShippingCountry,Quote__r.Policy_Owner__r.ShippingPostalCode,Quote__r.Policy_Owner__r.ShippingState,Quote__r.Policy_Owner__r.Preferred_Communication__c,Quote__r.Policy_Owner__r.Title__c,Child_Rider__c,
                  Quote__r.Child_Rider_Coverage_Amount__c,Quote__r.Base_Monthly_Premium__c,Quote__r.Child_Rider_Monthly_Premium__c,Quote__r.Child_Annual_Premium__c,Quote__r.Base_Annual_Premium__c,Quote__r.Age__c,Quote__r.Gender__c,Quote__r.State__c,Quote__r.Spousal_Adjustment__c,Quote__r.Policy_Owner__r.SSN__c,
                  Quote__r.Policy_Owner__r.FirstName,Quote__r.Policy_Owner__r.LastName,Quote__r.Policy_Owner__r.Age__c,Quote__r.Policy_Owner__r.PersonEmail,Quote__r.Policy_Owner__r.Phone,Quote__r.Policy_Owner__r.PersonBirthdate,Quote__r.Policy_Owner__r.Credit_Card_Expiry_Year__c,Quote__r.Policy_Owner__r.Bank_Routing_Number__c,
                  Beneficiary_Party_Search__c,Payor_Party_Search__c,Quote__r.Policy_Owner__r.Bank_Account_Number__c,Quote__r.Policy_Owner__r.Bank_Name__c,Quote__r.Policy_Owner__r.Payment_Method__c,Quote__r.Policy_Owner__r.Credit_Card_Expiry_Month__c,Quote__r.Policy_Owner__r.Gender__c,Quote__r.Date_Of_Birth__c,
                  Quote__r.Policy_Owner__r.Credit_Card_Type__c,Quote__r.Policy_Owner__r.Legal_Child__c,Quote__r.Policy_Owner__r.Suffix__c,Child_Rider_Cover_Amount__c,Child_Annual_Premium__c,Child_Rider_Bi_weekly_Premium__c,Child_Rider_Monthly_Premium__c,Insured_Base_Coverage_Amount__c,Insured_Base_Minimum_Cover_Amount__c,
                  Base_Annual_Premium__c,Base_Monthly_Premium__c,Base_Bi_Weekly_Premium__c,Spousal_Adjustment__c FROM Opportunity WHERE Id= :oppId];
                  
             State__c state=[SELECT Id,State_ID__c,State_Name__c FROM State__c WHERE State_ID__c = :Integer.valueOf(opp.Quote__r.State__c)];
             if(state != NULL) {
                 ownerAcc.BillingState=state.State_Name__c;
             }
             insuredAcc.Gender__c=opp.Quote__r.Gender__c;
             insuredAcc.PersonBirthdate=opp.Quote__r.Date_Of_Birth__c;
             insuredAge=opp.Quote__r.Age__c;
             for( Policy_Participants__c pp : [SELECT Id,Opportunity__r.Payor_Party_Age__c,Opportunity__r.Payor_Party_Email__c,Opportunity__r.Payor_Party_Sex__c,
                                               Opportunity__r.Payor_Party_Search__c,Opportunity__r.Payor_Party_First_Name__c,Role__c,Opportunity__c,
                                               Opportunity__r.Payor_Party_Last_Name__c,Opportunity__r.Payor_Party_Phone__c,Account__c,Relation_to_Primary_Insured__c,
                                               Opportunity__r.Payment_Method__c,Opportunity__r.Bank_Account_Number__c,Opportunity__r.Bank_Name__c,Opportunity__r.Beneficiary_Party_Search__c,Account__r.Financially_Dependent__c,
                                               Opportunity__r.Credit_Card_Type__c,Opportunity__r.Credit_Card_Expiry_Year__c,Opportunity__r.Credit_Card_Expiry_Month__c,Account__r.SSN__c,Account__r.Bank_Routing_Number__c,
                                               Account__r.BillingCity,Account__r.BillingCountry,Account__r.BillingState,Account__r.BillingPostalCode,Account__r.ShippingPostalCode,Account__r.Title__c,Account__r.Secondary_City__c,
                                               Account__r.BillingStreet,Account__r.ShippingCity,Account__r.ShippingCountry,Account__r.ShippingStreet,Account__r.ShippingState,Account__r.PersonBirthdate,Account__r.Secondary_Address__c,
                                               Account__r.FirstName,Account__r.LastName,Account__r.PersonEmail,Account__r.Age__c,Account__r.Gender__c,Account__r.Phone,Account__r.Preferred_Communication__c,Account__r.Secondary_Zip__c,
                                               Account__r.Bank_Account_Number__c,Account__r.Bank_Name__c,Account__r.Payment_Method__c,Account__r.Credit_Card_Expiry_Month__c,Account__r.Credit_Card_Expiry_Year__c,Account__r.Secondary_State__c,
                                               Account__r.Credit_Card_Type__c,Account__r.Legal_Child__c,Account__r.Credit_Card_Number__c,Account__r.Suffix__c  FROM Policy_Participants__c WHERE Opportunity__c = :oppId]) { 
                 if(pp.Role__c != NULL && pp.Role__c == 'Payor') {
                       
                     ppForPayor.Id=pp.Id;  
                     ppForPayor.Role__c=pp.Role__c;
                     ppForPayor.Account__c=pp.Account__c;
                     ppForPayor.Opportunity__c=pp.Opportunity__c;
                     ppForPayor.Relation_to_Primary_Insured__c=pp.Relation_to_Primary_Insured__c;
                     if(pp.Account__c != NULL) {
                         payorAcc.Id=pp.Account__c;
                         payorAcc.BillingCity=pp.Account__r.BillingCity;
                         payorAcc.BillingCountry=pp.Account__r.BillingCountry;
                         payorAcc.BillingState=pp.Account__r.BillingState;
                         payorAcc.BillingPostalCode=pp.Account__r.BillingPostalCode;
                         payorAcc.BillingStreet=pp.Account__r.BillingStreet;
                         payorAcc.ShippingCity=pp.Account__r.ShippingCity;
                         payorAcc.ShippingCountry=pp.Account__r.ShippingCountry;
                         payorAcc.ShippingStreet=pp.Account__r.ShippingStreet;
                         payorAcc.ShippingState=pp.Account__r.ShippingState;
                         payorAcc.ShippingPostalCode=pp.Account__r.ShippingPostalCode;
                         payorAcc.FirstName=pp.Account__r.FirstName;
                         payorAcc.LastName=pp.Account__r.LastName;
                         payorAcc.Gender__c=pp.Account__r.Gender__c;
                         payorAge=pp.Account__r.Age__c;
                         payorAcc.PersonEmail=pp.Account__r.PersonEmail;
                         payorAcc.Phone=pp.Account__r.Phone;
                         payorAcc.PersonBirthdate=pp.Account__r.PersonBirthdate;
                         payorAcc.Bank_Account_Number__c=pp.Account__r.Bank_Account_Number__c;
                         payorAcc.Bank_Name__c=pp.Account__r.Bank_Name__c;
                         payorAcc.Payment_Method__c=pp.Account__r.Payment_Method__c;
                         payorAcc.Credit_Card_Expiry_Month__c=pp.Account__r.Credit_Card_Expiry_Month__c;
                         payorAcc.Credit_Card_Expiry_Year__c=pp.Account__r.Credit_Card_Expiry_Year__c;
                         payorAcc.Credit_Card_Type__c=pp.Account__r.Credit_Card_Type__c;
                         payorAcc.Credit_Card_Number__c=pp.Account__r.Credit_Card_Number__c;
                         payorAcc.Suffix__c=pp.Account__r.Suffix__c;
                         payorAcc.Title__c=pp.Account__r.Title__c;
                         payorAcc.Bank_Routing_Number__c=pp.Account__r.Bank_Routing_Number__c;
                         System.debug('___________Payor Account________________________'+payorAcc);
                     }
                 }
                 if(pp.Role__c != NULL && pp.Role__c == 'Beneficiary') {
                     ppForBeneficiary.Id=pp.Id;              
                     ppForBeneficiary.Role__c=pp.Role__c;
                     ppForBeneficiary.Account__c=pp.Account__c;
                     ppForBeneficiary.Opportunity__c=pp.Opportunity__c;
                     ppForBeneficiary.Relation_to_Primary_Insured__c=pp.Relation_to_Primary_Insured__c; 
                     if(pp.Account__c != NULL) {
                         beneficiaryAcc.Id=pp.Account__c;
                         beneficiaryAcc.BillingCity=pp.Account__r.BillingCity;
                         beneficiaryAcc.BillingCountry=pp.Account__r.BillingCountry;
                         beneficiaryAcc.BillingState=pp.Account__r.BillingState;
                         beneficiaryAcc.BillingPostalCode=pp.Account__r.BillingPostalCode;
                         beneficiaryAcc.BillingStreet=pp.Account__r.BillingStreet;
                         beneficiaryAcc.ShippingCity=pp.Account__r.ShippingCity;
                         beneficiaryAcc.ShippingCountry=pp.Account__r.ShippingCountry;
                         beneficiaryAcc.ShippingStreet=pp.Account__r.ShippingStreet;
                         beneficiaryAcc.ShippingState=pp.Account__r.ShippingState;
                         beneficiaryAcc.ShippingPostalCode=pp.Account__r.ShippingPostalCode;
                         beneficiaryAcc.FirstName=pp.Account__r.FirstName;
                         beneficiaryAcc.LastName=pp.Account__r.LastName;
                         beneficiaryAcc.Gender__c=pp.Account__r.Gender__c;
                         beneficiaryAge=pp.Account__r.Age__c;
                         beneficiaryAcc.PersonEmail=pp.Account__r.PersonEmail;
                         beneficiaryAcc.Phone=pp.Account__r.Phone;
                         beneficiaryAcc.PersonBirthdate=pp.Account__r.PersonBirthdate;
                         beneficiaryAcc.Suffix__c=pp.Account__r.Suffix__c;
                         beneficiaryAcc.Title__c=pp.Account__r.Title__c;
                         System.debug('___________Beneficiary Account________________________'+beneficiaryAcc);
                     }   
                 }
                 if(pp.Role__c != NULL && pp.Role__c == 'Owner') {
                     
                     ppForOwner.Id=pp.Id;              
                     ppForOwner.Role__c=pp.Role__c;
                     ppForOwner.Account__c=pp.Account__c;
                     ppForOwner.Opportunity__c=pp.Opportunity__c;
                     ppForOwner.Relation_to_Primary_Insured__c=pp.Relation_to_Primary_Insured__c; 
                     if(pp.Account__c != NULL) {
                         ownerAcc.Id=pp.Account__c;
                         ownerAcc.BillingCity=pp.Account__r.BillingCity;
                         ownerAcc.BillingCountry=pp.Account__r.BillingCountry;
                         ownerAcc.BillingState=pp.Account__r.BillingState;
                         ownerAcc.BillingPostalCode=pp.Account__r.BillingPostalCode;
                         ownerAcc.BillingStreet=pp.Account__r.BillingStreet;
                         ownerAcc.ShippingCity=pp.Account__r.ShippingCity;
                         ownerAcc.ShippingCountry=pp.Account__r.ShippingCountry;
                         ownerAcc.ShippingStreet=pp.Account__r.ShippingStreet;
                         ownerAcc.ShippingState=pp.Account__r.ShippingState;
                         ownerAcc.ShippingPostalCode=pp.Account__r.ShippingPostalCode;
                         ownerAcc.FirstName=pp.Account__r.FirstName;
                         ownerAcc.LastName=pp.Account__r.LastName;
                         ownerAcc.Gender__c=pp.Account__r.Gender__c;
                         ownerAge=pp.Account__r.Age__c;
                         ownerAcc.PersonEmail=pp.Account__r.PersonEmail;
                         ownerAcc.Phone=pp.Account__r.Phone;
                         ownerAcc.PersonBirthdate=pp.Account__r.PersonBirthdate;
                         ownerAcc.Suffix__c=pp.Account__r.Suffix__c;
                         ownerAcc.Title__c=pp.Account__r.Title__c;
                         ownerAcc.SSN__c=pp.Account__r.SSN__c;
                         ownerAcc.Secondary_State__c=pp.Account__r.Secondary_State__c;
                         ownerAcc.Secondary_Zip__c=pp.Account__r.Secondary_Zip__c;
                         ownerAcc.Secondary_City__c=pp.Account__r.Secondary_City__c;
                         ownerAcc.Secondary_Address__c=pp.Account__r.Secondary_Address__c;
                         System.debug('___________Owner Account________________________'+ownerAcc);
                     }
                 }
                 if(pp.Role__c != NULL && pp.Role__c == 'Primary Insured') {
                     
                     ppForInsured.Id=pp.Id;              
                     ppForInsured.Role__c=pp.Role__c;
                     ppForInsured.Account__c=pp.Account__c;
                     ppForInsured.Opportunity__c=pp.Opportunity__c;
                     ppForInsured.Relation_to_Primary_Insured__c=pp.Relation_to_Primary_Insured__c; 
                     if(pp.Account__c != NULL) {
                         insuredAcc.Id=pp.Account__c;
                         insuredAcc.BillingCity=pp.Account__r.BillingCity;
                         insuredAcc.BillingCountry=pp.Account__r.BillingCountry;
                         ownerAcc.BillingState=pp.Account__r.BillingState;
                         insuredAcc.BillingPostalCode=pp.Account__r.BillingPostalCode;
                         insuredAcc.BillingStreet=pp.Account__r.BillingStreet;
                         insuredAcc.ShippingCity=pp.Account__r.ShippingCity;
                         insuredAcc.ShippingCountry=pp.Account__r.ShippingCountry;
                         insuredAcc.ShippingStreet=pp.Account__r.ShippingStreet;
                         insuredAcc.ShippingState=pp.Account__r.ShippingState;
                         insuredAcc.ShippingPostalCode=pp.Account__r.ShippingPostalCode;
                         insuredAcc.FirstName=pp.Account__r.FirstName;
                         insuredAcc.LastName=pp.Account__r.LastName;
                         insuredAcc.Gender__c=pp.Account__r.Gender__c;
                         insuredAge=pp.Account__r.Age__c;
                         insuredAcc.PersonEmail=pp.Account__r.PersonEmail;
                         insuredAcc.Phone=pp.Account__r.Phone;
                         insuredAcc.PersonBirthdate=pp.Account__r.PersonBirthdate;
                         insuredAcc.Suffix__c=pp.Account__r.Suffix__c;
                         insuredAcc.Title__c=pp.Account__r.Title__c;
                         insuredAcc.SSN__c=pp.Account__r.SSN__c;
                         System.debug('___________Insurance Account________________________'+insuredAcc);
                     }
                     
                 }  
                 if(pp.Role__c != NULL && pp.Role__c == 'Child') {
                     
                     childRiderInformation cri=new childRiderInformation();
                     cri.ppForChild=new Policy_Participants__c();
                     cri.ppForChild=pp;
                     cri.ChildAcc=new Account();
                     cri.position=criList.size();
                     cri.childAcc.LastName=pp.Account__r.LastName;
                     cri.childAcc.FirstName=pp.Account__r.FirstName;
                     cri.childAcc.PersonBirthdate=pp.Account__r.PersonBirthdate;
                     cri.childAcc.Gender__c=pp.Account__r.Gender__c;
                     cri.childAcc.Legal_Child__c=pp.Account__r.Legal_Child__c;
                     cri.childAcc.Id=pp.Account__c;
                     cri.childAcc.Financially_Dependent__c=pp.Account__r.Financially_Dependent__c;
                     cri.position=criList.size();
                     criList.add(cri); 
                 }  
             }
         }
         if(opp != NULL && opp.Child_Rider__c == True && criList.size() == 0) { //DEFAULT CHILD RECORD
             addChild();
         }
         criListSize=criList.size();
         calculatePremium();
    }
    
    public List<SelectOption> beneficiaryRadioOptions() {
    
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('SameAsPayor','Same As Payor'));
        options.add(new SelectOption('SameAsOwner','Same As Owner'));
        return options;
    }
    
    public void deleteChild() {
        Integer delPos=Integer.valueOf(ApexPages.currentPage().getParameters().get('delPos'));
        List<ChildRiderInformation> criTempList=new List<ChildRiderInformation>();
        for(ChildRiderInformation cri:criList) {
            if(cri.position == delPos) {
                childRiderInformation criDel=new childRiderInformation();
                criDel=cri;
                criDelList.add(criDel);    
            }else {
                childRiderInformation criTemp=new childRiderInformation();
                criTemp=cri;
                if(criDelList.size() > 0 && cri.position > delPos) {
                    criTemp.position=criTemp.position-1;
                }
                criTempList.add(criTemp);
            }
        }
        criList=new List<ChildRiderInformation>() ;
        criList=criTempList;
        if(criList.size() == 0) {
            opp.Child_Rider__c=False;
        }
        criListSize=criList.size();
        calculatePremium();
        System.debug('____________delPosition_______________________'+criList);
        System.debug('____________delPosition_______________________'+delPos);
    }
    public void addChild() {
        childRiderInformation cri=new childRiderInformation();
        cri.position=criList.size();
        cri.ppForChild =new Policy_Participants__c();
        cri.childAcc=new Account();
        criList.add(cri);
        if(criList.size() > 0) {
            opp.Child_Rider__c=True;
        }
        criListSize=criList.size();
        calculatePremium();
    }
    
    public void saveRecords() {
                SavePoint sp;
            try {
                sp = Database.setSavePoint();
                List<Opportunity> oppList=[SELECT Id FROM Opportunity WHERE AccountId = :opp.AccountId AND Spousal_Adjustment__c =FALSE];
                if(!(oppList == null || oppList.size() == 0 || (oppList.size() == 1 && oppList.get(0).Id==opp.Id))) {
                   if(payorAcc.FirstName != '' && payorAcc.LastName != '') {
                        savePayorParticipant();
                    }
                    if(beneficiaryAcc.FirstName != '' && beneficiaryAcc.LastName != '') {
                        saveBeneficiaryParticipant();
                    }
                    if(ownerAcc.FirstName != '' && ownerAcc.LastName != '') {
                        saveOwnerParticipant();
                    }
                    if(insuredAcc.FirstName != '' && insuredAcc.LastName != '') {
                        saveInsuredParticipant();
                        saveChildParticipant();
                    }
                    calculatePremium();
                    savePolicy(); 
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Saved Successfully');
                    ApexPages.addMessage(msg);
                }else {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'There should be atleast one primary policy');
                    ApexPages.addMessage(msg);
                }
            }catch(Exception e) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                ApexPages.addMessage(msg);
                Database.rollback(sp);
            }   
      }
      public void saveChildParticipant() {
          
          List<Account> childAccList=new List<Account>();
          List<policy_Participants__c> ppList=new List<policy_Participants__c>();
          List<policy_Participants__c> ppDelList=new List<policy_Participants__c>();
          for(ChildRiderInformation c: criList) {
             if(c.childAcc.Legal_Child__c == False || c.childAcc.Financially_Dependent__c == False) {
                 ApexPages.currentPage().getParameters().put('delPos',String.valueOf(c.position));
                 deleteChild();
             }else {
                 childAccList.add(c.childAcc); 
             }        
          }  
          if(childAccList != NULL && childAccList.size() > 0) {  
              upsert childAccList;
          }
          for(ChildRiderInformation c: criList) {
              c.ppForChild.Account__c=childAccList.get(c.position).Id;
              c.ppForChild.Opportunity__c=oppId;   
              c.ppForChild.Role__c ='Child';
              ppList.add(c.ppForChild);
          }
          if(ppList != NULL && ppList.size() > 0) {
              upsert ppList;
          }
          if(criDelList.size() > 0) {
              for(ChildRiderInformation criDel: criDelList) {
                  if(criDel.ppForChild.Id != NULL) {
                      ppDelList.add(criDel.ppForChild); 
                  }  
              }
          }
          delete ppDelList;
          criDelList=new List<ChildRiderInformation>();
      }
      
      public void saveInsuredParticipant() {
          
              upsert insuredAcc;
              System.debug('___________opp______________'+opp);
              ppForInsured.Account__c=insuredAcc.Id;
              ppForInsured.Opportunity__c=oppId;
              ppForInsured.Role__c='Primary Insured';
              upsert ppForInsured;
              assignAgeAfterSave(ppForInsured.Id,'Primary Insured');
          
      }
      public void saveOwnerParticipant() {
          
              upsert ownerAcc;
              ppForOwner.Account__c=ownerAcc.Id;
              ppForOwner.Opportunity__c=oppId;
              ppForOwner.Role__c='Owner';
              upsert ppForOwner;
              assignAgeAfterSave(ppForOwner.Id,'Owner');
          
      }
      public void saveBeneficiaryParticipant() {
          
              upsert beneficiaryAcc;
              System.debug('___________opp______________'+opp);
              ppForBeneficiary.Account__c=beneficiaryAcc.Id;
              ppForBeneficiary.Opportunity__c=oppId;
              ppForBeneficiary.Role__c='Beneficiary';
              upsert ppForBeneficiary;
              assignAgeAfterSave(ppForBeneficiary.Id,'Beneficiary');
      }
      public void savePayorParticipant() {
          
              System.debug('Save PAYOR__________________'+payorAcc);
              upsert payorAcc;
              ppForPayor.Account__c=payorAcc.Id;
              ppForPayor.Opportunity__c=oppId;
              ppForPayor.Role__c='Payor';
              upsert ppForPayor;
              assignAgeAfterSave(ppForPayor.Id,'Payor');
          
      }
      public void assignAgeAfterSave(String ppId,String role) {
      
          System.debug('__________PPID____________________'+ppId+'____________ROLE___________________'+role);
          for(Policy_Participants__c pp:[SELECT Id,Account__r.Age__c FROM Policy_Participants__c  WHERE Id= :ppId AND Role__c= :role]) {
              if(role == 'Payor') {
                  payorAge=pp.Account__r.Age__c;    
              }else if(role == 'Owner') {
                  ownerAge=pp.Account__r.Age__c;    
              }else if(role == 'Beneficiary') {
                  beneficiaryAge=pp.Account__r.Age__c;    
              }else if(role == 'Primary Insured') {
                  insuredAge=pp.Account__r.Age__c;    
              }
          }    
      }
      public void ownerPayorPartySearch() {
          
          if(oppId != NULL && ppForPayor.Account__c == NULL && sameAsOwnerInPayor == True) {
              
              payorAcc=new Account(); 
              payorAcc=ownerAcc;  
              payorAge=ownerAge; 
              ppForPayor.Relation_to_Primary_Insured__c=ppForOwner.Relation_to_Primary_Insured__c;     
          }
      }
      public void payorPartySearch() {
          System.debug('Account_________________'+opp.Payor_Party_Search__c);
          ppForPayor.Relation_to_Primary_Insured__c=NULL; 
          payorAcc=new Account();
          payorAge=NULL;
          if(ppForPayor.Account__c != NULL) {
              
              Account acc=[SELECT Id,BillingCity,BillingCountry,BillingState,BillingPostalCode,BillingStreet,ShippingCity,ShippingCountry,ShippingStreet,ShippingState,Credit_Card_Number__c,Credit_Card_Expiry_Year__c,Suffix__c,Bank_Routing_Number__c,
              ShippingPostalCode,FirstName,LastName,Gender__c,PersonEmail,Phone,PersonBirthdate,Bank_Account_Number__c,Bank_Name__c,Payment_Method__c,Credit_Card_Expiry_Month__c,Legal_Child__c,Credit_Card_Type__c,Age__c,Title__c,SSN__c
              FROM Account WHERE Id = :ppForPayor.Account__c];
              if(acc != NULL) {
                  payorAcc=acc;
                  payorAge=acc.Age__c;
              }
          }else if(sameAsOwnerInPayor == True) {
              ownerPayorPartySearch();    
          }
      }
      
      public void beneficiaryPartySearch() {
          System.debug('_____________Beneficiary_____________');  
          ppForBeneficiary.Relation_to_Primary_Insured__c=NULL; 
          beneficiaryAcc=new Account();   
          beneficiaryAge=NULL;
          if(ppForBeneficiary.Account__c!= NULL) {
              Account acc=[SELECT Id,FirstName,LastName,Age__c,Gender__c,PersonEmail,Phone,Preferred_Communication__c,PersonBirthdate,Suffix__c,Title__c,
                          BillingCity,BillingCountry,BillingState,BillingPostalCode,BillingStreet,ShippingCity,ShippingCountry,ShippingStreet,ShippingState,ShippingPostalCode,Legal_Child__c FROM Account WHERE Id = :ppForBeneficiary.Account__c];
              if(acc != null) {
                  beneficiaryAcc=acc;
                  beneficiaryAge=acc.Age__c;
              }
          }else if(beneficiaryRadioValue != NULL && beneficiaryRadioValue != '') {
              beneficiaryRadioFunction();
          }          
      }
      public void beneficiaryRadioFunction() {
          
          if( oppId != NULL && ppForBeneficiary.Account__c == NULL && (beneficiaryRadioValue == 'SameAsPayor' || beneficiaryRadioValue == 'SameAsOwner')){
          
              ppForBeneficiary.Relation_to_Primary_Insured__c=NULL;
              beneficiaryAge=NULL;
              beneficiaryAcc =new Account();
              if(beneficiaryRadioValue == 'SameAsPayor') {
                  beneficiaryAge=payorAge;
                  beneficiaryAcc =payorAcc;
                  ppForBeneficiary.Relation_to_Primary_Insured__c=ppForPayor.Relation_to_Primary_Insured__c;
                      
              }else if(beneficiaryRadioValue == 'SameAsOwner'){
                  beneficiaryAge=ownerAge;
                  beneficiaryAcc =ownerAcc;
                  ppForBeneficiary.Relation_to_Primary_Insured__c=ppForOwner.Relation_to_Primary_Insured__c;        
              }
          }
      }
        public void ownerPartySearch() {
          System.debug('_____________Owner_____________'); 
          ownerAcc=new Account();
          ownerAge=NULL;
          ppForOwner.Relation_to_Primary_Insured__c=NULL; 
          if(ppForOwner.Account__c!= NULL) {
              Account acc=[SELECT Id,FirstName,LastName,Age__c,Gender__c,PersonEmail,Phone,Preferred_Communication__c,PersonBirthdate,Suffix__c,Title__c,Secondary_City__c,Secondary_Address__c,Secondary_Zip__c,Secondary_State__c,
                          BillingCity,SSN__c,BillingCountry,BillingState,BillingPostalCode,BillingStreet,ShippingCity,ShippingCountry,ShippingStreet,ShippingState,ShippingPostalCode,Legal_Child__c FROM Account WHERE Id = :ppForOwner.Account__c];
              if(acc != NULL) {
                  ownerAcc=acc;
                  ownerAge=acc.Age__c;
              }
          }else if(sameAsPayorInOwner != NULL && sameAsPayorInOwner == True) {
              sameAsPayorInOwnerSearch();    
          }
          
      }
      public void sameAsPayorInOwnerSearch() {
          
          if( oppId != NULL && ppForOwner.Account__c == NULL && sameAsPayorInOwner  == True ){
              ownerAcc=new Account(); 
              ownerAcc=payorAcc; 
              ownerAge=payorAge;
              ppForOwner.Relation_to_Primary_Insured__c=ppForPayor.Relation_to_Primary_Insured__c;
                   
          } 
      }
      public void insuredPartySearch() {
          System.debug('_____________Insurance_____________');  
          insuredAcc=new Account();
          insuredAge=NULL;
          ppForInsured.Relation_to_Primary_Insured__c=NULL;
          if(ppForInsured.Account__c!= NULL) {
              Account acc=[SELECT Id,FirstName,LastName,Age__c,Gender__c,PersonEmail,Phone,Preferred_Communication__c,PersonBirthdate,Suffix__c,Title__c,
                          BillingCity,SSN__c,BillingCountry,BillingState,BillingPostalCode,BillingStreet,ShippingCity,ShippingCountry,ShippingStreet,ShippingState,ShippingPostalCode,Legal_Child__c FROM Account WHERE Id = :ppForInsured.Account__c];
              if(acc != null) {
                  insuredAcc=acc;
                  insuredAge=acc.Age__c;
              }
          }else if(insuredRadioValue != NULL && insuredRadioValue != '') {
              insuredRadioFunction();    
          }
          calculatePremium();
      }
      public void insuredRadioFunction() {
          
          if( oppId != NULL && ppForInsured.Account__c == NULL && (insuredRadioValue == 'SameAsPayor' || insuredRadioValue == 'SameAsOwner')){
          
              insuredAcc =new Account();
              insuredAge=NULL;
              ppForInsured.Relation_to_Primary_Insured__c=NULL;
              if(insuredRadioValue == 'SameAsPayor') {
                  insuredAcc=payorAcc;
                  insuredAge=payorAge;
                  ppForInsured.Relation_to_Primary_Insured__c=ppForPayor.Relation_to_Primary_Insured__c; 
              }else if(insuredRadioValue == 'SameAsOwner') {
                  insuredAcc=ownerAcc;
                  insuredAge=ownerAge;
                  ppForInsured.Relation_to_Primary_Insured__c=ppForOwner.Relation_to_Primary_Insured__c;     
              }
              calculatePremium();
          }
      }
      
      public void calculatePremium() {
          System.debug('insuredAcc.PersonBirthdate ::::::::::________________________'+insuredAcc.PersonBirthdate);
          if(insuredAcc.PersonBirthdate == NULL ) {
             insuredAge=NULL;
          }else {
              insuredAge=Integer.valueOf(insuredAcc.PersonBirthdate.monthsBetween(System.today())/12);
          }
          System.debug('insuredAge::::::::::::::'+insuredAge);
          Integer childMinimumCoverage=1000;
          if(insuredAge == NULL || ownerAcc.BillingState == NULL || insuredAcc.Gender__c == NULL || !ageSet.contains(insuredAge)) {
              opp.Insured_Base_Minimum_Cover_Amount__c=NULL;
              opp.Insured_Base_Coverage_Amount__c=NULL;
              opp.Base_Annual_Premium__c=NULL;
              opp.Base_Monthly_Premium__c=NULL;
              opp.Base_Bi_Weekly_Premium__c=NULL;
              /* 8/20 Commented out by STC.
                 We want to be able to see the values from the quote as soon as we conver to policy,
                 even if the beneficiary has not been filled out yet.
              opp.Child_Rider_Monthly_Premium__c=NULL;
              opp.Child_Annual_Premium__c=NULL;
              opp.Child_Rider_Bi_Weekly_Premium__c=NULL;
              opp.Child_Rider_Cover_Amount__c =NULL;
              */
          } else {
              String query='SELECT Age__c,Gender__c,Id,Premium__c FROM Premiums__c WHERE Premium__c != NULL AND '; 
              query+='Age__c = '+insuredAge+' AND ';
              if(ownerAcc.BillingState != NULL && ownerAcc.BillingState == 'Montana') {
                  query+='Gender__c ='+'\'Male\' LIMIT 1' ;
              }else {
                  query+='Gender__c ='+'\''+insuredAcc.Gender__c+'\' LIMIT 1' ;
              }
              List<Premiums__c> premiumList=new List<Premiums__c>();
              premiumList=Database.query(query);
              if(premiumList != NULL && premiumList.size() > 0) {
                  Premiums__c premium=premiumList.get(0);
                  if(opp.Spousal_Adjustment__c == True) {
                      opp.Insured_Base_Minimum_Cover_Amount__c=(120*1000/premium.Premium__c).setScale(2);
                  }else {
                    opp.Insured_Base_Minimum_Cover_Amount__c=((120-24)*1000/premium.Premium__c).setScale(2);
                  }
                  if(opp.Insured_Base_Coverage_Amount__c == NULL) {
                      if(opp.Spousal_Adjustment__c == True) {
                          opp.Base_Monthly_Premium__c=(premium.Premium__c*opp.Insured_Base_Minimum_Cover_Amount__c /1000 *0.08333).setScale(2);
                        
                      }else {
                          opp.Base_Monthly_Premium__c=(premium.Premium__c*opp.Insured_Base_Minimum_Cover_Amount__c /1000 *0.08333 +2).setScale(2);
                      }
                      opp.Base_Annual_Premium__c=(opp.Base_Monthly_Premium__c*12).setScale(2);
                      opp.Base_Bi_Weekly_Premium__c=(opp.Base_Annual_Premium__c*0.03846).setScale(2);
                  }else {
                      if(opp.Spousal_Adjustment__c == True) { 
                          opp.Base_Monthly_Premium__c=(premium.Premium__c*opp.Insured_Base_Coverage_Amount__c  /1000 *0.08333).setScale(2);
                      }else {
                          opp.Base_Monthly_Premium__c=(premium.Premium__c*opp.Insured_Base_Coverage_Amount__c  /1000 *0.08333 +2).setScale(2);      
                      }  
                      opp.Base_Annual_Premium__c=(opp.Base_Monthly_Premium__c*12).setScale(2);  
                      opp.Base_Bi_Weekly_Premium__c=(opp.Base_Annual_Premium__c*0.03846).setScale(2); 
                  }
                  if(opp.Child_Rider__c == True) {
                      if(opp.Child_Rider_Cover_Amount__c == NULL) {
                          childMinimumCoverage=1000;
                          opp.Child_Rider_Monthly_Premium__c=(childMinimumCoverage/1000*12*0.08333).setScale(2);
                      }else {
                          opp.Child_Rider_Monthly_Premium__c=(opp.Child_Rider_Cover_Amount__c /1000*12*0.08333).setScale(2);        
                      }
                      opp.Child_Annual_Premium__c=(opp.Child_Rider_Monthly_Premium__c*12).setScale(2);
                      opp.Child_Rider_Bi_Weekly_Premium__c=(opp.Child_Annual_Premium__c*0.03846).setScale(2);
                  }else {
                      opp.Child_Annual_Premium__c=NULL; 
                      opp.Child_Rider_Bi_Weekly_Premium__c=NULL;
                      opp.Child_Rider_Monthly_Premium__c=NULL; 
                      opp.Child_Rider_Cover_Amount__c=NULL;
                  }
              }
          }
          System.debug('Base Annual Premium::::::::::::::::::::::::'+opp.Insured_Base_Minimum_Cover_Amount__c);
      }
      public void savePolicy() {
          
              upsert opp;
      }
      public void  calculateAge(String objectType) {
          try {
              if(objectType == 'Owner') {
                  if(ownerAcc.PersonBirthdate == NULL ) {
                      ownerAge=NULL;
                  }else {
                      ownerAge=Integer.valueOf(ownerAcc.PersonBirthdate.monthsBetween(System.today())/12);
                  }
              }
              
          }catch(Exception e) {
              ownerAge=NULL;    
          }
      }
      
      public void ownerSecondaryAddress() {
          String objectType=ApexPages.currentPage().getParameters().get('objectType');
          calculateAge(objectType);
          secondaryAddressFlag=True;
          if(objectType == 'Owner') {
              if(! (ownerAge != NULL && ownerAge > 65 && ownerAcc.BillingState!= NULL &&
                 (ownerAcc.BillingState.toLowerCase() == 'california' || ownerAcc.BillingState.toLowerCase() == 'florida' || ownerAcc.BillingState.toLowerCase() == 'new jersey' || ownerAcc.BillingState.toLowerCase() == 'maine' || ownerAcc.BillingState.toLowerCase() == 'vermont'  ))) {
                  secondaryAddressFlag=False;
                  ownerAcc.Secondary_City__c=NULL;
                  ownerAcc.Secondary_Address__c=NULL;
                  ownerAcc.Secondary_State__c=NULL;
                  ownerAcc.Secondary_Zip__c=NULL;
              }
          }
          System.debug('_________________________________________'+objectType);   
      }
      public void paymentType() {
          if(!(payorAcc.Payment_Method__c == 'EFT')) {
              payorAcc.Bank_Name__c=NULL;
              payorAcc.Bank_Account_Number__c=NULL;
              payorAcc.Bank_Routing_Number__c=NULL;    
          }
      }
      
      public class ChildRiderInformation {
          public Integer position {get;set;}
          public Decimal age {get;set;}
          public Policy_Participants__c ppForChild {get;set;}
          public Account childAcc {get;set;}
      } 
}