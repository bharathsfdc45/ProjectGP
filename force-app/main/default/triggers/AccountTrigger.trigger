/**
 * Trigger on Account object to update contact count
 * Business logic is handled in AccountTriggerHandler class
 */
trigger AccountTrigger on Account (after insert, after update, after delete, after undelete) {
    
    Set<Id> accountIds = new Set<Id>();
    
    // Collect account IDs from trigger context
    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Account acc : Trigger.new) {
            accountIds.add(acc.Id);
        }
    } else if (Trigger.isDelete) {
        for (Account acc : Trigger.old) {
            accountIds.add(acc.Id);
        }
    }
    
    // Only proceed if we have account IDs
    if (!accountIds.isEmpty()) {
        AccountTriggerHandler.updateContactCount(accountIds);
    }
}