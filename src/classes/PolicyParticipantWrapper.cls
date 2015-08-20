global class PolicyParticipantWrapper implements Comparable{
	
    public Policy_Participants__c par;
    public Integer sequence;

    public Map<String,Integer> roleToHierarchyOrder = new Map<String,Integer>{
        'Primary Insured'=>1
        ,'Child'=>2
        ,'Owner'=>3
        ,'Spouse'=>4
        ,'Beneficiary'=>5
        ,'Payor'=>6
        ,'Secondary Designation'=>7
    };

    public PolicyParticipantWrapper(Policy_Participants__c par) {
		this.par = par;
	}

    global Integer compareTo(Object compareTo){
        //Cast argument to PolicyParticipantWrapper
        PolicyParticipantWrapper compareToPar = (PolicyParticipantWrapper)compareTo;

        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (roleToHierarchyOrder.get(par.Role__c) > roleToHierarchyOrder.get(compareToPar.par.Role__c)){
            // Set return value to a positive value.
            returnValue = 1;
        } else if (roleToHierarchyOrder.get(par.Role__c) < roleToHierarchyOrder.get(compareToPar.par.Role__c)) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }
}