import 'package:chat/models/sender_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                Provider.of<SenderModel>(context, listen: false)
                    .setEmail(value);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.lightBlueAccent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Enter your email...",
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                Provider.of<SenderModel>(context, listen: false)
                    .setEmail(value);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.lightBlueAccent, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Enter your password...",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(110, 20),
                  backgroundColor: Colors.lightBlueAccent),
              onPressed: () async {
                try {
                  await firebaseAuth.signInWithEmailAndPassword(
                    email:
                        Provider.of<SenderModel>(context, listen: false).email,
                    password: Provider.of<SenderModel>(context, listen: false)
                        .password,
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, "chat");
                } on FirebaseAuthException {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("There is an error. Try again."),
                    ),
                  );
                }
              },
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
