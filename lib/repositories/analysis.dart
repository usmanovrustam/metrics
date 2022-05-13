import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:metrics/repositories/utils/utils.dart';

class AnalysisRepository {
  static Future<Map<String, dynamic>> loginEmail(
    http.Client client, {
    Map<String, dynamic>? data,
  }) async {
    final response = await RepositoryUtils.fetchData(
      client,
      "https://pagespeedonline.googleapis.com/pagespeedonline/v5/runPagespeed",
      data: data,
    );

    // Parse response.
    var body = json.decode(response.body);

    return body;
  }
}
