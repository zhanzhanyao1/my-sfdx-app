public with sharing class TalentHelper {
  private static final String INTERVIEW_FAIL = 'Fail';
  private static final String INTERVIEW_PASS = 'Pass';
  private static final String ENDPOINT = 'https://creative-wolf-wt4mrd-dev-ed.my.salesforce.com/services/apexrest/accept/AcceptTalentInfoService';
  private static List<TalentSyncCondition__mdt>  skillMetas= TalentSyncCondition__mdt.getAll().values();

  @future(callout=true)
  public static void syncTalentToTW(String body) {
    System.debug('Ready to sync talent info to TW.');
    System.debug('These are talents info that will sync to TW: ' + body);
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(ENDPOINT);
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    request.setHeader('Authorization', getToken());
    request.setBody(body);
    HttpResponse response = http.send(request);

    String res = response.getBody();
    System.debug('This is response of syncing talent info to TW: ' + res);
    saveResponse(res);
  }

  private static void saveResponse(String response) {
    Map<String, Object> jsonParse = (Map<String, Object>) JSON.deserializeUntyped(
      response
    );
    insert new Log__c(
      StatusCode__c = (String) jsonParse.get('statusCode'),
      Status__c = (String) jsonParse.get('status'),
      Message__c = (String) jsonParse.get('statusMsg')
    );
  }

  public static String populateBody(List<Talent__c> talents) {
    List<Map<String, String>> talentList = new List<Map<String, String>>();
    for (Talent__c talent : talents) {
      talentList.add(
        new Map<String, String>{
          'External_ID__c' => talent.Id,
          'LastName' => talent.Name__c,
          'Phone' => talent.Phone__c,
          'Email' => talent.Email__c,
          'Education__c' => talent.Education__c,
          'Certification__c' => talent.Certification__c,
          'Project_Experience__c' => talent.Project_Experience__c,
          'Skill_Set__c' => talent.Skill_Set__c
        }
      );
    }

    TalentInfo info = new talentInfo();
    info.talentList = talentList;
    TalentRequest re = new TalentRequest();
    re.talentInfo = info;

    return JSON.serialize(re);
  }

  private class TalentInfo {
    private String talentSource = '猎头公司';
    private List<Map<String, String>> talentList;
  }

  private class TalentRequest {
    private TalentInfo talentInfo;
  }

  private static String getToken() {
    String iss = '3MVG9pRzvMkjMb6moTHi9bK6lB6Oacpe5Aqjfrj03k0vlbEhYcnudIYtI2afFTy0QNpAsoUd7.qZ1d9uIrHpe';
    String sub = 'cduan@creative-wolf-wt4mrd.com';
    String aud = 'https://login.salesforce.com';
    String endPoint = 'https://login.salesforce.com/services/oauth2/token';
    JWTAuthFlow jwt = new JWTAuthFlow();
    String twToken = jwt.createJWT(iss, sub, aud, endPoint);
    return twToken;
  }

  public static Boolean isTalentWithRequiredSkill(Talent__c talent) {
    //meetSkillConditions
    System.debug('Checking skills.');
    Set<String> skills = new Set<String>();
    Set<String> requiredSkills = new Set<String>();

    skills.addAll(talent.Skill_Set__c.split(';'));
    for(TalentSyncCondition__mdt skillMeta : skillMetas){
      requiredSkills.add(skillMeta.Skill_Set__c);
    }
    // Integer matchedSkillNums = 0;
    for (String requiredSkill: requiredSkills){
      if(!skills.contains(requiredSkill)){
        // matchedSkillNums += 1;
        return false;
      }
    }
    return true; 
  }

  public static Boolean isQualifiedTalent(Talent__c talent) {
    System.debug('Checking interview results');
    return talent.Interview_Result__c != TalentHelper.INTERVIEW_FAIL;
  }

  public static List<Talent__c> getValidUpdate(
    Map<Id, Talent__c> newTalentMap,
    Map<Id, Talent__c> oldTalentMap
  ) {
    List<Talent__c> updatedTalents = new List<Talent__c>();
    for (Id id : newTalentMap.keySet()) {
      //
      if (
        newTalentMap.get(id).Interview_Result__c == oldTalentMap.get(id).Interview_Result__c &&
        newTalentMap.get(id).Interview_Date__c == oldTalentMap.get(id).Interview_Date__c
      ) {
        updatedTalents.add(newTalentMap.get(id));
      }
    }
    return updatedTalents;
  }
}