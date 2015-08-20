public with sharing class ProspectSearchController{

    public List<ProspectSearchResult> tableValues { get; set; }
    Public string firstName{get;set;}
    Public string lastName{get;set;}
    Public string Phone{get;set;}
    Public string state{get;set;} 
    public String city { get; set; }
    public String street { get; set; }
    Public date dob{get;set;}
    Public string dobStr{get;set;}
    Public string zipcode{get;set;}
    Public string redirecturl{get;set;}
    Public string nameval{get;set;}
    Public string savehaserrors{get;set;} 

    public String iId { get; set; }
    
    public List<SelectOption> sourceCodeOrganization { get; set; }
    public List<SelectOption> sourceCodeDescription { get; set; }
    public List<SelectOption> subSourceCodeDescription { get; set; }
    public List<SelectOption> statelist{ get; set; }
    
    public String sourceCodeOrg { get; set; }
    public String sourceCodeDes { get; set; }
    public String subSourceCodeDes { get; set;}
    
    public ProspectSearchController(){
        try{
            tableValues = New List<ProspectSearchResult>();
            firstName = '';
            lastName = '';
            Phone = '';
            state = '';
            zipcode = '';
            dobStr = '';
            redirecturl = '';
            nameval = '';
            street = '';
            city = '';
            savehaserrors = 'true';
            sourceCodeOrg = '';
            sourceCodeDes = '';
            subSourceCodeDes = '';
            
            phone = ApexPages.CurrentPage().getParameters().get('phone');
            iId = ApexPages.CurrentPage().getParameters().get('iId');

            sourceCodeOrganization = new List<SelectOption> ();
            sourceCodeDescription = new List<SelectOption> ();
            subSourceCodeDescription = new List<SelectOption> ();
            statelist = new List<SelectOption> ();
            
            Set<String> orgStrSet = new Set<String> ();
            Set<String> scDesStrSet = new Set<String> ();
            Set<String> subSCDesStrSet = new Set<String> ();
            
            sourceCodeOrganization.add(new SelectOption('', '--Source Code--'));
            sourceCodeDescription.add(new SelectOption('', '--Source Description--')); 
            subSourceCodeDescription.add(new SelectOption('', '--Sub Source Description--'));
            for (SourceCode__c sc : [SELECT Id, Description__c, Origination__c, RecordTypeId, RecordType.DeveloperName FROM SourceCode__c LIMIT 10000]) {
                if (sc.RecordType.DeveloperName == 'Source_Code') {
                    if (sc.Description__c != null && !orgStrSet.contains(sc.Origination__c)) {
                        sourceCodeOrganization.add(new SelectOption(sc.Origination__c, sc.Origination__c));
                        orgStrSet.add(sc.Origination__c);
                    }
                    if (sc.Origination__c != null && !scDesStrSet.contains(sc.Description__c)) {
                        sourceCodeDescription.add(new SelectOption(sc.Description__c,sc.Description__c));
                        scDesStrSet.add(sc.Description__c);
                    }
                } else if (sc.RecordType.DeveloperName == 'Sub_Source_Code') {
                    if (sc.Description__c != null && !subSCDesStrSet.contains(sc.Description__c)) {
                        subSourceCodeDescription.add(new SelectOption(sc.Description__c,sc.Description__c));
                        subSCDesStrSet.add(sc.Description__c);
                    }
                }
            }
        if(phone != null && phone != ''){
            search();
        }
        
        System.debug(':::sourceCodeOrganization:::'+sourceCodeOrganization);
        System.debug(':::sourceCodeDescription:::'+sourceCodeDescription);
        System.debug(':::subSourceCodeDescription:::'+subSourceCodeDescription );


        }catch(exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
        }
    }
    
    public PageReference redirect(){
        String pId = ApexPages.CurrentPage().getParameters().get('pId');
        if(pId != null && pId != '') return new PageReference('/' + pId);
        return null;
    }

    public void search() {
    
        try{
            if(FirstName == '' && LastName  == ''  && Phone  == ''  && state  == ''  && dob  == null  && zipcode  == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select some values for the search'));
                return;
            }
            tableValues = New List<ProspectSearchResult>();
            if (FirstName != '' || LastName != '' || Phone != '' || state != '' || zipcode  != '') {
                string qrystr = 'select id,FirstName,LastName,Phone,state,Date_of_birth__c,PostalCode from lead where IsConverted = false ';
                
                if(FirstName != '')
                    qrystr += ' and FirstName=\''+ string.escapesinglequotes(firstName) + '\'';
                    
                if(LastName != '')
                    qrystr += ' and LastName=\''+ string.escapesinglequotes(lastName) + '\'';
                    
                if(Phone != ''){
                    phone = phone.trim().replace(' ','').replace('(','').replace(')','').replace('-','').replace('+','');
                    String formattedPhone = '(' + phone.left(3) + ') ' + phone.substring(3,6) + '-' + phone.right(4);
                    phone = formattedPhone;
                    qrystr += ' and Phone=\''+string.escapesinglequotes(Phone)+ '\'';
                }    
                if(dob != null)
                    qrystr += ' and Date_of_birth__c= :dob';
                
                if(city != ''){
                    qrystr += 'AND City = \'' + string.escapeSingleQuotes(city) + '\'';
                }

                if(street != ''){
                    qrystr += 'AND Street LIKE = \'%' + string.escapeSingleQuotes(street) + '%\'';
                }

                if(state != '')
                    qrystr += '  and state=\''+string.escapesinglequotes(state)+ '\'';
                
                if (zipcode != '') {
                    qrystr += '  and PostalCode=\''+string.escapesinglequotes(zipcode)+ '\'';
                }   
                
                for(lead tempSObj:database.query(qrystr)){
                    /*string datestr = '';
                    if(tempSObj.Date_of_birth__c != null)
                        datestr = string.valueof(tempSObj.Date_of_birth__c.month()) + '-' + string.valueof(tempSObj.Date_of_birth__c.day()) + '-' + string.valueof(tempSObj.Date_of_birth__c.year());
                    tableValues.add(new ProspectSearchResult(tempSObj.id, tempSObj.FirstName,tempSObj.LastName,tempSObj.Phone,tempSObj.state,datestr,tempSObj.PostalCode, 'Lead'));
                       */ 
                    tableValues.add(new ProspectSearchResult(tempSObj,null));   
                }
            }
            List<RecordType> recTypeList = [ SELECT id from recordType 
                                              WHERE sobjectType='account' and ispersontype = true and 
                                              DeveloperName='Prospect' and isactive = true];
                                              
            if(recTypeList != null && recTypeList.size() > 0){
                String qrystr = 'select Id, FirstName,LastName,Phone,PersonBirthdate,BillingState,BillingPostalCode from Account where recordtypeid = \''+recTypeList[0].id+'\'';
                
                if(FirstName != '')
                    qrystr += ' and FirstName=\''+ string.escapesinglequotes(firstName) + '\'';
                    
                if(LastName != '')
                    qrystr += ' and LastName=\''+ string.escapesinglequotes(lastName) + '\'';
                    
                if(Phone != ''){
                    phone = phone.trim().replace(' ','').replace('(','').replace(')','').replace('-','').replace('+','');
                    String formattedPhone = '(' + phone.left(3) + ') ' + phone.substring(3,6) + '-' + phone.right(4);
                    phone = formattedPhone;
                    qrystr += ' and (Phone=\''+string.escapesinglequotes(Phone)+ '\''+
                        ' OR Phone_2__c=\''+string.escapesinglequotes(Phone)+ '\''+
                        ' OR Phone_3__c=\''+string.escapesinglequotes(Phone)+ '\')';
                } 

                if(city != ''){
                    qrystr += 'AND BillingCity = \'' + string.escapeSingleQuotes(city) + '\'';
                }

                if(street != ''){
                    qrystr += 'AND BillingStreet LIKE = \'%' + string.escapeSingleQuotes(street) + '%\'';
                }
                    
                if(dob != null)
                    qrystr += ' and PersonBirthdate= :dob';
                
                if(state != '')
                    qrystr += ' and BillingState=\''+string.escapesinglequotes(state) + '\'';
                
                if(zipcode != '')
                    qrystr += ' and BillingPostalCode=\''+string.escapesinglequotes(zipcode) + '\'';        
                    
                    
                for(Account tempSObj:database.query(qrystr)){
                     /*string datestr = '';
                    if(tempSObj.PersonBirthdate != null)
                        datestr = string.valueof(tempSObj.PersonBirthdate.month()) + '-' + string.valueof(tempSObj.PersonBirthdate.day()) + '-' + string.valueof(tempSObj.PersonBirthdate.year());
                    tableValues.add(new ProspectSearchResult(tempSObj.Id, tempSObj.FirstName,tempSObj.LastName,tempSObj.Phone,tempSObj.BillingState,datestr,tempSObj.BillingPostalCode,'Account'));
                    */
                    tableValues.add(new ProspectSearchResult(null,tempSObj)); 
                }
            }
            if(tableValues.size() == 0)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No data matched the search parameters'));
        }catch(exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
        }
    }


    public class ProspectSearchResult{
        public Id recordId { get; set; }
        public string ListFirstName{get;set;}
        public string ListLastName{get;set;}
        public string ListPhone{get;set;}
        public string ListState{get;set;}
        public string ListDob{get;set;}
        public string ListZipcode{get;set;}
        public String objectName { get; set; }
        
        public ProspectSearchResult(lead leadint,account accinst){
            try{
                string datestr = '';
                if(leadint != null){
                    this.recordId = leadint.Id;
                    this.ListFirstName = leadint.FirstName;
                    this.ListLastName = leadint.LastName;
                    this.ListPhone = leadint.Phone;
                    this.objectName = 'Lead';
                    this.ListState = leadint.State;
                    this.ListZipcode = leadint.PostalCode;
                    if(leadint.Date_of_birth__c != null)
                        datestr = string.valueof(leadint.Date_of_birth__c.month()) + '-' + string.valueof(leadint.Date_of_birth__c.day()) + '-' + string.valueof(leadint.Date_of_birth__c.year());
                    this.ListDob  = datestr;
                }    
                if(accinst != null){
                    this.recordId = accinst.Id;
                    this.ListFirstName = accinst.FirstName;
                    this.ListLastName = accinst.LastName;
                    this.ListPhone = accinst.Phone;
                    this.objectName = 'Account';
                    this.ListState = accinst.BillingState;
                    this.ListZipcode = accinst.BillingPostalCode;
                    if(accinst.PersonBirthdate != null)
                        datestr = string.valueof(accinst.PersonBirthdate.month()) + '-' + string.valueof(accinst.PersonBirthdate.day()) + '-' + string.valueof(accinst.PersonBirthdate.year());
                    this.ListDob  = datestr;
                }
            } catch (Exception ex) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
            }
        }
    }
    
    
    public PageReference updateRecord() {
        try {
            savehaserrors = 'true';
            String recId = ApexPages.currentPage().getParameters().get('recordId');
            System.debug('::::recId:::'+recId);
            System.debug('<::sourceCodeDes :::>'+sourceCodeDes +'<::sourceCodeDes::::>'+sourceCodeDes+':::' );
            System.debug('<::sourceCodeOrg :::>'+sourceCodeOrg +'<::sourceCodeOrg::::>'+sourceCodeOrg+':::' );
            System.debug('<::subSourceCodeDes:::>'+subSourceCodeDes +'<::subSourceCodeDes::::>'+subSourceCodeDes+':::' );
            
            string errstr = '';
            if(subSourceCodeDes == null){
                errstr = 'Please select a value for Sub Source Code Description.';
            }
            if(sourceCodeDes == null && sourceCodeOrg != null){
                errstr = errstr + 'Source Code Description cannot be empty when Source Code Organization has a value.';
            }
            if(sourceCodeDes != null && sourceCodeOrg == null){
                errstr = errstr + 'Source Code Organization cannot be empty when Source Code Description has a value.';
            }
            if(errstr != ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errstr));
                return null;
            }

            if (recId != null && recId != '') {
                
                if ( recId.startsWith('00Q')) {
                    if (( sourceCodeOrg != null && sourceCodeOrg != '') || (sourceCodeDes != null && sourceCodeDes != '')) {
                        Lead updateLead = new Lead(Id = recId, Source_Code__c = sourceCodeOrg != '' ? sourceCodeOrg : null,
                                     Source_Code_Description__c = sourceCodeDes != '' ? sourceCodeDes : null);
                        update updateLead;
                    }
                } else if (recId.startswith('001')) {
                    if (( sourceCodeOrg != null && sourceCodeOrg != '') || (sourceCodeDes != null && sourceCodeDes != '')) {
                        Account updateAccount = new Account(Id = recId, Source_Code__c = sourceCodeOrg != '' ? sourceCodeOrg : null, 
                                    Source_Code_Description__c = sourceCodeDes != '' ? sourceCodeDes : null);
                        update updateAccount;
                    }
                }
                
                createtask(recId,'update');
                PageReference pr = new PageReference('/'+recId);
                pr.setRedirect(false);
                return pr;
                savehaserrors = 'false';
            }
        } catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
            return null;
        }
        return null;
    }
    
    public void createtask(string recidpassed,string fromwhere){
    try{
        task taskinst = new task();
        if(fromwhere == 'update'){
            for(ProspectSearchResult temp:tableValues){
                if(temp.recordId == recidpassed){
                    DateTime d = datetime.now().addHours(3);
                    String subject = 'Call ' + d.format(); 
                    taskinst.Subject = subject;
                    if(temp.objectName  == 'Account'){
                        contact coninst = [select id from contact where accountid = :recidpassed];
                        taskinst.whoid = coninst.id;
                    }
                    else if(temp.objectName  == 'Lead'){
                        taskinst.whoid = recidpassed;
                    }
                }
            }
        }
        else{
            taskinst.whoid = recidpassed;
            taskinst.Subject = firstName;
        }
        
        taskinst.Status = 'Completed';
        taskinst.Type = 'Call';
        taskinst.Source_Code_Description__c = sourceCodeDes;
        taskinst.Sub_Source_Code__c = sourceCodeOrg;
        taskinst.Sub_Source_Description__c = subSourceCodeDes;
        taskinst.CallObject = iId;
        insert taskinst;
        nameval = taskinst.Subject;
        redirecturl = recidpassed;
        } catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
        }
    }
    
    public void newLead(){
        savehaserrors = 'true';
        try{
            if(lastName == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Last Name cannot be null'));
                return;
            }
            lead leadinst = new lead();
            leadinst.Source_Code__c = sourceCodeOrg;
            leadinst.Source_Code_Description__c = sourceCodeDes;
            leadinst.FirstName = firstName;
            leadinst.LastName = lastName;
            leadinst.Phone = Phone;
            leadinst.state = state;
            leadinst.PostalCode = zipcode;
            leadinst.Date_of_birth__c = dob;
            insert leadinst;
            
            createtask(leadinst.id,'NewLead'); 
            savehaserrors = 'false';
        } catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getmessage()));
        }
        
    }
    
    

}