import 'package:flutter/material.dart';
import 'barrier_details_page.dart';
import 'report_page.dart';
import '../widgets/category_card.dart';

class BarrierSelectionPage extends StatefulWidget {
  final String organizationName;
  final String projectName;

  const BarrierSelectionPage({
    super.key,
    required this.organizationName,
    required this.projectName,
  });

  @override
  State<BarrierSelectionPage> createState() => _BarrierSelectionPageState();
}

class _BarrierSelectionPageState extends State<BarrierSelectionPage> {
  bool _regulatorySelected = false;
  bool _technologicalSelected = false;
  bool _organizationalSelected = false;

  // Selected barriers within each category
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

  bool get _anySelected =>
      _regulatorySelected || _technologicalSelected || _organizationalSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Barrier Categories'),
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
                  'Select barrier categories to assess:',
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
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CategoryCard(
                    title: 'Regulatory Barriers',
                    description: 'Laws, regulations, and market challenges',
                    icon: Icons.gavel,
                    isSelected: _regulatorySelected,
                    weight: 0.74,
                    onTap: () {
                      setState(() {
                        _regulatorySelected = !_regulatorySelected;
                      });
                    },
                    onViewDetails: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BarrierDetailsPage(
                            title: 'Regulatory Barriers',
                            barrierType: 'regulatory',
                            weight: 0.74,
                            barriers: _regulatoryBarriers,
                            organizationName: widget.organizationName,
                            projectName: widget.projectName,
                            onBarriersUpdated:
                                (Map<String, bool> updatedBarriers) {
                              setState(() {
                                _regulatoryBarriers.clear();
                                _regulatoryBarriers.addAll(updatedBarriers);
                                _regulatorySelected =
                                    updatedBarriers.values.contains(true);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CategoryCard(
                    title: 'Technological Barriers',
                    description:
                        'Integration, standardization, and technical risks',
                    icon: Icons.computer,
                    isSelected: _technologicalSelected,
                    weight: 0.19,
                    onTap: () {
                      setState(() {
                        _technologicalSelected = !_technologicalSelected;
                      });
                    },
                    onViewDetails: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BarrierDetailsPage(
                            title: 'Technological Barriers',
                            barrierType: 'technological',
                            weight: 0.19,
                            barriers: _technologicalBarriers,
                            organizationName: widget.organizationName,
                            projectName: widget.projectName,
                            onBarriersUpdated:
                                (Map<String, bool> updatedBarriers) {
                              setState(() {
                                _technologicalBarriers.clear();
                                _technologicalBarriers.addAll(updatedBarriers);
                                _technologicalSelected =
                                    updatedBarriers.values.contains(true);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CategoryCard(
                    title: 'Organizational Barriers',
                    description: 'Culture, workforce, and training limitations',
                    icon: Icons.people,
                    isSelected: _organizationalSelected,
                    weight: 0.08,
                    onTap: () {
                      setState(() {
                        _organizationalSelected = !_organizationalSelected;
                      });
                    },
                    onViewDetails: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BarrierDetailsPage(
                            title: 'Organizational Barriers',
                            barrierType: 'organizational',
                            weight: 0.08,
                            barriers: _organizationalBarriers,
                            organizationName: widget.organizationName,
                            projectName: widget.projectName,
                            onBarriersUpdated:
                                (Map<String, bool> updatedBarriers) {
                              setState(() {
                                _organizationalBarriers.clear();
                                _organizationalBarriers.addAll(updatedBarriers);
                                _organizationalSelected =
                                    updatedBarriers.values.contains(true);
                              });
                            },
                          ),
                        ),
                      );
                    },
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
                onPressed: _anySelected
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportPage(
                              organizationName: widget.organizationName,
                              projectName: widget.projectName,
                              regulatoryBarriers: _regulatorySelected
                                  ? _regulatoryBarriers
                                  : null,
                              technologicalBarriers: _technologicalSelected
                                  ? _technologicalBarriers
                                  : null,
                              organizationalBarriers: _organizationalSelected
                                  ? _organizationalBarriers
                                  : null,
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
}
