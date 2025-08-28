trigger talentTrigger on Talent__c(after insert, after update) {

  Talent__c c = [SELECT Id FROM Talent__c WHERE Id IN :Trigger.new];




  if (Trigger.isInsert) {
    List<Talent__c> syncTalents = new List<Talent__c>();
    for (Talent__c t : Trigger.new) {
      if (isTalentWithRequiredSkill(t)) {
        syncTalents.add(t);
      }
    }
    if (!syncTalents.isEmpty()) {
      syncTalentToTW(populateBody(syncTalents));
    }
  }

  if (Trigger.isUpdate) {
    List<Talent__c> SyncTalents = new List<Talent__c>();

    List<Talent__c> updatedTalents = getValidUpdate(
      Trigger.newMap,
      Trigger.oldMap
    );

    for (Talent__c t : updatedTalents) {
      if (
        isQualifiedTalent(t) && isTalentWithRequiredSkill(t)
      ) {
        syncTalents.add(t);
      }
    }
    if (!syncTalents.isEmpty()) {
      syncTalentToTW(populateBody(syncTalents));
    }
  }

  private void syncTalentToTW(String body) {

  }

  private void saveResponse(String response) {

  }

  private String populateBody(List<Talent__c> talents) {
    return null;
  }

  private class TalentInfo {
  }

  private class TalentRequest {
  }

  private String getToken() {
    return null;
  }

  private Boolean isTalentWithRequiredSkill(Talent__c talent) {
    return null;
  }

  private Boolean isQualifiedTalent(Talent__c talent) {
    return null;
  }

  private List<Talent__c> getValidUpdate(
    Map<Id, Talent__c> newTalentMap,
    Map<Id, Talent__c> oldTalentMap
  ) {
    return null;
  }
}