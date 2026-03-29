@isTest
public class AccountTriggerHandlerTest {
    
    @isTest
    static void testUpdateContactCount_Insert() {
        // Create test account
        Account testAccount = new Account(
            Name = 'Test Account',
            Contact_Count__c = 0
        );
        insert testAccount;
        
        // Create test contacts
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            testContacts.add(new Contact(
                FirstName = 'Contact' + i,
                LastName = 'Test',
                AccountId = testAccount.Id
            ));
        }
        insert testContacts;
        
        // Verify contact count was updated
        testAccount = [SELECT Contact_Count__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(3, testAccount.Contact_Count__c, 'Contact count should be 3');
    }
    
    @isTest
    static void testUpdateContactCount_Update() {
        // Create test account with contacts
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 2; i++) {
            testContacts.add(new Contact(
                FirstName = 'Contact' + i,
                LastName = 'Test',
                AccountId = testAccount.Id
            ));
        }
        insert testContacts;
        
        // Add another contact
        Contact additionalContact = new Contact(
            FirstName = 'Additional',
            LastName = 'Contact',
            AccountId = testAccount.Id
        );
        insert additionalContact;
        
        // Verify contact count was updated
        testAccount = [SELECT Contact_Count__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(3, testAccount.Contact_Count__c, 'Contact count should be 3 after adding contact');
    }
    
    @isTest
    static void testUpdateContactCount_Delete() {
        // Create test account with contacts
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            testContacts.add(new Contact(
                FirstName = 'Contact' + i,
                LastName = 'Test',
                AccountId = testAccount.Id
            ));
        }
        insert testContacts;
        
        // Delete one contact
        delete testContacts[0];
        
        // Verify contact count was updated
        testAccount = [SELECT Contact_Count__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(2, testAccount.Contact_Count__c, 'Contact count should be 2 after deleting contact');
    }
    
    @isTest
    static void testUpdateContactCount_NoContacts() {
        // Create test account with no contacts
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Verify contact count is 0
        testAccount = [SELECT Contact_Count__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(0, testAccount.Contact_Count__c, 'Contact count should be 0 when no contacts exist');
    }
}