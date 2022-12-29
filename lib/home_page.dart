import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uas_mobile/sql_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nimController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController teleponController = TextEditingController();
  MaterialStatesController fotoController = MaterialStatesController();
  File image;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile imagePicked =
        await _picker.pickImage(source: ImageSource.camera);
    image = File(imagePicked.path);
    setState(() {});
  }

  _HomePageState() {
    _selectedValue = _jenisKelaminList[0];
  }

  final _jenisKelaminList = ['Laki', 'Perempuan'];
  String _selectedValue = "";

  @override
  void initState() {
    refreshMahasiswa();
    super.initState();
  }

  List<Map<String, dynamic>> mahasiswa = [];
  void refreshMahasiswa() async {
    final data = await SQLHelper.insert();
    setState(() {
      mahasiswa = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(mahasiswa);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Mahasiswa Page"),
          backgroundColor: Color.fromARGB(207, 11, 108, 125),
        ),
        body: ListView.builder(
          itemCount: mahasiswa.length,
          itemBuilder: (context, index) => Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: SizedBox(
                child: Row(children: [
                  Text(mahasiswa[index]['nim']),
                  Text('\t'),
                  Text(mahasiswa[index]['nama']),
                ]),
              ),
              subtitle: SizedBox(
                  child: Row(children: [
                Text(mahasiswa[index]['alamat']),
                Text('\t'),
                Text(mahasiswa[index]['telepon']),
                Text('\t'),
                Text(mahasiswa[index]['jenisKelamin']),
              ])),
              leading: Image.file(File(mahasiswa[index]['foto'])),
              trailing: IconButton(
                  onPressed: () => delete(mahasiswa[index]['nim']),
                  icon: const Icon(Icons.delete)),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            create();
          },
          child: const Icon(Icons.add),
          backgroundColor: Color.fromARGB(207, 11, 108, 125),
        ),
      ),
    );
  }

  Future<void> tambahMahasiswa() async {
    await SQLHelper.tambahMahasiswa(
        nimController.text,
        namaController.text,
        alamatController.text,
        teleponController.text,
        _selectedValue,
        image.path);
    refreshMahasiswa();
  }

  void delete(String nim) async {
    await SQLHelper.delete(nim);
    refreshMahasiswa();
  }

  // form tambah
  void create() async {
    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 800,
              child: SingleChildScrollView(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: nimController,
                    decoration: new InputDecoration(
                      hintText: "masukan NIM",
                      labelText: "NIM",
                      icon: Icon(Icons.credit_card),
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0)),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: namaController,
                    decoration: new InputDecoration(
                      hintText: "Masukan Nama anda",
                      labelText: "Nama",
                      icon: Icon(Icons.person_rounded),
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: alamatController,
                    decoration: new InputDecoration(
                      hintText: "Masukan Alamat anda",
                      labelText: "Alamat",
                      icon: Icon(Icons.location_on_sharp),
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: teleponController,
                    decoration: new InputDecoration(
                      hintText: "Masukan Telepon anda",
                      labelText: "Telepon",
                      icon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0)),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    decoration: new InputDecoration(
                      icon: Icon(Icons.male),
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
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(207, 11, 108, 125),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    //  style: ElevatedButton.styleFrom(
                    //   padding: const EdgeInsets.only(right: 50)),
                    onPressed: () async {
                      await getImage();
                    },
                    label: const Text('Unggah Foto 3x4'),
                    icon: const Icon(Icons.photo_camera_front_outlined),
                  ),
                  image != null
                      ? Container(
                          margin: EdgeInsets.only(left: 270),
                          height: 100,
                          width: 100,
                          child: Image.file(
                            image,
                            fit: BoxFit.cover,
                          ))
                      : Container(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(207, 11, 108, 125),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    onPressed: () async {
                      await tambahMahasiswa();
                      nimController.text = '';
                      namaController.text = '';
                      alamatController.text = '';
                      teleponController.text = '';
                      image = null;
                      Navigator.pop(context);
                    },
                    label: const Text('Tambah Data Mahasiswa'),
                    icon: const Icon(Icons.person_add),
                  ),
                ],
              )),
            ));
  }
}
