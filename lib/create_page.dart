import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uas_mobile/sql_helper.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController nimController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController teleponController = TextEditingController();
  // MaterialStatesController fotoController = MaterialStatesController();
  File image;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile imagePicked =
        await _picker.pickImage(source: ImageSource.camera);
    image = File(imagePicked.path);
    setState(() {});
  }

  List<Map<String, dynamic>> mahasiswa = [];
  void refreshMahasiswa() async {
    final data = await SQLHelper.get();
    setState(() {
      mahasiswa = data;
    });
  }

  final _jenisKelaminList = ['Laki-laki', 'Perempuan'];
  String _selectedValue = "";
  // Membuat validasi apakah inputan sudah terisi
  final _formKey = GlobalKey<FormState>();

  Future<void> add() async {
    await SQLHelper.add(
        nimController.text,
        namaController.text,
        alamatController.text,
        teleponController.text,
        _selectedValue,
        image.path);
    setState(() {});
  }

  _CreatePageState() {
    _selectedValue = _jenisKelaminList[0];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffDC0000),
        title: Text('Tambah Data'),
        centerTitle: true,
      ),
      // make input

      body: SingleChildScrollView(
        child: Container(
          color: Color(0xff850000),
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  'NIM',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: nimController,
                  decoration: InputDecoration(
                    fillColor: Color(0xffFFFFD0),
                    filled: true,
                    // menghilangkan border
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  'Nama',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: namaController,
                  decoration: InputDecoration(
                    fillColor: Color(0xffFFFFD0),
                    filled: true,
                    // menghilangkan border
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  'Alamat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: alamatController,
                  decoration: InputDecoration(
                    fillColor: Color(0xffFFFFD0),
                    filled: true,
                    // menghilangkan border
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  'Telepon',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: teleponController,
                  decoration: InputDecoration(
                    fillColor: Color(0xffFFFFD0),
                    filled: true,
                    // menghilangkan border
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  'Jenis Kelamin',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              DropdownButtonFormField(
                decoration: new InputDecoration(
                  fillColor: Color(0xffFFFFD0),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                ),
                value: _selectedValue,
                items: _jenisKelaminList
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedValue = val as String;
                  });
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  'Upload Foto',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              image != null
                  ? Center(
                      child: Container(
                          width: MediaQuery.of(context).size.width - 150,
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.file(
                              image,
                              fit: BoxFit.cover,
                            ),
                          )),
                    )
                  : Container(),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      primary: Color(0xffFFDB89),
                      padding: EdgeInsets.all(20),
                    ),
                    onPressed: () {
                      getImage();
                    },
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xffFFDB89),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () async {
                      await add();
                      refreshMahasiswa();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Simpan',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
