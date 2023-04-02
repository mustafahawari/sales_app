import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';

class DatabaseConnection {
  DatabaseConnection() {
    
    _host = dotenv.env['DB_HOST'] ?? 'localhost';
    _port = int.tryParse(dotenv.env['DB_PORT'] ?? '') ?? 5432;
    _database = dotenv.env['DB_DATABASE'] ?? 'test';
    _username = dotenv.env['DB_USERNAME'] ?? 'test';
    _password = dotenv.env['DB_PASSWORD'] ?? 'test';
    debugPrint(dotenv.env['DB_HOST']);
    debugPrint(dotenv.env['DB_PORT'].toString());
    debugPrint(dotenv.env['DB_DATABASE']);
    debugPrint(dotenv.env['DB_PASSWORD']);
  }

  // final DotEnv dotenv;
  late final String _host;
  late final int _port;
  late final String _database;
  late final String _username;
  late final String _password;
  PostgreSQLConnection? _connection;

  PostgreSQLConnection get db =>
      _connection ??= throw Exception('Database connection not initialized');

  Future<void> connect() async {
    try {
      _connection = PostgreSQLConnection(
        _host,
        _port,
        _database,
        username: _username,
        password: _password,
      );
      log('Database connection successful');
      return await _connection!.open();
    } catch (e) {
      log('Database connection failed: $e');
    }
  }

  Future<void> close() => _connection!.close();
}
