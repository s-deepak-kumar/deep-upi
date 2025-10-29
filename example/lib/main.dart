import 'package:flutter/material.dart';
import 'package:deep_upi/model/upi_app_model.dart';
import 'package:deep_upi/upi_payment_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<UpiAppModel> upiApps = [];
  UpiAppModel? selectedUpiApp;

  @override
  void initState() {
    fetchUpiApps();
    super.initState();
  }

  Future<void> fetchUpiApps() async {
    List<UpiAppModel> apps = await UpiPaymentPlugin().getUpiApps();
    setState(() {
      upiApps = apps;
    });
  }

  void initiateUPIPayment() {
    // if (selectedUpiApp == null) return;
    UpiPaymentPlugin.initiateUPIPayment(
      payeeUpiId: 'upi@id',
      payeeName: 'payeeName',
      amount: 1.0,
      // P2P flow with identifiers for reconciliation (no merchant fields)
      transactionId: 'ATTEMPT-1',
      transactionRefId: 'ORDER-12345',
      transactionNote: 'Test Transaction',
      packageName: 'com.google.android.apps.nbu.paisa.user',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("UPI Payment")),
        body: Center(
          child: Column(
            children: [
              DropdownButton<UpiAppModel>(
                hint: Text("Select UPI App"),
                value: selectedUpiApp,
                onChanged: (UpiAppModel? newValue) {
                  setState(() {
                    selectedUpiApp = newValue;
                  });
                },
                items: upiApps.map((UpiAppModel app) {
                  return DropdownMenuItem<UpiAppModel>(
                    value: app,
                    child: Text(app.appName),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: initiateUPIPayment,
                child: Text("Pay Now"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
