@isTest
public class InterviewResourceTest {
  @IsTest
  static void testUpdateInterviewResultSuccessfully() {
    RestContext.request = new RestRequest();
    RestContext.request.requestBody = Blob.valueof(
      '{"interviewResults":[{"id":"a025i000006XOzvAAG","interviewResult":"fail","interviewDate":"2022-07-21 00:00:00"}]}'
    );

    Test.startTest();
    List<ResponseResult> responses = InterviewResource.syncInterviewResult();
    Test.stopTest();

    Talent__c updatedTalent = [
      SELECT Interview_Result__c, Interview_Date__c
      FROM Talent__c
    ];
    System.assertEquals('fail', updatedTalent.Interview_Result__c);
    System.assertEquals(
      Date.valueOf('2022-07-21 00:00:0'),
      updatedTalent.Interview_Date__c
    );
    System.assertEquals('Successful', responses[0].status);
    System.assertEquals('200', responses[0].statusCode);
    System.assertEquals(
      'Interview results of talent a025i000006XOzvAAG are updated successfully.',
      responses[0].statusMsg
    );
  }

  @IsTest
  static void testUpdateInterviewResultFailed() {
    RestContext.request = new RestRequest();
    RestContext.request.requestBody = Blob.valueof(
      '{"interviewResults":[{"id":"a025i000006XOzvAAA","interviewResult":"fail","interviewDate":"2022-07-21 00:00:00"}]}'
    );

    Test.startTest();
    List<ResponseResult> responses = InterviewResource.syncInterviewResult();
    Test.stopTest();

    System.assertEquals('Failed', responses[0].status);
    System.assertEquals('400', responses[0].statusCode);
    System.assertEquals(
      'Interview results of talent a025i000006XOzvAAA are updated failed.',
      responses[0].statusMsg
    );
  }
}