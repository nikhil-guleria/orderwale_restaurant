// lib/utils/escpos_builder.dart
//
// Builds raw ESC/POS byte sequences for thermal printers.
// Reference: https://download4.epson.biz/sec_pubs/pos/reference_en/escpos/
import 'dart:convert';
import 'dart:typed_data';

import 'package:food_merchant/constant/string_constants.dart';
import 'package:food_merchant/screens/order_details/models/order_details_model.dart';
import 'package:food_merchant/utils/CommonUtils.dart';



class EscPosBuilder {
  final List<int> _buffer = [];

  // ── ESC/POS Constants ──────────────────────────────────────────────────────
  static const int ESC = 0x1B;
  static const int GS = 0x1D;
  static const int LF = 0x0A;
  static const int HT = 0x09; // horizontal tab

  // ── Initialise ─────────────────────────────────────────────────────────────
  EscPosBuilder init() {
    _buffer.addAll([ESC, 0x40]); // ESC @ – initialize printer
    return this;
  }

  // ── Text alignment ─────────────────────────────────────────────────────────
  EscPosBuilder alignLeft() {
    _buffer.addAll([ESC, 0x61, 0x00]);
    return this;
  }

  EscPosBuilder alignCenter() {
    _buffer.addAll([ESC, 0x61, 0x01]);
    return this;
  }

  EscPosBuilder alignRight() {
    _buffer.addAll([ESC, 0x61, 0x02]);
    return this;
  }

  // ── Text style ─────────────────────────────────────────────────────────────
  EscPosBuilder bold(bool on) {
    _buffer.addAll([ESC, 0x45, on ? 0x01 : 0x00]);
    return this;
  }

  EscPosBuilder underline(bool on) {
    _buffer.addAll([ESC, 0x2D, on ? 0x01 : 0x00]);
    return this;
  }

  EscPosBuilder doubleHeight(bool on) {
    _buffer.addAll([GS, 0x21, on ? 0x01 : 0x00]);
    return this;
  }

  EscPosBuilder doubleWidth(bool on) {
    _buffer.addAll([GS, 0x21, on ? 0x10 : 0x00]);
    return this;
  }

  EscPosBuilder doubleSize(bool on) {
    _buffer.addAll([GS, 0x21, on ? 0x11 : 0x00]);
    return this;
  }

  // ── Text output ────────────────────────────────────────────────────────────
  EscPosBuilder text(String text) {
    _buffer.addAll(utf8.encode(text));
    return this;
  }

  EscPosBuilder textLine(String text) {
    _buffer.addAll(utf8.encode(text));
    _buffer.add(LF);
    return this;
  }

  EscPosBuilder emptyLine([int count = 1]) {
    for (int i = 0; i < count; i++) {
      _buffer.add(LF);
    }
    return this;
  }

  // ── Divider ────────────────────────────────────────────────────────────────
  /// Prints a full-width dashed divider (48 chars for 80mm, 32 for 58mm paper)
  EscPosBuilder divider({int width = 48, String char = '-'}) {
    return textLine(char * width);
  }

  EscPosBuilder doubleDivider({int width = 48}) => divider(width: width, char: '=');

  // ── Key-value row ──────────────────────────────────────────────────────────
  /// Prints "Label .............. Value" padded to [width] chars
  EscPosBuilder keyValue(String key, String value, {int width = 48}) {
    final dots = width - key.length - value.length;
    final padding = dots > 0 ? ' ' * dots : ' ';
    return textLine('$key$padding$value');
  }

  // ── Cut ───────────────────────────────────────────────────────────────────
  EscPosBuilder cut({bool partial = false}) {
    _buffer.addAll([GS, 0x56, partial ? 0x01 : 0x00]);
    return this;
  }

  EscPosBuilder feedAndCut({int lines = 3}) {
    emptyLine(lines);
    return cut();
  }

  // ── Barcode / QR ──────────────────────────────────────────────────────────
  /// Prints a QR code for [data]. Size 1-16.
  EscPosBuilder qrCode(String data, {int size = 6}) {
    final bytes = utf8.encode(data);
    final len = bytes.length + 3;
    final pL = len & 0xFF;
    final pH = (len >> 8) & 0xFF;

    // Model
    _buffer.addAll([GS, 0x28, 0x6B, 4, 0, 0x31, 0x41, 0x32, 0x00]);
    // Size
    _buffer.addAll([GS, 0x28, 0x6B, 3, 0, 0x31, 0x43, size]);
    // Error correction (M = 0x31)
    _buffer.addAll([GS, 0x28, 0x6B, 3, 0, 0x31, 0x45, 0x31]);
    // Store data
    _buffer.addAll([GS, 0x28, 0x6B, pL, pH, 0x31, 0x50, 0x30, ...bytes]);
    // Print
    _buffer.addAll([GS, 0x28, 0x6B, 3, 0, 0x31, 0x51, 0x30]);
    return this;
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  Uint8List build() => Uint8List.fromList(_buffer);

  /// Returns Base64 encoded string for transmission over HTTP/WebSocket
  String buildBase64() => base64Encode(build());
}





// ── Paper size enum ───────────────────────────────────────────────────────────

enum ThermalPaperSize { mm58, mm80 }

// ── restaurantBill ────────────────────────────────────────────────────────────

class RestaurantPrintBuilder {

  // Public: single, normal bill
  static EscPosBuilder restaurantBill({
    required OrderDetailsData? order,
    required double gst,
    required String gstLabel,
    required double packagingCharges,
    required double deliveryCharges,
    required double discountPrice,
    required double totalPrice,
    required String roundOff,
    required int paymentType,
    required bool useCurrentDate,
    required bool noCharge,
    ThermalPaperSize paperSize = ThermalPaperSize.mm58,
  }) {
    final b = EscPosBuilder().init();
    _writeBillBody(
      b,
      order: order,
      gst: gst,
      gstLabel: gstLabel,
      packagingCharges: packagingCharges,
      deliveryCharges: deliveryCharges,
      discountPrice: discountPrice,
      totalPrice: totalPrice,
      roundOff: roundOff,
      paymentType: paymentType,
      useCurrentDate: useCurrentDate,
      paperSize: paperSize,
      noCharge: noCharge,
      splitCopy: null, // <-- not a split person copy
      selectedItemIds: {} // <-- not a split items
    );
    return b.feedAndCut(lines: 4);
  }



  // Public: split-by-person bill. Prints [numberOfPersons] copies,
  // each with its own share, all in ONE combined buffer/command.
  static EscPosBuilder restaurantBillSplitByPersons({
    required OrderDetailsData? order,
    required double gst,
    required String gstLabel,
    required double packagingCharges,
    required double deliveryCharges,
    required double discountPrice,
    required double totalPrice,
    required String roundOff,
    required int paymentType,
    required int numberOfPersons,
    required bool useCurrentDate,
    required bool noCharge,
    ThermalPaperSize paperSize = ThermalPaperSize.mm58,
  }) {
    // splitBill works on ints (paise/rupees as whole numbers),
    // so we round the total to int rupees before splitting.
    final shares = CommonUtils.utils.splitBillByPersonsShares(totalPrice.round(), numberOfPersons);

    final b = EscPosBuilder().init();

    for (int i = 0; i < shares.length; i++) {
      _writeBillBody(
        b,
        order: order,
        gst: gst,
        gstLabel: gstLabel,
        packagingCharges: packagingCharges,
        deliveryCharges: deliveryCharges,
        discountPrice: discountPrice,
        totalPrice: totalPrice,
        roundOff: roundOff,
        paymentType: paymentType,
        useCurrentDate: useCurrentDate,
        paperSize: paperSize,
        noCharge: noCharge,
        splitCopy: _SplitCopyInfo(
          index: i + 1,
          total: shares.length,
          shareAmount: shares[i].toDouble(),
        ),
        selectedItemIds: {}
      );
      b.feedAndCut(lines: 4);
    }

    return b;
  }



  static EscPosBuilder restaurantBillSplitByItems({
    required OrderDetailsData? order,
    required double gst,
    required String gstLabel,
    required double packagingCharges,
    required double deliveryCharges,
    required double discountPrice,
    required double totalPrice,
    required String roundOff,
    required int paymentType,
    required bool useCurrentDate,
    required bool noCharge,
    required Set<int> selectedItemIds,
    ThermalPaperSize paperSize = ThermalPaperSize.mm58,
  }) {
    // splitBill works on ints (paise/rupees as whole numbers),
    // so we round the total to int rupees before splitting.
    final b = EscPosBuilder().init();

      _writeBillBody(
          b,
          order: order,
          gst: gst,
          gstLabel: gstLabel,
          packagingCharges: packagingCharges,
          deliveryCharges: deliveryCharges,
          discountPrice: discountPrice,
          totalPrice: totalPrice,
          roundOff: roundOff,
          paymentType: paymentType,
          useCurrentDate: useCurrentDate,
          paperSize: paperSize,
          noCharge: noCharge,
          splitCopy: null,
          selectedItemIds: selectedItemIds
      );
    return b.feedAndCut(lines: 4);
  }



  // Shared bill-drawing logic. Writes into [b], does NOT init or cut —
  // caller controls init()/feedAndCut() so multi-copy jobs share one buffer.
  static void _writeBillBody(
      EscPosBuilder b, {
        required OrderDetailsData? order,
        required double gst,
        required String gstLabel,
        required double packagingCharges,
        required double deliveryCharges,
        required double discountPrice,
        required double totalPrice,
        required String roundOff,
        required int paymentType,
        required bool useCurrentDate,
        required ThermalPaperSize paperSize,
        required bool noCharge,
        required _SplitCopyInfo? splitCopy,
        required Set<int> selectedItemIds,

      }) {
    final now = DateTime.now();

    final int lineWidth = paperSize == ThermalPaperSize.mm58 ? 32 : 48;
    final int itemWidth = paperSize == ThermalPaperSize.mm58 ? 16 : 26;

    const int qtyCol = 4;
    const int amtCol = 8;
    final int nameCol = lineWidth - qtyCol - amtCol;

    // ── HEADER ──────────────────────────────────────────────────────────
    b
        .alignCenter()
        .bold(true)
        .doubleSize(true)
        .textLine(order?.name ?? '')
        .doubleSize(false)
        .bold(false)
        .textLine(order?.restaurantAddress ?? '')
        .textLine('Ph: ${order?.restaurantPhone ?? ''}');

    if ((order?.fssaiNo ?? '').isNotEmpty) {
      b.textLine('FSSAI: ${order?.fssaiNo ?? ''}');
    }

    b
        .divider(char: '-', width: lineWidth)
        .bold(true)
        .doubleHeight(true)
        .alignCenter()
        .textLine('TAX INVOICE')
        .doubleHeight(false)
        .bold(false);

    // Split-copy marker, e.g. "[2 / 4]" — printed right under the title
    if (splitCopy != null) {
      b
          .bold(true)
          .textLine('[ ${splitCopy.index} / ${splitCopy.total} ]')
          .bold(false);
    }

    b.doubleDivider(width: lineWidth);

    // ── ORDER INFO ──────────────────────────────────────────────────────
    b.alignLeft();
    b.keyValue('Bill No', 'B-${order?.orderId ?? ''}', width: lineWidth);
    if (useCurrentDate) {
      b.keyValue('Date', _fmtDate(now), width: lineWidth);
      b.keyValue('Time', _fmtTime(now), width: lineWidth);
    } else {
      final dateTimeList =
      CommonUtils.utils.getDeliveredOrderDateAndTime(order?.deliveryDateTime);
      if (dateTimeList.isNotEmpty) {
        b.keyValue('Date', dateTimeList[0], width: lineWidth);
        b.keyValue('Time', dateTimeList[1], width: lineWidth);
      }
    }

    b.keyValue('Type', _fmtDeliveryType(order?.deliveryType), width: lineWidth);



    if ((order?.userName ?? '').isNotEmpty) {
      b.keyValue('Customer', order?.userName ?? '', width: lineWidth);
    }


    if ((order?.deliveryAddress ?? '').isNotEmpty && order?.deliveryType == '1') {
      b.keyValue('Deliver to', order?.deliveryAddress ?? '', width: lineWidth);
    }


    b.divider(char: '-', width: lineWidth);

    // ── COLUMN HEADER ───────────────────────────────────────────────────
    b
        .bold(true)
        .textLine(
      'ITEM'.padRight(nameCol) + 'QTY'.padLeft(qtyCol) + 'AMT'.padLeft(amtCol),
    )
        .bold(false)
        .divider(char: '-', width: lineWidth);

    final allProducts = order?.products ?? <Products>[];
    final bool isItemFilter = selectedItemIds.isNotEmpty;

    final filteredProducts = allProducts.where((item) {
      if (!isItemFilter) return true;
      return selectedItemIds.contains(item.id);
    }).toList();

    double filteredItemsTotal = 0;
    for (final item in filteredProducts) {
      filteredItemsTotal += _parseDouble(item.productPrice);
    }

    if (filteredProducts.isEmpty) {
      b.alignCenter().textLine('** NO ITEM DATA RECEIVED **').alignLeft();
    }

    for (final item in filteredProducts) {
      final wrappedLines = _wrapText(item.productName ?? '', itemWidth);

      for (int i = 0; i < wrappedLines.length; i++) {
        final qtyStr = i == 0 ? item.productQuantity ?? '' : '';
        final amtStr = i == 0 ? item.productPrice ?? '' : '';

        b.textLine(
          wrappedLines[i].padRight(nameCol) +
              qtyStr.padLeft(qtyCol) +
              amtStr.padLeft(amtCol),
        );
      }

      if ((item.customisationTitle ?? '').isNotEmpty) {
        b.textLine('  > ${item.customisationTitle}');
      }

      for (final topping in (item.toppings ?? <Toppings>[])) {
        if ((topping.title ?? '').isNotEmpty) {
          b.textLine('  + ${topping.title}');
        }
      }
    }

    b.divider(char: '-', width: lineWidth);

    // ── TOTALS ───────────────────────────────────────────────────────
    b.keyValue('Items Total', _currency(isItemFilter ? filteredItemsTotal : _parseDouble(order?.itemsTotal)),
        width: lineWidth);

    if (deliveryCharges > 0) {
      b.keyValue('Delivery Charges', _currency(deliveryCharges), width: lineWidth);
    }
    if (packagingCharges > 0) {
      b.keyValue('Packaging Charges', _currency(packagingCharges), width: lineWidth);
    }

    final tip = _parseDouble(order?.tipPrice);
    if (tip > 0) b.keyValue('Tip', _currency(tip), width: lineWidth);

    final platformFee = _parseDouble(order?.platformFee);
    if (platformFee > 0) {
      b.keyValue('Platform Fee', _currency(platformFee), width: lineWidth);
    }

    if (gst > 0) b.keyValue(gstLabel, _currency(gst), width: lineWidth);

    if (discountPrice > 0) {
      b.keyValue('Discount', '- ${_currency(discountPrice)}', width: lineWidth);
    }

    final wallet = _parseDouble(order?.walletPrice);
    if (wallet > 0) {
      b.keyValue('Wallet', '- ${_currency(wallet)}', width: lineWidth);
    }

    if (roundOff.trim().isNotEmpty) {
      b.keyValue(
        'Round Off',
        roundOff.replaceAll(currSymbolIn, 'Rs'),
        width: lineWidth,
      );
    }

    b.divider(char: '-', width: lineWidth);

    // ── GRAND TOTAL (double-size) ───────────────────────────────────────
    final totalStr = noCharge ? 'Rs 0' : _currency(totalPrice);
    const totalLabel = 'TOTAL';
    final halfWidth = lineWidth ~/ 2;
    final pad = halfWidth - totalLabel.length - totalStr.length;
    b
        .bold(true)
        .doubleSize(true)
        .textLine('$totalLabel${' ' * (pad > 0 ? pad : 1)}$totalStr')
        .doubleSize(false)
        .bold(false);

    // ── YOUR SHARE (only for split copies) ─────────────────────────────
    if (splitCopy != null) {
      final shareStr = noCharge ? 'Rs 0' : _currency(splitCopy.shareAmount);
      const shareLabel = 'YOUR SHARE';
      final sharePad = halfWidth - shareLabel.length - shareStr.length;
      b
          .divider(char: '-', width: lineWidth)
          .bold(true)
          .doubleSize(true)
          .textLine('$shareLabel${' ' * (sharePad > 0 ? sharePad : 1)}$shareStr')
          .doubleSize(false)
          .bold(false);
    }

    b.divider(char: '-', width: lineWidth);

    // ── PAYMENT ─────────────────────────────────────────────────────────
    b.keyValue('Payment', _fmtPaymentType(paymentType), width: lineWidth);

    // ── FOOTER ──────────────────────────────────────────────────────────
    b
        .emptyLine(2)
        .alignCenter()
        .bold(true)
        .textLine('*** Thank You, Visit Again! ***')
        .bold(false)
        .alignCenter()
        .textLine('Powered by OrderWale');
  }




  // ── Helpers ───────────────────────────────────────────────────────────────
  static String _fmtDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}';

  static String _fmtTime(DateTime dt) {
    final m  = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final h12 = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    return '${h12.toString().padLeft(2, '0')}:$m $period';
  }

  /// deliveryType on your model is String? ("1", "2", "3")
  static String _fmtDeliveryType(String? type) {
    switch (type?.trim()) {
      case '1': return 'Delivery';
      case '2': return 'Dine In';
      default:  return 'Takeaway';
    }
  }

  /// paymentType is passed as int (caller does int.tryParse(order.paymentType))
  static String _fmtPaymentType(int type) {
    switch (type) {
    case 1:
    return "COD";
    case 4:
    case 7:
    return "Online";
    case 8:
    return "Cash";
    case 9:
    return "UPI";
    case 10:
    return "Card";
    default:
    return "N/A";
    }
  }

  static String _currency(double amount) =>
      'Rs ${amount.toStringAsFixed(2)}'; // ₹

  /// Safely parses String? → double (all numeric fields on your model are String?)
  static double _parseDouble(String? value) =>
      double.tryParse(value?.trim() ?? '') ?? 0.0;

  /// Word-wraps [text] to [maxWidth] chars per line
  static List<String> _wrapText(String text, int maxWidth) {
    if (text.length <= maxWidth) return [text];
    final lines = <String>[];
    var remaining = text;
    while (remaining.length > maxWidth) {
      int breakAt = remaining.lastIndexOf(' ', maxWidth);
      if (breakAt <= 0) breakAt = maxWidth;
      lines.add(remaining.substring(0, breakAt).trimRight());
      remaining = remaining.substring(breakAt).trimLeft();
    }
    if (remaining.isNotEmpty) lines.add(remaining);
    return lines;
  }


}

class _SplitCopyInfo {
  final int index;      // 1-based copy number
  final int total;      // total number of persons/copies
  final double shareAmount;
  const _SplitCopyInfo({
    required this.index,
    required this.total,
    required this.shareAmount,
  });
}
