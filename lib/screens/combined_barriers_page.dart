import 'package:flutter/material.dart';
import '../data/barriers_data.dart';
import 'report_page.dart';

class CombinedBarriersPage extends StatefulWidget {
  final String organizationName;
  final String projectName;

  const CombinedBarriersPage({
    super.key,
    required this.organizationName,
    required this.projectName,
  });

  @override
  State<CombinedBarriersPage> createState() => _CombinedBarriersPageState();
}

class _CombinedBarriersPageState extends State<CombinedBarriersPage> {
  // All barriers combined
  final Map<String, bool> _regulatoryBarriers = {
    'C6': false,
    'C2': false,
    'C5': false,
    'C1': false,
    'C3': false,
    'C4': false,
  };

  final Map<String, bool> _technologicalBarriers = {
    'A4': false,
    'A2': false,
    'A3': false,
    'A5': false,
    'A1': false,
    'A7': false,
    'A6': false,
  };

  final Map<String, bool> _organizationalBarriers = {
    'B5': false,
    'B4': false,
    'B3': false,
    'B2': false,
    'B1': false,
    'B6': false,
    'B7': false,
  };

  void _toggleBarrier(String code, bool? value) {
    setState(() {
      if (code.startsWith('C')) {
        _regulatoryBarriers[code] = value ?? false;
      } else if (code.startsWith('A')) {
        _technologicalBarriers[code] = value ?? false;
      } else if (code.startsWith('B')) {
        _organizationalBarriers[code] = value ?? false;
      }
    });
  }

  bool _anyBarriersSelected() {
    return _regulatoryBarriers.values.contains(true) ||
        _technologicalBarriers.values.contains(true) ||
        _organizationalBarriers.values.contains(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Barriers'),
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
                const Text(
                  'Select barriers that affect your blockchain integration project',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySection(
                    'Regulatory Barriers',
                    Icons.gavel,
                    Colors.red.shade700,
                    _regulatoryBarriers,
                    0.74,
                  ),
                  _buildCategorySection(
                    'Technological Barriers',
                    Icons.computer,
                    Colors.blue.shade700,
                    _technologicalBarriers,
                    0.19,
                  ),
                  _buildCategorySection(
                    'Organizational Barriers',
                    Icons.people,
                    Colors.green.shade700,
                    _organizationalBarriers,
                    0.08,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _anyBarriersSelected()
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportPage(
                              organizationName: widget.organizationName,
                              projectName: widget.projectName,
                              regulatoryBarriers: _regulatoryBarriers,
                              technologicalBarriers: _technologicalBarriers,
                              organizationalBarriers: _organizationalBarriers,
                            ),
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.assessment),
                label: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'GENERATE REPORT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    String title,
    IconData icon,
    Color iconColor,
    Map<String, bool> barriers,
    double categoryWeight,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: iconColor,
                          ),
                        ),
                        Text(
                          '(Weight: ${(categoryWeight * 100).toStringAsFixed(0)}%)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildQuickSelectionButtons(barriers),
                ],
              ),
            ],
          ),
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
        ...barriers.keys.map((code) => _buildBarrierItem(
              code,
              BarriersData.barriersInfo[code]?['description'] ?? 'Unknown',
              BarriersData.barriersInfo[code]?['weight'] ?? 0.0,
              barriers[code] ?? false,
            )),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildQuickSelectionButtons(Map<String, bool> barriers) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              for (var key in barriers.keys) {
                barriers[key] = true;
              }
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'All',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () {
            setState(() {
              for (var key in barriers.keys) {
                barriers[key] = false;
              }
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'None',
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBarrierItem(
    String code,
    String description,
    double weight,
    bool isSelected,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      elevation: 0.5,
      child: CheckboxListTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              code,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                description,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
        subtitle: Text(
          'Weight: ${(weight * 100).toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
          ),
        ),
        value: isSelected,
        onChanged: (value) => _toggleBarrier(code, value),
        activeColor: Colors.blue.shade700,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
      ),
    );
  }
}
