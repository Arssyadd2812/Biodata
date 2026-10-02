import 'package:flutter/material.dart';
import '../models/msiswa.dart';
import 'form.dart';

class Edit extends StatelessWidget {
  final MSiswa siswa;

  const Edit({super.key, required this.siswa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Biodata'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BiodataForm(siswa: siswa),
    );
  }
}
