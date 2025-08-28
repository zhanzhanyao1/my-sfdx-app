public class InterviewService {
  public static String successCode = '200';
  public static String errorCode = '400';
  public static String successStatus = 'Successful';
  public static String errorStatus = 'Failed';

  public class InterviewResult {
    public String id;
    public String interviewResult;
    public String interviewDate;
  }

  public static List<InterviewResult> parseRequest() {
    //
    Map<String, Object> jsonParse = (Map<String, Object>) JSON.deserializeUntyped(
      RestContext.request.requestBody.toString()
    );
    List<InterviewResult> results = (List<InterviewResult>) (JSON.deserialize(
      JSON.serialize(jsonParse.get('interviewResults')),
      List<InterviewResult>.class
    ));
    System.debug('Parsing interview results request successfully.');
    return results;
  }

  public static List<Talent__c> getTalentsToUpdate(
    List<InterviewResult> results
  ) {
    List<Talent__c> updateTalents = new List<Talent__c>();
    for (InterviewResult ir : results) {
      //
      System.debug('Updating the interview result of talent ' + ir.id );
      updateTalents.add(
        new Talent__c(
          id = ir.id,
          Interview_Date__c = Date.valueOf(ir.interviewDate),
          Interview_Result__c = ir.interviewResult
        )
      );
    }
    return updateTalents;
  }

  public static List<ResponseResult> updateTalentInterviewResult(
    List<Talent__c> updatedTalents
  ) {
    List<String> successfulRecords = new List<String>();
    List<String> failedRecords = new List<String>();

    Database.SaveResult[] saveResults = Database.update(updatedTalents, false);

    for (Database.SaveResult sr : saveResults) {
      if (sr.isSuccess()) {
        successfulRecords.add(sr.getId());
      } else {
        for (Database.error err : sr.getErrors()) {
          failedRecords.add(err.getMessage().substringAfterLast(': '));
        }
      }
    }
    return populateResponse(successfulRecords, failedRecords);
  }

  private static List<ResponseResult> populateResponse(
    List<String> successfulRecords,
    List<String> failedRecords
  ) {
    List<ResponseResult> responses = new List<ResponseResult>();
    String message;

    if (!successfulRecords.isEmpty()) {
      message =
        'Interview results of talent ' +
        String.join(successfulRecords, ', ') +
        ' are updated successfully.';
      ResponseResult res = new ResponseResult(
        successCode,
        message,
        successStatus
      );
      responses.add(res);
      System.debug(message);
    }

    if (!failedRecords.isEmpty()) {
      message =
        'Interview results of talent ' +
        String.join(failedRecords, ', ') +
        ' are updated failed.';
      ResponseResult res = new ResponseResult(errorCode, message, errorStatus);
      responses.add(res);
      System.debug(message);
    }
    return responses;
  }
}