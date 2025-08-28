public without sharing class externalContactDataTableController {

    @AuraEnabled(cacheable = true)
    public static List<Contact> getContactRecords() {
        return [SELECT ShippingCity__c, YearStarted__c FROM Contact LIMIT 20];
    }
}