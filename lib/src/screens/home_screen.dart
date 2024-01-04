import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Instances
  File? file;
  ImagePicker image = ImagePicker();

  // Function for get Image from Gallery
  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);

    setState(() {
      file = File(img!.path);
    });
  }

  // Function for take Image from Camera
  getImagecam() async {
    var img = await image.pickImage(source: ImageSource.camera);

    setState(() {
      file = File(img!.path);
    });
  }

  // PDF generation function
  Future<Uint8List> _generatePdf(PdfPageFormat format, file) async {
    final pdf = pw.Document();

    final showimage = pw.MemoryImage(file.readAsBytesSync());

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Center(
            child: pw.Image(showimage, fit: pw.BoxFit.contain),
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 228, 56, 43),
        title: const Text(
          "Image to pdf",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: getImage,
            icon: const Icon(
              Icons.image,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: getImagecam,
            icon: const Icon(
              Icons.camera,
              color: Colors.white,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              height: 150,
              width: double.infinity,
              color: const Color.fromARGB(255, 228, 56, 43),
              child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Image to PDF',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                     Text(
                      'Powered by Asim Iqbal',
                      style: TextStyle(
                          color: Colors.white,
                          // fontSize: 25,
                          fontWeight: FontWeight.w500),
                    )
                  ]),
            ),
          ],
        ),
      ),
      body: file == null
          ? const Center(
              child: Text(
                'No Image Selected',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : PdfPreview(
              build: (format) => _generatePdf(format, file),
            ),
    );
  }
}
