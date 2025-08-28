public with sharing class Accounts {

    static void getContacts(List<Id> AccIds){
        //根据account ID找到所有account，并将下面所有contact的tag变为test
        List<Account> accList = [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN: AccIds];
        Map<Id, List<Contact>> acc2Contacts = new Map<Id, List<Contact>>{};
        for(Account acc : accList){
            if(!acc2Contacts.keySet().contains(acc.Id)){
                acc2Contacts.put(acc.Id, new List<Contact>());
            }
            acc2Contacts.get(acc.Id).add(acc.Contacts);
        }
    }

}