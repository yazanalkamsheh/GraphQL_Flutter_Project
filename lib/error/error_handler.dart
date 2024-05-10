import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';


typedef RequestFunction = Future<QueryResult> Function();

final Logger logger = Logger();

class     ErrorHandler {

  static  Future<QueryResult> executeGraphQLRequest(
      RequestFunction request) async {
    try {
      final response = await request();
      logger.d(response.data);
      return response;
    } on GraphQLError catch (error) {
      // Handle error
      logger.e('GraphQL Error: $error');
      throw Exception('GraphQL Error: $error');
    }
  }
}