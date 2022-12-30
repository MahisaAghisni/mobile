import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uas_mobile/detail_page.dart';
import 'package:uas_mobile/sql_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    refreshMahasiswa();
    super.initState();
  }

  List<Map<String, dynamic>> mahasiswa = [];
  void refreshMahasiswa() async {
    final data = await SQLHelper.get();
    setState(() {
      mahasiswa = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(mahasiswa);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("List Mahasiswa"),
          backgroundColor: Color(0xffDC0000),
        ),
        body: Container(
          color: Color(0xff850000),
          child: RefreshIndicator(
            onRefresh: () async {
              refreshMahasiswa();
            },
            child: ListView.builder(
              itemCount: mahasiswa.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                decoration: BoxDecoration(
                  color: Color(0xffFFDB89),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return DetailsPage(
                            id: mahasiswa[index]['id'],
                            alamat: mahasiswa[index]['alamat'],
                            nama: mahasiswa[index]['nama'],
                            nim: mahasiswa[index]['nim'],
                            telepon: mahasiswa[index]['telepon'],
                            jenisKelamin: mahasiswa[index]['jenisKelamin'],
                            foto: mahasiswa[index]['foto'],
                          );
                        },
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      mahasiswa[index]['nama'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(mahasiswa[index]['jenisKelamin']),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.file(
                        File(
                          mahasiswa[index]['foto'],
                        ),
                      ),
                    ),
                    trailing: IconButton(
                        onPressed: () => delete(mahasiswa[index]['id']),
                        icon: const Icon(
                          Icons.delete,
                        )),
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // create();

            Navigator.pushNamed(context, '/insertData');
          },
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
          backgroundColor: Color(0xffFFDB89),
        ),
      ),
    );
  }

  void delete(int id) async {
    await SQLHelper.delete(id);
    refreshMahasiswa();
  }
  // form tambah

}
