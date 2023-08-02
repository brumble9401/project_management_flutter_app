class BaseListResponse<T> {
  int? status;
  String? message;
  T? data;

  BaseListResponse({
    this.status,
    this.message,
    this.data,
  });

  factory BaseListResponse.fromJson({
    required List<dynamic> json,
    Function(List<dynamic>)? dataBuilder,
  }) {
    return BaseListResponse<T>(
      data: dataBuilder != null ? dataBuilder(json) : null,
    );
  }
}
