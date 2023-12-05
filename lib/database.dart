// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  int? id;
  String? name;
  String? lastName;
  String? zodiacSig;
  DateTime? birthDate;
  int? age;

  User(
      {this.id,
      this.name,
      this.lastName,
      this.zodiacSig,
      this.birthDate,
      this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'last_name': lastName,
      'zodiacSig': zodiacSig,
      'birth_date': birthDate?.millisecondsSinceEpoch,
      'age': age
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['id'],
        name: map['name'],
        lastName: map['last_name'],
        zodiacSig: map['zodiacSign'],
        birthDate: DateTime.fromMillisecondsSinceEpoch(map['birth_date']),
        age: map['age']);
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  late Database _db;

  Future<Database> get db async {
    if (_db.isOpen) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            last_name TEXT,
            zodiacSign_sign TEXT,
            birth_date INTEGER,
            age INTEGER
            )
          ''');
    });
  }

  Future<void> insertUser(User user) async {
    final db = await this.db;
    await db.insert('users', user.toMap());
  }

  Future<List<User>> getAllUsers() async {
    final db = await this.db;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        lastName: maps[i]['last_name'],
        birthDate: DateTime.fromMillisecondsSinceEpoch(maps[i]['birth_date']),
      );
    });
  }
}
