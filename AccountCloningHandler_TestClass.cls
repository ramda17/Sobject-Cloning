@isTest
public class AccountCloningHandler_TestClass {
//     @isTest
//     public static void cloningTestMethodForSingleAccountWithMultipleRelatedContacts() {
//         Account acc = NewCreative_TestUtility_Class.insertSingleAccountRecord(true);
//         List<Contact> contactList = NewCreative_TestUtility_Class.insertMultipleContactRecords(10, false);
//         for(Contact con : contactList) {
//             con.AccountId = acc.Id;
//         }
//         insert contactList;
//         Account cloneAccount = acc.clone(false, true, true, true);
//         Id sourceId = cloneAccount.getCloneSourceId();
//         System.debug('CloneAccount..@isTest : ===> ' + cloneAccount);
//         Test.startTest();
//             insert cloneAccount;
//         Test.stopTest();
//         List<Account> cloneAccountRecordForAssertCheck = [SELECT Id FROM Account WHERE Id =: cloneAccount.Id];
//         System.assert(!cloneAccountRecordForAssertCheck.isEmpty());
//         System.assertEquals(1, cloneAccountRecordForAssertCheck.size());
//         System.assertEquals(10, AccountRelatedContacts_CloningHandler.relatedClonedContacList.size());
//         System.assertEquals(cloneAccount.Id, AccountRelatedContacts_CloningHandler.relatedClonedContacList.get(0).AccountId);
//     }
//
//     @isTest
//     public static void cloningTestMethodForSingleAccountWithNoRelatedContacts() {
//         Account acc = NewCreative_TestUtility_Class.insertSingleAccountRecord(true);
//         Account cloneAccount = acc.clone(false, true, true, true);
//         Id sourceId = cloneAccount.getCloneSourceId();
//         System.debug('CloneAccount..@isTest : ===> ' + cloneAccount);
//         Test.startTest();
//             insert cloneAccount;
//         Test.stopTest();
//         List<Account> cloneAccountRecordForAssertCheck = [SELECT Id FROM Account WHERE Id =: cloneAccount.Id];
//         System.assert(!cloneAccountRecordForAssertCheck.isEmpty());
//         System.assertEquals(1, cloneAccountRecordForAssertCheck.size());
//         System.assertEquals(0, AccountRelatedContacts_CloningHandler.relatedClonedContacList.size());
//
//     }
//
//     @isTest
//     public static void testMethodForMultipleAccountCloning() {
//         List<Account> accountList = NewCreative_TestUtility_Class.insertMultipleAccountRecord(10, true);
//         List<Contact> contactList = new List<Contact>();
//         Integer index = 0;
//         for(Integer i=0; i<10; i++) {
//             if(index < accountList.size()) {
//                 Contact con = new Contact();
//                 con.AccountId = accountList[index].Id;
//                 con.LastName = 'Last_Name_Test_'+i;
//                 index++;
//                 contactList.add(con);
//             }
//         }
//
//         insert contactList;
//
//         List<Id> sourceIdList = new List<Id>();
//         List<Account> cloneAccountList = new List<Account>();
//
//         System.debug(contactList.size() + '@@testClass Contact size ===> ' + contactList);
//         for(Account acc : accountList) {
//             Account cloneAccount = acc.clone(false, true, true, true);
//             Id sourceId = cloneAccount.getCloneSourceId();
//             sourceIdList.add(sourceId);
//             cloneAccountList.add(cloneAccount);
//         }
//         System.debug('cloneAccountList..@isTest : ===> ' + cloneAccountList);
//         Test.startTest();
//             insert cloneAccountList;
//         Test.stopTest();
//         List<Account> cloneAccountRecordForAssertCheck = [SELECT Id FROM Account WHERE Id IN: cloneAccountList];
//         System.assert(!cloneAccountRecordForAssertCheck.isEmpty());
//         System.assertEquals(10, cloneAccountRecordForAssertCheck.size());
//         //System.assertEquals(10, AccountRelatedContacts_CloningHandler.relatedClonedContacList.size());
//         index = 0;
//         for(Account cloneAccount : cloneAccountList) {
//             if(index < 10) {
//                 System.assertEquals(cloneAccount.Id, AccountRelatedContacts_CloningHandler.relatedClonedContacList.get(index).AccountId);
//                 index++;
//             }
//         }
//     }
//
    @isTest
    public static void cloningTestMethodForSingleSObjectWithMultipleRelatedSObjects() {
        Account acc = NewCreative_TestUtility_Class.insertSingleAccountRecord(true);
        List<Contact> contactList = NewCreative_TestUtility_Class.insertMultipleContactRecords(10, false);
        for(Contact con : contactList) {
            con.AccountId = acc.Id;
        }
        insert contactList;
        List<Opportunity> opportunityList = NewCreative_TestUtility_Class.getMultipleOpportunityRecord(10, true);
        Account cloneAccount = acc.clone(false, true, true, true);
        Id sourceId = cloneAccount.getCloneSourceId();
        System.debug('CloneAccount..@isTest : ===> ' + cloneAccount);
        Test.startTest();
            insert cloneAccount;
        Test.stopTest();
        List<Account> cloneAccountRecordForAssertCheck = [SELECT Id FROM Account WHERE Id =: cloneAccount.Id];

        System.assert(!cloneAccountRecordForAssertCheck.isEmpty());
        System.assertEquals(1, cloneAccountRecordForAssertCheck.size());
        System.assertEquals(10, [SELECT COUNT() FROM Contact WHERE AccountId =: cloneAccount.Id]);
        System.assertEquals(10, [SELECT COUNT() FROM Opportunity WHERE AccountId =: cloneAccount.Id]);


        // System.assertEquals(10, AccountRelatedContacts_CloningHandler.finalClonedRelatedSObjectList.size());
        // System.assertEquals(cloneAccount.Id, AccountRelatedContacts_CloningHandler.relatedClonedContacList.get(0).AccountId);
    }
//
//
}