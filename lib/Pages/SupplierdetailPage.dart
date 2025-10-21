import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

class SupplierdetailPageWidget extends StatefulWidget {
  const SupplierdetailPageWidget({super.key});

  static String routeName = 'SupplierdetailPage';
  static String routePath = '/supplierdetailPage';

  @override
  State<SupplierdetailPageWidget> createState() =>
      _SupplierdetailPageWidgetState();
}

class _SupplierdetailPageWidgetState extends State<SupplierdetailPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Supplier Details',
              style: FlutterFlowTheme.of(context).displayMedium,
            ),
            const SizedBox(height: 20),
            FFButtonWidget(
              onPressed: () {
                Navigator.pop(context);
              },
              text: 'Go Back',
              options: FFButtonOptions(
                width: 200,
                height: 50,
                padding: const EdgeInsets.all(0),
                iconPadding: const EdgeInsets.all(0),
                color: FlutterFlowTheme.of(context).secondaryBackground,
                textStyle: FlutterFlowTheme.of(context).titleSmall,
                elevation: 0,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
