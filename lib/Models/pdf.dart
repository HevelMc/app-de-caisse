import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart';

import 'client.dart';
import 'service.dart';

class Pdf {
  Client client;
  List<Service> services;
  BuildContext buildContext;

  generateInvoice(Client client, List<Service> services, DateTime date, BuildContext buildContext) async {
    this.client = client;
    this.services = services;
    this.buildContext = buildContext;
    final pdf = pw.Document();
    Font myFont = Font.ttf(await rootBundle.load("assets/OpenSans-Regular.ttf"));
    Font myFontBold = Font.ttf(await rootBundle.load("assets/OpenSans-Bold.ttf"));

    pdf.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(PdfPageFormat.a4, myFont, myFontBold, myFont),
        header: _buildHeader,
        build: (context) => [
          _contentHeader(context),
          _contentTable(
            context,
            List.generate(
              services.length,
              (index) => [
                services[index].name,
                services[index].getFormattedPrice(),
                "0%",
                services[index].getFormattedPrice()
              ],
            ),
          ),
          _contentFooter(context),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/${client.getName().replaceAll(" ", "_")}.pdf");
    await file.writeAsBytes(pdf.save());
    await OpenFile.open(file.path);
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Row(
                children: [
                  pw.Flexible(
                    child: pw.Container(
                      margin: pw.EdgeInsets.only(right: 40),
                      decoration: pw.BoxDecoration(
                        borderRadius: 2,
                        color: PdfColors.grey800,
                      ),
                      padding: const pw.EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
                      alignment: pw.Alignment.centerLeft,
                      height: 80,
                      child: pw.DefaultTextStyle(
                        style: pw.TextStyle(
                          color: PdfColors.grey50,
                          fontSize: 12,
                        ),
                        child: pw.GridView(
                          crossAxisCount: 2,
                          children: [
                            pw.Text('Facture #'),
                            pw.Text("00000"),
                            pw.Text('Date :'),
                            pw.Text(_formatDate(DateTime.now(), buildContext)),
                            pw.Text(''),
                            pw.Text(''),
                            pw.Text('Adressée à :'),
                            pw.Text(this.client.getName()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      'FACTURE',
                      style: pw.TextStyle(
                        color: PdfColors.blueGrey,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.PageTheme _buildTheme(PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Stack(
          children: [
            pw.Positioned(
              bottom: 0,
              left: 0,
              child: pw.Container(
                height: 20,
                width: pageFormat.width / 2,
                decoration: pw.BoxDecoration(
                  gradient: pw.LinearGradient(
                    colors: [PdfColors.blueGrey, PdfColors.white],
                  ),
                ),
              ),
            ),
            pw.Positioned(
              bottom: 20,
              left: 0,
              child: pw.Container(
                height: 20,
                width: pageFormat.width / 4,
                decoration: pw.BoxDecoration(
                  gradient: pw.LinearGradient(
                    colors: [PdfColors.grey800, PdfColors.white],
                  ),
                ),
              ),
            ),
            pw.Positioned(
              top: pageFormat.marginTop + 72,
              left: 0,
              right: 0,
              child: pw.Container(
                height: 3,
                color: PdfColors.grey50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Container(
            margin: const pw.EdgeInsets.only(left: 50, right: 50, top: 40),
            height: 70,
            child: pw.FittedBox(
              child: pw.Text(
                'Total: ' + getTotal().toStringAsFixed(2) + ' €',
                style: pw.TextStyle(
                  color: PdfColors.blueGrey,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Row(
            children: [
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 30, right: 30),
                height: 30,
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context, List<List<String>> products) {
    const tableHeaders = ['Prestation', 'Prix initial', 'Réduction', 'Total'];

    return pw.Container(
      margin: pw.EdgeInsets.only(left: 40, right: 40, top: 10),
      child: pw.Table.fromTextArray(
        border: null,
        cellAlignment: pw.Alignment.centerLeft,
        cellPadding: pw.EdgeInsets.symmetric(horizontal: 20),
        headerDecoration: pw.BoxDecoration(
          borderRadius: 2,
          color: PdfColors.blueGrey,
        ),
        headerHeight: 25,
        cellHeight: 40,
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.center,
          2: pw.Alignment.center,
          3: pw.Alignment.centerRight,
        },
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
        ),
        cellStyle: const pw.TextStyle(
          color: PdfColors.grey900,
          fontSize: 10,
        ),
        rowDecoration: pw.BoxDecoration(
          border: pw.BoxBorder(
            bottom: true,
            color: PdfColors.grey900,
            width: .5,
          ),
        ),
        headers: List<String>.generate(
          tableHeaders.length,
          (col) => tableHeaders[col],
        ),
        data: List<List<String>>.generate(
          products.length,
          (row) => List<String>.generate(
            tableHeaders.length,
            (col) => products[row][col],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date, BuildContext buildContext) {
    return MaterialLocalizations.of(buildContext).formatFullDate(date);
  }

  double getTotal() {
    double total = 0;
    services.forEach((element) {
      total += element.price;
    });
    return total;
  }

  pw.Widget _contentFooter(pw.Context context) {
    return pw.Container(
      margin: pw.EdgeInsets.only(top: 50),
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 20, bottom: 8),
                  child: pw.Text(
                    'Virginie LOPEZ Esthéticienne',
                    style: pw.TextStyle(
                      color: PdfColors.blueGrey,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Text(
                  "Rivabella institut,\n42 Chemin Levassor,\n06210 Mandelieu-la-Napoule",
                  style: const pw.TextStyle(
                    fontSize: 10,
                    lineSpacing: 5,
                    color: PdfColors.grey900,
                  ),
                ),
              ],
            ),
          ),
          pw.Expanded(
            flex: 1,
            child: pw.DefaultTextStyle(
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey900,
              ),
              child: pw.Container(
                margin: pw.EdgeInsets.only(top: 60),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('TVA non applicable selon l’article 293 B du Code Général des Impôts',
                        textAlign: pw.TextAlign.right),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    ),
                    pw.Divider(color: PdfColors.grey900),
                    pw.DefaultTextStyle(
                      style: pw.TextStyle(
                        color: PdfColors.blueGrey,
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Total:'),
                          pw.Text(getTotal().toStringAsFixed(2) + ' €'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
