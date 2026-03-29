/**
 * Trigger handler class for Account object
 * Contains the business logic for updating contact count
 */
public class AccountTriggerHandler {
    
    /**
     * Updates the Contact_Count__c field on Account records
     * @param accountIds Set of Account IDs to update
     */
    public static void updateContactCount(Set<Id> accountIds) {
        // Query to count contacts for each account
        List<AggregateResult> contactCounts = [
            SELECT AccountId, COUNT(Id) contactCount
            FROM Contact 
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ];
        
        // Create map of AccountId to contact count
        Map<Id, Integer> accountContactCountMap = new Map<Id, Integer>();
        for (AggregateResult ar : contactCounts) {
            accountContactCountMap.put((Id)ar.get('AccountId'), (Integer)ar.get('contactCount'));
        }
        
        // Prepare accounts to update
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountIds) {
            Account acc = new Account(
                Id = accountId,
                Contact_Count__c = accountContactCountMap.get(accountId) != null ? accountContactCountMap.get(accountId) : 0
            );
            accountsToUpdate.add(acc);
        }
        
        // Update accounts
        if (!accountsToUpdate.isEmpty()) {
            try {
                update accountsToUpdate;
            } catch (DmlException e) {
                System.debug('Error updating account contact counts: ' + e.getMessage());
            }
        }
    }
}