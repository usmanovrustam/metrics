class UriUtils {
  static String makeEncodedUri(String base,
      {Map<String, dynamic>? queryParameters}) {
    // This is 99% copied from `dart:http` package, as it should be
    // the function to see there is _makeQuery
    if (queryParameters == null || queryParameters.isEmpty) {
      return base;
    }
    base = base.endsWith('/') ? base.substring(0, base.length - 1) : base;

    var result = StringBuffer();
    var separator = "";

    void writeParameter(String key, String value) {
      result.write(separator);
      separator = "&";
      result.write(Uri.encodeQueryComponent(key));
      if (value.isNotEmpty && value.isNotEmpty) {
        result.write("=");
        result.write(Uri.encodeQueryComponent(value));
      }
    }

    queryParameters.forEach((key, value) {
      if (value == null || value is String) {
        writeParameter(key, value);
      } else if (value == null ||
          value is int ||
          value is bool ||
          value is double) {
        writeParameter(key, value.toString());
      } else {
        Iterable values = value;
        for (dynamic value in values) {
          writeParameter(key, value);
        }
      }
    });

    return '$base/?${result.toString()}';
  }
}
