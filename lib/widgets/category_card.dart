import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final double weight;
  final VoidCallback onTap;
  final VoidCallback onViewDetails;

  const CategoryCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.weight,
    required this.onTap,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? Colors.blue.shade700 : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 32, color: Colors.blue.shade700),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Weight: ${(weight * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => onTap(),
                    activeColor: Colors.blue.shade700,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: onViewDetails,
                icon: const Icon(Icons.visibility),
                label: const Text('VIEW DETAILS'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}