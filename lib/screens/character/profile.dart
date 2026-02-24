import 'package:flutter/material.dart';
import '../../data/service/authservice.dart';

class Character extends StatefulWidget {
  const Character({super.key});

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> {
  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.shade100,
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Hồ sơ của tôi",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BeVietnamPro',
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.blue.shade50,
                        child: const Icon(Icons.person, size: 50, color: Colors.blueAccent),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Người dùng ẩn danh",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BeVietnamPro',
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      currentUser?.email ?? "Chưa có email",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontFamily: 'BeVietnamPro',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [

              ],
            ),
          ),
        ],
      ),
    );
  }
}