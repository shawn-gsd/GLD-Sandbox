@istest
public class TestProspectSearchController{

static testmethod void Action(){


SourceCode__c sc1 = new SourceCode__c(Description__c = 'test1',Origination__c = 'Cohort',RecordTypeId = '012550000004JYNAA2');
SourceCode__c sc2 = new SourceCode__c(Description__c = 'test2',Origination__c = 'Web Site',RecordTypeId = '012550000004JYNAA2');
SourceCode__c sc3 = new SourceCode__c(Description__c = 'test3',Origination__c = 'DM Activity',RecordTypeId = '012550000004JYSAA2');
List<SourceCode__c> scList = new List<SourceCode__c>{sc1,sc2,sc3};
insert scList;

lead leadinst = new lead(FirstName = 'test',LastName = 'test',Phone = '1234567890',state = 'ILLINOIS',Date_of_birth__c = date.valueof(system.today() - 1000),PostalCode = '60616-3793');
Account Accinst = new Account(FirstName = 'test',LastName = 'test',Phone = '1234567890',BillingState = 'ILLINOIS',PersonBirthdate = date.valueof(system.today() - 1000),BillingPostalCode = '60616-3793');
insert leadinst;insert Accinst;

ProspectSearchController ctrl = new ProspectSearchController();
ctrl.search();
ctrl.updateRecord();

ctrl.FirstName = 'test';
ctrl.LastName = 'test';
ctrl.Phone = '1234567890';
ctrl.state = 'ILLINOIS';
ctrl.dob = date.valueof(system.today() - 1000);
ctrl.zipcode = '60616-3793';

ctrl.search();

ctrl.updateRecord();
ApexPages.currentPage().getParameters().put('recordId',leadinst.id);
ctrl.subSourceCodeDes = null;
ctrl.sourceCodeDes = null;
ctrl.updateRecord();

ctrl.sourceCodeDes = 'test1';
ctrl.sourceCodeOrg = null;
ctrl.updateRecord();

ctrl.subSourceCodeDes = 'test3';
ctrl.sourceCodeOrg = 'Cohort';

ctrl.updateRecord();
ApexPages.currentPage().getParameters().put('recordId',Accinst.id);
ctrl.updateRecord();
ctrl.newLead();

delete scList;
ProspectSearchController ctrlforCatch = new ProspectSearchController();
}

}