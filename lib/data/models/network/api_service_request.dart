class APIServiceRequest<T> {
  final String path;
  final Map<String, dynamic>? header;
  final Map<String, dynamic>? queryParams;
  final Map<String, dynamic>? dataBody;
  T Function(dynamic response) parseResponse;

  APIServiceRequest(
    this.path,
    this.parseResponse, {
    this.header,
    this.queryParams,
    this.dataBody,
  });
}
