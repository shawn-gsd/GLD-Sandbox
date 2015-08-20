public class SendInfoPackController {
    public Account Account {get;set;}
    public Boolean success {get;set;}
    public String packType { get; set; }
    public String quoteIds { get; set; }
    
    public SendInfoPackController (ApexPages.StandardController sc) {
        packType = ApexPages.currentPage().getParameters().get('packType');
        quoteIds = ApexPages.currentPage().getParameters().get('quoteIds');
        Account = (Account)sc.getRecord();
        success = true;
    }

    public PageReference saveShippingAddress() {
        Savepoint sp = Database.setSavePoint();
        try {
            update Account;
            success=true;
        }catch(Exception e) {
            success=false;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            //ApexPages.addMessage(msg);
        }

        if(success){
            createTask();
        }

        if(!success){
            Database.rollBack(sp);
            return null;
        }else{
            //return new PageReference('/'+Account.Id);
        }

        return null;

    }

    public void createTask(){
        String contactId = [SELECT Id FROM Contact where AccountId = :Account.Id].Id;
        Task t = new Task();
        String subj;

        if(packType == 'info'){
            t.Type = 'Info Pack';
            subj = 'Info Pack Request';
        }else if(packType == 'quote'){
            List<Task> quoteTasks = [SELECT Id
                                 FROM Task 
                                 WHERE Status = 'Open' 
                                 AND WhoId = :contactId
                                 AND Type = 'Quote Pack'
                                 LIMIT 1];

            if(quoteTasks.size() > 0){
                t = quoteTasks[0];
            }
            List<String> quoteIdList = quoteIds.split(',',0);
            String quoteIdString = '';

            Integer x = 0;
            for(String s : quoteIds.split(',',0)){
                if(x>0){
                    quoteIdString += ',';
                } 
                quoteIdString += s;
                x++;
            }

            t.Description = quoteIdString;
            t.Type = 'Quote Pack';
            subj = 'Quote Pack Request';
        }
        
        t.WhoId = contactId;
        t.Subject = subj;
        t.Status = 'Open';

        try{
            upsert t;
        }catch(Exception e){
            success=false;
            ApexPages.addMessages(e);
        }
    }
}