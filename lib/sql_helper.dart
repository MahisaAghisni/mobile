import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  // fungsi membuat database

  static Future<void> onCreate(sql.Database database) async {
    await database.execute("""
    CREATE TABLE mahasiswa (
      nim TEXT PRIMARY KEY NOT NULL,
      nama TEXT,
      alamat TEXT,
      telepon TEXT,
      jenisKelamin TEXT,
      foto BLOB
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('mahasiswa.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await onCreate(database);
    });
  }

  // tambah database
  static Future<int> add(String nim, String nama, String alamat, String telepon,
      String jenisKelamin, String foto) async {
    final db = await SQLHelper.db();
    final data = {
      'nim': nim,
      'nama': nama,
      'alamat': alamat,
      'telepon': telepon,
      'jenisKelamin': jenisKelamin,
      'foto': foto,
    };
    return await db.insert('mahasiswa', data);
  }

  // ambil data
  static Future<List<Map<String, dynamic>>> get() async {
    final db = await SQLHelper.db();
    return db.query('mahasiswa');
  }

  // update database
  static Future<int> update(String nim, String nama, String alamat,
      String telepon, String jenisKelamin, String foto) async {
    final db = await SQLHelper.db();
    final data = {
      'nim': nim,
      'nama': nama,
      'alamat': alamat,
      'telepon': telepon,
      'jenisKelamin': jenisKelamin,
      'foto': foto,
    };

    return await db.update('mahasiswa', data, where: "nim=$nim");
  }

  // hapus database
  static Future<void> delete(String nim) async {
    final db = await SQLHelper.db();
    await db.delete('mahasiswa', where: "nim = $nim");
  }
}
