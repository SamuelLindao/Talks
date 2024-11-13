import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerExample extends StatefulWidget {
  @override
  _FilePickerExampleState createState() => _FilePickerExampleState();
}

class _FilePickerExampleState extends State<FilePickerExample> {
  File? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    } else {
      print('Nenhum arquivo selecionado.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecionar Imagem'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedFile != null
                ? Image.file(_selectedFile!, height: 200)
                : Text('Nenhuma imagem selecionada'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Selecionar Imagem'),
            ),
          ],
        ),
      ),
    );
  }
}
