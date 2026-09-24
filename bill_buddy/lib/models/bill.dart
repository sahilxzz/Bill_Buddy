import 'package:flutter/material.dart';

class Bill {
  final IconData icon;
  final String category;
  final String biller;
  final String amount;
  final String due;
  //final String status; 

  const Bill({
    required this.icon,
    required this.category,
    required this.biller,
    required this.amount,
    required this.due,
    //required this.status,
  });
}