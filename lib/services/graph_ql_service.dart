import 'package:graphql_flutter/graphql_flutter.dart' hide ErrorHandler;
import 'package:task_graph_ql/constants/api_constants.dart';

import '../error/error_handler.dart';


class GraphQLService {
  static GraphQLService? _instance;

  final HttpLink _link;
  final GraphQLCache _cache;

  GraphQLService._()
      : _link = HttpLink(ApiConstants.linkGraphQL),
        _cache = GraphQLCache();

  factory GraphQLService() => _instance ??= GraphQLService._();

  Future<QueryResult> query(
    String query, {
    Map<String, dynamic>? variables,
  }) async {
    final options = QueryOptions(
      document: gql(query),
      variables: variables ?? {},
    );

    return ErrorHandler.executeGraphQLRequest(
        () => GraphQLClient(link: _link, cache: _cache).query(options));
  }

  Future<QueryResult> mutation(
    String query, {
    Map<String, dynamic>? variables,
  }) async {
    final options = MutationOptions(
      document: gql(query),
      variables: variables ?? {},
    );
    return ErrorHandler.executeGraphQLRequest(
        () => GraphQLClient(link: _link, cache: _cache).mutate(options));
  }


}
