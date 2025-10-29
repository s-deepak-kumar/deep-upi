import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:deep_upi/model/upi_app_model.dart';

class UpiPaymentPlugin {
  static const MethodChannel _channel = MethodChannel('deep_upi');

  /// Fetches the list of installed UPI apps.
  Future<List<UpiAppModel>> getUpiApps() async {
    try {
      final List<dynamic>? appsData =
          await _channel.invokeMethod<List<dynamic>>('getActiveUpiApps');
      if (appsData == null) return [];
      return appsData
          .map((app) => UpiAppModel.fromMap(Map<String, dynamic>.from(app)))
          .toList();
    } on PlatformException catch (e) {
      debugPrint("Error fetching UPI apps: ${e.message}");
      return [];
    }
  }

  /// Generates a signed transaction string in Base64 format.
  static Future<String> createSign({
    required String payeeUpiId,
    required String payeeName,
    required double amount,
    String? transactionId,
    String? transactionNote,
    String? merchantCode,
    String? link,
    required String secretKey,
  }) async {
    try {
      return await _channel.invokeMethod<String>('createSign', {
            'payeeUpiId': payeeUpiId,
            'payeeName': payeeName,
            'amount': amount.toStringAsFixed(2), // Ensures proper decimal format
            if (transactionId != null) 'transactionId': transactionId,
            if (transactionNote != null) 'transactionNote': transactionNote,
            if (merchantCode != null) 'merchantCode': merchantCode,
            if (link != null) 'link': link,
            'secretKey': secretKey,
          }) ??
          '';
    } on PlatformException catch (e) {
      debugPrint("Error generating signature: ${e.message}");
      return '';
    }
  }

  /// Initiates a UPI payment with the selected app.
  static Future<String> initiateUPIPayment({
    required String payeeUpiId,
    String? payeeName,
    required double amount,
    String? transactionId,
    String? transactionNote,
    String? merchantCode,
    String? link,
    String? transactionRefId,
    String? packageName,
    String? secretKey,
  }) async {
    try {
      final bool isMerchant = merchantCode != null && merchantCode.isNotEmpty;
      String sign = '';
      if (isMerchant && secretKey != null && secretKey.isNotEmpty) {
        sign = await createSign(
          payeeUpiId: payeeUpiId,
          payeeName: payeeName ?? '',
          amount: amount,
          transactionId: transactionId,
          transactionNote: transactionNote,
          merchantCode: merchantCode,
          link: link,
          secretKey: secretKey,
        );
      }

      return await _channel.invokeMethod<String>('initiateUPIPayment', {
            'payeeUpiId': payeeUpiId,
            if (payeeName != null) 'payeeName': payeeName,
            'amount': amount.toStringAsFixed(2),
            if (isMerchant && transactionId != null) 'transactionId': transactionId,
            if (transactionNote != null) 'transactionNote': transactionNote,
            if (isMerchant) 'merchantCode': merchantCode,
            if (isMerchant && link != null && link.isNotEmpty) 'link': link,
            if (isMerchant && transactionRefId != null && transactionRefId.isNotEmpty) 'transactionRefId': transactionRefId,
            if (packageName != null && packageName.isNotEmpty) 'packageName': packageName,
            if (isMerchant && sign.isNotEmpty) 'sign': sign,
          }) ??
          'UPI Payment Failed';
    } on PlatformException catch (e) {
      debugPrint("Error initiating UPI Payment: ${e.message}");
      return 'Error: ${e.message}';
    }
  }
}
