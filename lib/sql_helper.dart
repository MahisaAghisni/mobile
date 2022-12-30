import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  // fungsi membuat database

  static Future<void> onCreate(sql.Database database) async {
    await database.execute("""
    CREATE TABLE list_mahasiswa (
      id Integer PRIMARY KEY AUTOINCREMENT NOT NULL,
      nim TEXT ,
      nama TEXT,
      alamat TEXT,
      telepon TEXT,
      jenisKelamin TEXT,
      foto BLOB
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('list_mahasiswa_polinema.db', version: 1,
        onCreate: (
      sql.Database database,
      int version,
    ) async {
      await onCreate(database);
    });
  }

  // tambah database
  static Future<int> add(
    String nim,
    String nama,
    String alamat,
    String telepon,
    String jenisKelamin,
    String foto,
  ) async {
    final db = await SQLHelper.db();
    final data = {
      'nim': nim,
      'nama': nama,
      'alamat': alamat,
      'telepon': telepon,
      'jenisKelamin': jenisKelamin,
      'foto': foto,
    };
    return await db.insert('list_mahasiswa', data);
  }

  // get all data
  static Future<List<Map<String, dynamic>>> get() async {
    final db = await SQLHelper.db();
    return db.query('list_mahasiswa');
  }

  

  // delete data
  static Future<void> delete(int id) async {
    final db = await SQLHelper.db();
    await db.delete('list_mahasiswa', where: "id = $id");
  }
}
