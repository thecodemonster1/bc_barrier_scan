import 'package:flutter/material.dart';
import '../data/barriers_data.dart';

class BarrierDetailsPage extends StatefulWidget {
  final String title;
  final String barrierType;
  final double weight;
  final Map<String, bool> barriers;
  final String organizationName;
  final String projectName;
  final Function(Map<String, bool>) onBarriersUpdated;

  const BarrierDetailsPage({
    super.key,
    required this.title,
    required this.barrierType,
    required this.weight,
    required this.barriers,
    required this.organizationName,
    required this.projectName,
    required this.onBarriersUpdated,
  });

  @override
  State<BarrierDetailsPage> createState() => _BarrierDetailsPageState();
}

class _BarrierDetailsPageState extends State<BarrierDetailsPage> {
  late Map<String, bool> _selectedBarriers;

  @override
  void initState() {
    super.initState();
    _selectedBarriers = Map.from(widget.barriers);
  }

  void _toggleBarrier(String code, bool? value) {
    setState(() {
      _selectedBarriers[code] = value ?? false;
    });
  }

  void _selectAll() {
    setState(() {
      for (var key in _selectedBarriers.keys) {
        _selectedBarriers[key] = true;
      }
    });
  }

  void _clearAll() {
    setState(() {
      for (var key in _selectedBarriers.keys) {
        _selectedBarriers[key] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> relevantBarrierCodes = _selectedBarriers.keys.toList()
      ..sort();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Organization: ${widget.organizationName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Project: ${widget.projectName}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Category Weight: ${(widget.weight * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: _selectAll,
                      child: Text(
                        'Select All',
                        style: TextStyle(color: Colors.blue.shade700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _clearAll,
                      child: Text(
                        'Clear All',
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: relevantBarrierCodes.length,
              itemBuilder: (context, index) {
                final code = relevantBarrierCodes[index];
                final description = BarriersData.barriersInfo[code]
                        ?['description'] ??
                    'Unknown';
                final weight =
                    BarriersData.barriersInfo[code]?['weight'] ?? 0.0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: CheckboxListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          code,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            description,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Weight: ${(weight * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    value: _selectedBarriers[code],
                    onChanged: (value) => _toggleBarrier(code, value),
                    activeColor: Colors.blue.shade700,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Save selected barriers
                  widget.onBarriersUpdated(_selectedBarriers);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('SAVE SELECTION'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
