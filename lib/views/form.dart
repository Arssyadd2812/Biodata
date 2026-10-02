import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/api.dart';
import '../models/msiswa.dart';

class BiodataForm extends StatefulWidget {
  final MSiswa? siswa;

  const BiodataForm({super.key, this.siswa});

  @override
  State<BiodataForm> createState() => _BiodataFormState();
}

class _BiodataFormState extends State<BiodataForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nisController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _tplahirController = TextEditingController();
  String _tglahir = '';
  String _kelamin = 'Laki-laki';
  String _agama = 'Islam';
  final TextEditingController _alamatController = TextEditingController();

  bool get _isEdit => widget.siswa != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _nisController.text = widget.siswa!.nis ?? '';
      _namaController.text = widget.siswa!.nama ?? '';
      _tplahirController.text = widget.siswa!.tplahir ?? '';
      _tglahir = widget.siswa!.tglahir ?? '';
      _kelamin = widget.siswa!.kelamin ?? 'Laki-laki';
      _agama = widget.siswa!.agama ?? 'Islam';
      _alamatController.text = widget.siswa!.alamat ?? '';
    }
  }

  @override
  void dispose() {
    _nisController.dispose();
    _namaController.dispose();
    _tplahirController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_tglahir.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal lahir harus dipilih'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      try {
        final Map<String, String> body = {
          'nis': _nisController.text,
          'nama': _namaController.text,
          'tplahir': _tplahirController.text,
          'tglahir': _tglahir,
          'kelamin': _kelamin,
          'agama': _agama,
          'alamat': _alamatController.text,
        };

        http.Response response;

        if (_isEdit) {
          body['id'] = widget.siswa!.id.toString();
          response = await http.post(
            Uri.parse(Api.update()),
            body: body,
          );
        } else {
          response = await http.post(
            Uri.parse(Api.create()),
            body: body,
          );
        }

        if (response.statusCode == 200) {
          try {
            final data = json.decode(response.body);
            if (data['success'] == true || data['success'] == 1) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _isEdit
                          ? 'Data berhasil diubah'
                          : 'Data berhasil ditambahkan',
                    ),
                  ),
                );
                Navigator.pop(context, true);
              }
            } else {
              if (mounted) {
                final errorMsg = data['error'] ?? 'Gagal menyimpan data';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $errorMsg'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          } catch (jsonError) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Server error: Pastikan PHP dan database berjalan dengan benar'),
                ),
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Server error (${response.statusCode})'),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nisController,
              decoration: const InputDecoration(
                labelText: 'NIS',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIS tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _tplahirController,
              decoration: const InputDecoration(
                labelText: 'Tempat Lahir',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tempat lahir tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _tglahir.isNotEmpty
                      ? DateTime.parse(_tglahir)
                      : DateTime(2005),
                  firstDate: DateTime(1980),
                  lastDate: DateTime.now(),
                  helpText: 'PILIH TANGGAL LAHIR',
                );
                if (picked != null) {
                  setState(() {
                    _tglahir = picked.toIso8601String().substring(0, 10);
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _tglahir.isNotEmpty ? _tglahir : 'Pilih tanggal lahir',
                  style: TextStyle(
                    color: _tglahir.isNotEmpty ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _kelamin,
              decoration: const InputDecoration(
                labelText: 'Jenis Kelamin',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.wc),
              ),
              items: const [
                DropdownMenuItem(
                    value: 'Laki-laki', child: Text('Laki-laki')),
                DropdownMenuItem(
                    value: 'Perempuan', child: Text('Perempuan')),
              ],
              onChanged: (value) {
                setState(() {
                  _kelamin = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _agama,
              decoration: const InputDecoration(
                labelText: 'Agama',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.mosque),
              ),
              items: const [
                DropdownMenuItem(value: 'Islam', child: Text('Islam')),
                DropdownMenuItem(value: 'Kristen', child: Text('Kristen')),
                DropdownMenuItem(
                    value: 'Katolik', child: Text('Katolik')),
                DropdownMenuItem(value: 'Hindu', child: Text('Hindu')),
                DropdownMenuItem(value: 'Buddha', child: Text('Buddha')),
                DropdownMenuItem(
                    value: 'Konghucu', child: Text('Konghucu')),
              ],
              onChanged: (value) {
                setState(() {
                  _agama = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _alamatController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.home),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Alamat tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _submitForm,
              icon: Icon(_isEdit ? Icons.save : Icons.add),
              label: Text(
                _isEdit ? 'Simpan Perubahan' : 'Tambah Data',
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
