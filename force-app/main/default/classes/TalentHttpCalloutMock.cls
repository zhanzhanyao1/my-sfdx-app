global class TalentHttpCalloutMock implements HttpCalloutMock {
  global HttpResponse respond(HTTPRequest request) {
    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type', 'application/json');
    response.setBody(
      '{"statusMsg" : "候选人信息已经录入, 感谢您对Thoughtworks招聘的支持!","statusCode" : "200","status" : "Success"}'
    );
    response.setStatusCode(200);
    return response;
  }
}