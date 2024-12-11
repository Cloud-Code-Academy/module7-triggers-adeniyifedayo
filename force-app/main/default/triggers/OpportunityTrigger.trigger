trigger OpportunityTrigger on Opportunity (before update, before delete) {
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) { 
            for (Opportunity opp : Trigger.new){
                if (opp.Amount < 5000){
                    opp.addError('Opportunity amount must be greater than 5000');
                }
            }

            Set <Id> oppAccountId = new Set <Id>();
            for (Opportunity updatedOpp : Trigger.new){
                oppAccountId.add(updatedOpp.AccountId);
            }
            Map<Id, Id> accountToCeoMap = new Map<Id, Id>();
            List <Contact> contactIds = [SELECT Id, AccountId FROM Contact WHERE AccountId IN :oppAccountId AND Title = 'CEO'];
            for (Contact ceo : contactIds){
                accountToCeoMap.put(ceo.AccountId, ceo.Id);
            }

            for (Opportunity oppToUpdate : Trigger.new){
                if (accountToCeoMap.containsKey(oppToUpdate.AccountId)){
                oppToUpdate.Primary_Contact__c = accountToCeoMap.get(oppToUpdate.AccountId);
                }
            }
        }
    }

    if (Trigger.isBefore) {
        if (Trigger.isDelete){
            Set<Id> accountIdsToCheck = new Set<Id>();
            for (Opportunity deleteOpp : Trigger.old) {
                accountIdsToCheck.add(deleteOpp.AccountId);
            }

            List <Account> accountsInBanking = [SELECT Id FROM Account WHERE Industry = 'Banking' AND Id IN :accountIdsToCheck];
            Set <Id> accountIds = new Set <Id>();
            for (Account acc : accountsInBanking){
            accountIds.add(acc.Id);
            }
        
            for (Opportunity oldOpp : Trigger.old){
                if (oldOpp.StageName == 'Closed Won' && accountIds.contains(oldOpp.AccountId)){
                    oldOpp.addError('Cannot delete closed opportunity for a banking account that is won');
                }
            }
        }
    }
}