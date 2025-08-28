@RestResource(urlMapping='/Talents/*')
global class InterviewResource {
  @HttpPost
  global static List<ResponseResult> syncInterviewResult() {
    List<InterviewService.InterviewResult> results = InterviewService.parseRequest();
    List<Talent__c> updatedTalents = InterviewService.getTalentsToUpdate(
      results
    );
    List<ResponseResult> responses = InterviewService.updateTalentInterviewResult(
      updatedTalents
    );
    return responses;
  }
}