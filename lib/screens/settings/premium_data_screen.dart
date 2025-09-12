// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:doctorfriend/components/row_text.dart';
// import 'package:doctorfriend/utils/formater_util.dart';
// import 'package:flutter/material.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

// class PremiumDataScreen extends StatelessWidget {
//   final CustomerInfo customerInfo;
//   const PremiumDataScreen({super.key, required this.customerInfo});

//   @override
//   Widget build(BuildContext context) {
//     final EntitlementInfo? premium =
//         customerInfo.entitlements.active['monthly'];
//     if (premium == null) {
//       Navigator.pop(context);
//     }

//     final validity = premium!.expirationDate;

//     final latestPurchaseDate = premium.latestPurchaseDate;
//     final String validityFormater = _formatDate(validity);
//     final String latestPurchaseDateFormater = _formatDate(latestPurchaseDate);

//     final bool willRenew = premium.willRenew;

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: InkWell(
//         onTap: () => Navigator.pop(context),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.5), // Define a opacidade do fundo
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           padding: const EdgeInsets.all(15.0),
//           alignment: Alignment.center,
//           child: Container(
//             decoration: BoxDecoration(
//               color: Theme.of(context)
//                   .colorScheme
//                   .onPrimary, // Define a opacidade do fundo
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   alignment: Alignment.center,
//                   padding: const EdgeInsets.only(bottom: 20.0),
//                   child: Column(
//                     children: [
//                       Icon(
//                         Icons.workspace_premium_outlined,
//                         size: 70,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         "Premium",
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                     ],
//                   ),
//                 ),
//                 RowText(
//                   title: "Validade: ",
//                   content: validityFormater,
//                 ),
//                 RowText(
//                   title: "Último pagamento: ",
//                   content: latestPurchaseDateFormater,
//                 ),
//                 RowText(
//                   title: "Renovação automática: ",
//                   content: willRenew ? "SIM" : "NÃO",
//                 ),
//                 RowText(
//                   title: "Loja: ",
//                   content: premium.store.name.toUpperCase(),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatDate(String? date) {
//     return date == null
//         ? ""
//         : FormaterUtil.formatDate(
//             Timestamp.fromMicrosecondsSinceEpoch(
//                     DateTime.parse(date).microsecondsSinceEpoch)
//                 .toDate(),
//             true,
//           );
//   }
// }
