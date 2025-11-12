
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// class CheckoutScreen extends StatefulWidget {
//   final double totalAmount;

//   const CheckoutScreen({super.key, required this.totalAmount});

//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController lastnameController = TextEditingController();
//   final TextEditingController countryController = TextEditingController();
//   CardFieldInputDetails? _cardDetails;
//   bool _loading = false;

//   Future<void> _registerAndPay() async {
//     setState(() => _loading = true);
//     try {
//       final dio = Dio();

//       // Registrar usuario
//       final registerResponse = await dio.post(
//         'http://192.168.0.5:8000/api/users/create/',
//         data: {
//           "email": emailController.text.trim(),
//           "username": usernameController.text.trim(),
//           "password": passwordController.text.trim(),
//           "lastname": lastnameController.text.trim(),
//           "country": countryController.text.trim(),
//           "role_id": 3,
//         },
//       );

//       if (registerResponse.statusCode == 201) {
//         // Crear PaymentIntent
//         final paymentIntent = await dio.post(
//           'http://192.168.0.5:8000/api/create-payment-intent/',
//           data: {'amount': (widget.totalAmount * 100).toInt()},
//         );

//         final clientSecret = paymentIntent.data['client_secret'];

//         await Stripe.instance.initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//             paymentIntentClientSecret: clientSecret,
//             merchantDisplayName: 'Mi Tienda E-commerce',
//           ),
//         );

//         await Stripe.instance.presentPaymentSheet();

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("✅ Compra realizada exitosamente")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Error al registrar usuario")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8E8E8),
//       appBar: AppBar(
//         title: const Text('Finalizar Compra'),
//         backgroundColor: const Color(0xFF8B1E3F),
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text("Total a pagar",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               Text("Bs. ${widget.totalAmount.toStringAsFixed(2)}",
//                   style: const TextStyle(fontSize: 24, color: Color(0xFF8B1E3F))),
//               const Divider(height: 30),

//               const Text("Datos personales",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               TextFormField(
//                   controller: emailController,
//                   decoration: const InputDecoration(labelText: "Correo Electrónico *")),
//               TextFormField(
//                   controller: usernameController,
//                   decoration: const InputDecoration(labelText: "Nombre de Usuario *")),
//               TextFormField(
//                   controller: passwordController,
//                   decoration: const InputDecoration(labelText: "Contraseña *"),
//                   obscureText: true),
//               TextFormField(
//                   controller: lastnameController,
//                   decoration: const InputDecoration(labelText: "Apellido *")),
//               TextFormField(
//                   controller: countryController,
//                   decoration: const InputDecoration(labelText: "País *")),

//               const Divider(height: 30),

//               const Text("Método de pago", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               CardFormField(
//                 onCardChanged: (card) {
//                   setState(() {
//                     _cardDetails = card;
//                   });
//                 },
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       _registerAndPay();
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF8B1E3F),
//                     foregroundColor: Colors.white,
//                   ),
//                   child: _loading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text("Finalizar Compra", style: TextStyle(fontSize: 16)),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalAmount;

  const CheckoutScreen({super.key, required this.totalAmount});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  bool _loading = false;

  Future<void> _registerAndPay() async {
    setState(() => _loading = true);
    try {
      final dio = Dio();

      // Registrar usuario
      final registerResponse = await dio.post(
        'http://192.168.0.5:8000/api/users/create/',
        data: {
          "email": emailController.text.trim(),
          "username": usernameController.text.trim(),
          "password": passwordController.text.trim(),
          "lastname": lastnameController.text.trim(),
          "country": countryController.text.trim(),
          "role_id": 3,
        },
      );

      if (registerResponse.statusCode == 201) {
        // Crear PaymentIntent
        final paymentIntent = await dio.post(
          'http://192.168.0.5:8000/api/create-payment-intent/',
          data: {'amount': (widget.totalAmount * 100).toInt()},
        );

        final clientSecret = paymentIntent.data['client_secret'];

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'Mi Tienda E-commerce',
          ),
        );

        await Stripe.instance.presentPaymentSheet();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Compra realizada exitosamente")),
        );

        Navigator.pop(context); // Volver a pantalla anterior
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al registrar usuario")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E8E8),
      appBar: AppBar(
        title: const Text('Finalizar Compra'),
        backgroundColor: const Color(0xFF8B1E3F),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Total a pagar",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Bs. ${widget.totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 24, color: Color(0xFF8B1E3F))),
              const Divider(height: 30),

              const Text("Datos personales",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Correo Electrónico *")),
              TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: "Nombre de Usuario *")),
              TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "Contraseña *"),
                  obscureText: true),
              TextFormField(
                  controller: lastnameController,
                  decoration: const InputDecoration(labelText: "Apellido *")),
              TextFormField(
                  controller: countryController,
                  decoration: const InputDecoration(labelText: "País *")),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _registerAndPay();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B1E3F),
                    foregroundColor: Colors.white,
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Finalizar Compra", style: TextStyle(fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
