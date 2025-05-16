import 'package:flutter/material.dart';
import 'barrier_item.dart';

class BarrierCategory {
  final String id;
  final String title;
  final String description;
  final double weight;
  final IconData icon;
  final Map<String, BarrierItem> barriers;

  const BarrierCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.weight,
    required this.icon,
    required this.barriers,
  });
}