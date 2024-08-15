import 'package:deep_pick/deep_pick.dart';

class Wallet {
  final String id;
  String balance = "0";

  Wallet({
    required this.id,
    required this.balance,
  });

  factory Wallet.fromMap(Map<String, dynamic> json) {
    return Wallet(
      balance: pick(json, "balance").asStringOrThrow(),
      id: pick(json, "id").asStringOrThrow(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'balance': balance,
    };
  }
}
