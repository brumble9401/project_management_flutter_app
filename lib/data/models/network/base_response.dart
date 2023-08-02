class BaseResponse<T> {
  int? status;
  String? message;
  T? data;

  BaseResponse({
    this.status,
    this.message,
    this.data,
  });

  factory BaseResponse.fromJson({
    required Map<String, dynamic> json,
    Function(Map<String, dynamic>)? dataBuilder,
  }) {
    return BaseResponse<T>(
      status: json['statusCode'] as int?,
      message: json['message'],
      data: dataBuilder != null ? dataBuilder(json) : null,
    );
  }
}
