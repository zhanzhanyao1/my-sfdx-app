public without sharing class testLightingWebComponentController {

    @AuraEnabled(cacheable = true)
    public static List<Opportunity> getOppRecords() {
        return [SELECT id, TestField__c FROM Opportunity LIMIT 5];
    }
}