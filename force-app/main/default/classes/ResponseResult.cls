global class ResponseResult {
  public String status_Code;
  public String statusMsg;
  public String status;
  public ResponseResult(String statusCode, String statusMsg, String status) {
    this.status_Code = statusCode;
    this.statusMsg = statusMsg;
    this.status = status;
  }
}