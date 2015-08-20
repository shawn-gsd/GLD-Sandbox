@isTest
private class TestPolicyParticipantController {
     static testMethod void Action(){
         
         Account accInst = new account();
         accInst.BillingCity = 'Boston';
         accInst.BillingCountry = 'United States';
         accInst.BillingState = 'Massachusetts';
         accInst.BillingPostalCode = '656565';
         accInst.ShippingPostalCode = '656565';
         accInst.BillingStreet = 'Test';
         accInst.ShippingCity = 'Boston';
         accInst.ShippingCountry = 'United States';
         accInst.ShippingStreet = 'Test';
         accInst.ShippingState = 'Massachusetts';
         accInst.PersonBirthdate = date.valueof(system.today() - 1000);
         accInst.FirstName = 'Test';
         accInst.LastName = 'Test';
         accInst.PersonEmail = 'Test@acc.com';
         accInst.Gender__c = 'Male';
         accInst.Phone = '4567897892';
         accInst.Preferred_Communication__c = 'eMail';
         accInst.Bank_Account_Number__c = '1111111111';
         accInst.Bank_Name__c = 'Test';
         accInst.Payment_Method__c = 'ETF';
         accInst.Credit_Card_Expiry_Month__c = 12;
         accInst.Credit_Card_Expiry_Year__c = 2030;
         accInst.Credit_Card_Type__c = 'Visa';
         accInst.Legal_Child__c  = TRUE;
         insert accInst;
         
         State__c stateInst = new State__c();
         stateInst.State_ID__c = 10;
         stateInst.State_Name__c = 'Montana';
         insert stateInst;
         
         Quote__c quote = new Quote__c();
         quote.Age__c = 50;
         quote.Child_Age__c = 10;
         quote.Child_Rider__c = true;
         quote.Financially_Dependent__c = true;
         quote.Gender__c = 'Male';
         quote.Include__c = True;
         quote.Inflation_Fighter__c = True;
         quote.Legal_Child__c = True;
         quote.Policy_Owner__c = accInst.id;
         quote.Quote_Nickname__c = 'TestName';
         quote.Relationship__c = 'Spouse';
         quote.Role__c = 'Owner';
         quote.Spousal_Adjustment__c = True;
         quote.State__c = '10';
         quote.Relationship__c = 'Spouse';
         insert quote;         
         
         opportunity oppInst = new opportunity();
         oppInst.Payor_Party_Age__c = 50;
         oppInst.Payor_Party_Email__c = 'test@opp.com';
         oppInst.Payor_Party_Sex__c = 'Male';
         oppInst.Payor_Party_First_Name__c = 'Test';
         oppInst.Payor_Party_Last_Name__c = 'Test';
         oppInst.Payor_Party_Phone__c = '1234567890';
         oppInst.Payment_Method__c = 'ETF';
        oppInst.Bank_Account_Number__c = '456456456';
         oppInst.Bank_Name__c = 'Test';
         oppInst.Credit_Card_Type__c = 'Visa';
         oppInst.Credit_Card_Expiry_Year__c = 2030;
         oppInst.Beneficiary_Party_Search__c = accInst.id;
         oppInst.Name = 'Test';
         oppInst.StageName = 'Test';
         oppInst.CloseDate = date.valueof(system.today() + 50);
         oppInst.Quote__c = quote.id;
         oppInst.Spousal_Adjustment__c = true; 
         oppInst.Insured_Base_Coverage_Amount__c = 2000;        
         insert oppInst;
         
         Premiums__c Premium = new Premiums__c(Premium__c = 100,Age__c = 50,Gender__c = 'Male');
         insert Premium;

         
         
         
         List<Policy_Participants__c> ppList = new List<Policy_Participants__c>();
         Policy_Participants__c ppInstPayor = new Policy_Participants__c(Role__c = 'Payor',Opportunity__c = oppInst.id,Account__c = accInst.id);
         Policy_Participants__c ppInstBen = new Policy_Participants__c(Role__c = 'Beneficiary',Opportunity__c = oppInst.id,Account__c = accInst.id);
         Policy_Participants__c ppInstOwn = new Policy_Participants__c(Role__c = 'Owner',Opportunity__c = oppInst.id,Account__c = accInst.id);
         Policy_Participants__c ppInstPrim = new Policy_Participants__c(Role__c = 'Primary Insured',Opportunity__c = oppInst.id,Account__c = accInst.id);
         Policy_Participants__c ppInstChld = new Policy_Participants__c(Role__c = 'Child',Opportunity__c = oppInst.id,Account__c = accInst.id);
         ppList.add(ppInstPayor);ppList.add(ppInstBen);ppList.add(ppInstOwn);ppList.add(ppInstPrim);ppList.add(ppInstChld);
         insert ppList;
         
         
         
         Policy_Participants__c ppInst = new Policy_Participants__c();
         Test.StartTest();
         ApexPages.StandardController controller = new ApexPages.StandardController(ppInstPayor);
         ApexPages.currentPage().getParameters().put('oppId',oppInst.Id);
         ApexPages.currentPage().getParameters().put('delPos','1');
         PolicyParticipantController testPolPartCtrl = new PolicyParticipantController(controller);
         testPolPartCtrl.methodType = 'payor';
         testPolPartCtrl.saveRecords();
         testPolPartCtrl.methodType = 'beneficiary';
         testPolPartCtrl.saveRecords();
         testPolPartCtrl.methodType = 'owner';
         testPolPartCtrl.saveRecords();
         testPolPartCtrl.methodType = 'insured';
         testPolPartCtrl.saveRecords();      
         
         testPolPartCtrl.payorPartySearch();
         testPolPartCtrl.ppForPayor.Account__c = null;
         testPolPartCtrl.payorPartySearch();
         testPolPartCtrl.sameAsOwnerInPayor = True;
         testPolPartCtrl.payorPartySearch();         
         testPolPartCtrl.ownerPayorPartySearch();
         testPolPartCtrl.sameAsOwnerInPayor = False;
         testPolPartCtrl.ownerPayorPartySearch();
                  
         testPolPartCtrl.beneficiaryPartySearch();
         testPolPartCtrl.ppForBeneficiary.Account__c = null;
         testPolPartCtrl.beneficiaryPartySearch();
         testPolPartCtrl.beneficiaryRadioValue = 'SameAsPayor';
         testPolPartCtrl.beneficiaryPartySearch();
         testPolPartCtrl.beneficiaryRadioValue = 'SameAsOwner';
         testPolPartCtrl.beneficiaryRadioFunction();    
         
         testPolPartCtrl.ownerPartySearch();
         testPolPartCtrl.ppForOwner.Account__c = null;
         testPolPartCtrl.ownerPartySearch();
         testPolPartCtrl.sameAsPayorInOwner = True;
         testPolPartCtrl.ownerPartySearch();     
         testPolPartCtrl.sameAsPayorInOwner = False;
         testPolPartCtrl.ownerPartySearch();    
         testPolPartCtrl.sameAsPayorInOwnerSearch();              
         
         testPolPartCtrl.insuredPartySearch();
         testPolPartCtrl.ppForInsured.Account__c = null;
         testPolPartCtrl.insuredPartySearch();
         testPolPartCtrl.insuredRadioValue = 'SameAsPayor';
         testPolPartCtrl.insuredPartySearch();         
         testPolPartCtrl.insuredRadioValue = 'SameAsOwner';
         testPolPartCtrl.insuredPartySearch();            

         testPolPartCtrl.calculatePremium();

         oppInst.Insured_Base_Coverage_Amount__c = null;
         testPolPartCtrl.calculatePremium();
         
         stateInst.State_Name__c = 'NotMontana';
         update stateInst;
         oppInst.Spousal_Adjustment__c = false;
         update oppInst;
         testPolPartCtrl.calculatePremium();
    

         
         testPolPartCtrl.savePolicy();
         
         testPolPartCtrl.deleteChild();
         ApexPages.currentPage().getParameters().put('delPos','0');
         testPolPartCtrl.deleteChild();
         testPolPartCtrl.saveChildParticipant();
         testPolPartCtrl.addChild();
                  
         
         Test.StopTest();
     }
     
     static testMethod void Action2(){
         
         Account accInst = new account();
         accInst.BillingCity = 'Boston';
         accInst.BillingCountry = 'United States';
         accInst.BillingState = 'Massachusetts';
         accInst.BillingPostalCode = '656565';
         accInst.ShippingPostalCode = '656565';
         accInst.BillingStreet = 'Test';
         accInst.ShippingCity = 'Boston';
         accInst.ShippingCountry = 'United States';
         accInst.ShippingStreet = 'Test';
         accInst.ShippingState = 'Massachusetts';
         accInst.PersonBirthdate = date.valueof(system.today() - 1000);
         accInst.FirstName = 'Test';
         accInst.LastName = 'Test';
         accInst.PersonEmail = 'Test@acc.com';
         accInst.Gender__c = 'Male';
         accInst.Phone = '4567897892';
         accInst.Preferred_Communication__c = 'eMail';
         accInst.Bank_Account_Number__c = '1111111111';
         accInst.Bank_Name__c = 'Test';
         accInst.Payment_Method__c = 'ETF';
         accInst.Credit_Card_Expiry_Month__c = 12;
         accInst.Credit_Card_Expiry_Year__c = 2030;
         accInst.Credit_Card_Type__c = 'Visa';
         accInst.Legal_Child__c  = TRUE;
         insert accInst;
         
         State__c stateInst = new State__c();
         stateInst.State_ID__c = 10;
         stateInst.State_Name__c = 'Montana';
         insert stateInst;
         
         Quote__c quote = new Quote__c();
         quote.Age__c = 50;
         quote.Child_Age__c = 10;
         quote.Child_Rider__c = true;
         quote.Financially_Dependent__c = true;
         quote.Gender__c = 'Male';
         quote.Include__c = True;
         quote.Inflation_Fighter__c = True;
         quote.Legal_Child__c = True;
         quote.Policy_Owner__c = accInst.id;
         quote.Quote_Nickname__c = 'TestName';
         quote.Relationship__c = 'Spouse';
         quote.Role__c = 'Owner';
         quote.Spousal_Adjustment__c = True;
         quote.State__c = '10';
         quote.Relationship__c = 'Spouse';
         insert quote;         
         
         opportunity oppInst = new opportunity();
         oppInst.Payor_Party_Age__c = 50;
         oppInst.Payor_Party_Email__c = 'test@opp.com';
         oppInst.Payor_Party_Sex__c = 'Male';
         oppInst.Payor_Party_First_Name__c = 'Test';
         oppInst.Payor_Party_Last_Name__c = 'Test';
         oppInst.Payor_Party_Phone__c = '1234567890';
         oppInst.Payment_Method__c = 'ETF';
         oppInst.Bank_Account_Number__c = '456456456';
         oppInst.Bank_Name__c = 'Test';
         oppInst.Credit_Card_Type__c = 'Visa';
         oppInst.Credit_Card_Expiry_Year__c = 2030;
         oppInst.Beneficiary_Party_Search__c = accInst.id;
         oppInst.Name = 'Test';
         oppInst.StageName = 'Test';
         oppInst.CloseDate = date.valueof(system.today() + 50);
         oppInst.Quote__c = quote.id;
         oppInst.Spousal_Adjustment__c = false; 
         insert oppInst;
         
         Premiums__c Premium = new Premiums__c(Premium__c = 100,Age__c = 50,Gender__c = 'Male');
         insert Premium;
         
         List<Policy_Participants__c> ppList = new List<Policy_Participants__c>();
         Policy_Participants__c ppInstPayor = new Policy_Participants__c(Role__c = 'Payor',Opportunity__c = oppInst.id,Account__c = accInst.id);
         Policy_Participants__c ppInstBen = new Policy_Participants__c(Role__c = 'Beneficiary',Opportunity__c = oppInst.id,Account__c = accInst.id);
         Policy_Participants__c ppInstOwn = new Policy_Participants__c(Role__c = 'Owner',Opportunity__c = oppInst.id,Account__c = accInst.id);
         Policy_Participants__c ppInstPrim = new Policy_Participants__c(Role__c = 'Primary Insured',Opportunity__c = oppInst.id,Account__c = accInst.id);
         Policy_Participants__c ppInstChld = new Policy_Participants__c(Role__c = 'Child',Opportunity__c = oppInst.id,Account__c = accInst.id);
         ppList.add(ppInstPayor);ppList.add(ppInstBen);ppList.add(ppInstOwn);ppList.add(ppInstPrim);ppList.add(ppInstChld);
         insert ppList;
         
         Policy_Participants__c ppInst = new Policy_Participants__c();
         Test.StartTest();
         ApexPages.StandardController controller = new ApexPages.StandardController(ppInstPayor);
         ApexPages.currentPage().getParameters().put('oppId',oppInst.Id);
         ApexPages.currentPage().getParameters().put('delPos','1');
         PolicyParticipantController testPolPartCtrl = new PolicyParticipantController(controller);

         testPolPartCtrl.calculatePremium();
         
         Test.StopTest();
     }     
 }