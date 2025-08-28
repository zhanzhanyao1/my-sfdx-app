@isTest
public class talentTest {
  @TestSetup
  static void makeData() {
    Talent__c talent = new Talent__c(Skill_Set__c = 'Python');
    insert talent;
  }

  @isTest
  static void syncNewTalentSuccessful() {
    Test.setMock(HttpCalloutMock.class, new TalentHttpCalloutMock());

    Talent__c newTalent = new Talent__c(
      Skill_Set__c = 'Salesforce;English;Python'
    );
    Test.startTest();
    insert newTalent;
    Test.stopTest();

    Log__c syncLog = [SELECT StatusCode__c, Status__c, Message__c FROM Log__c];
    System.assertEquals('200', syncLog.StatusCode__c);
    System.assertEquals('Success', syncLog.Status__c);
    System.assertEquals(
      '候选人信息已经录入, 感谢您对Thoughtworks招聘的支持!',
      syncLog.Message__c
    );
  }

  @isTest
  static void syncUpdatedTalentSuccessful() {
    Test.setMock(HttpCalloutMock.class, new TalentHttpCalloutMock());

    Talent__c updatedTalent = [SELECT Id FROM Talent__c];
    updatedTalent.Skill_Set__c = 'Salesforce;English;Python';
    Test.startTest();
    update updatedTalent;
    Test.stopTest();

    Log__c syncLog = [SELECT StatusCode__c, Status__c, Message__c FROM Log__c];
    System.assertEquals('200', syncLog.StatusCode__c);
    System.assertEquals('Success', syncLog.Status__c);
    System.assertEquals(
      '候选人信息已经录入, 感谢您对Thoughtworks招聘的支持!',
      syncLog.Message__c
    );
  }

  @isTest
  static void doNotSyncNewTalentWithoutRequiredSkill() {
    Test.setMock(HttpCalloutMock.class, new TalentHttpCalloutMock());

    Talent__c newTalent = new Talent__c(Skill_Set__c = 'Salesforce;Python');
    Test.startTest();
    insert newTalent;
    Test.stopTest();

    List<Log__c> syncLog = [
      SELECT StatusCode__c, Status__c, Message__c
      FROM Log__c
    ];
    System.assertEquals(true, syncLog.isEmpty());
  }

  @isTest
  static void doNotSyncUpdatedTalentWithoutRequiredSkill() {
    Talent__c updatedTalent = [SELECT Id FROM Talent__c];
    updatedTalent.Skill_Set__c = 'English;Python';
    Test.startTest();
    update updatedTalent;
    Test.stopTest();

    List<Log__c> syncLog = [
      SELECT StatusCode__c, Status__c, Message__c
      FROM Log__c
    ];
    System.assertEquals(true, syncLog.isEmpty());
  }

  @isTest
  static void doNotSyncUpdatedTalentWithFailedInterview() {
    Talent__c updatedTalent = [SELECT Id FROM Talent__c];
    updatedTalent.Skill_Set__c = 'Salesforce;English;Python';
    updatedTalent.Interview_Result__c = 'Fail';
    Test.startTest();
    update updatedTalent;
    Test.stopTest();

    List<Log__c> syncLog = [
      SELECT StatusCode__c, Status__c, Message__c
      FROM Log__c
    ];
    System.assertEquals(true, syncLog.isEmpty());
  }
}