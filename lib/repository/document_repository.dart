// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:wordonline/constants.dart';
import 'package:wordonline/models/Error_model.dart';
import 'package:wordonline/models/document_model.dart';

final DocumentRepositoryProvider = Provider(
  (ref) => DocumentRepository(
    client: Client(),
  ),
);

class DocumentRepository {
  final Client _client;
  DocumentRepository({
    required Client client,
  }) : _client = client;

  Future<ErrorModel> createDocuments(String token) async {
    ErrorModel errorModel = ErrorModel(error: "Some Error ocurred", data: null);
    try {
      Response res = await _client.post(Uri.parse('$host/doc/create'),
          headers: {
            'content-type': 'application/json; charset=UTF-8',
            tokenKey: token
          },
          body: jsonEncode({
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          }));
      switch (res.statusCode) {
        case 200:
          errorModel =
              ErrorModel(error: null, data: DocumentModel.fromJson(res.body));
          break;
        default:
          print(errorModel.data);
          errorModel = ErrorModel(error: res.body, data: null);
      }
    } catch (e) {
      print(errorModel.data);
      print(e.toString());
    }
    return errorModel;
  }

  Future<ErrorModel> getDocuments(String token) async {
    ErrorModel errorModel =
        ErrorModel(error: "something went wrong", data: null);
    Response res = await _client.get(Uri.parse('$host/docs/me'), headers: {
      'content-type': 'application/json; charset=UTF-8',
      tokenKey: token
    });
    switch (res.statusCode) {
      case 200:
        List<DocumentModel> list = [];
        for (int i = 0; i < jsonDecode(res.body).length; i++) {
          list.add(DocumentModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
        }
        errorModel =
            ErrorModel(error: null, data: list);
        break;
      default:
        errorModel = ErrorModel(error: res.body, data: null);
    }
    return errorModel;
  }
}
