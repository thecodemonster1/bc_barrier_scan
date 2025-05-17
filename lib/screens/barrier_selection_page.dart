import 'package:flutter/material.dart';
import 'barrier_details_page.dart';
import 'report_page.dart';

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
    'C6': false, // No Laws
    'C2': false, // Market-Based Risks
    'C5': false, // Lack of Awareness and Expertise
    'C1': false, // Regulatory Uncertainty
    'C3': false, // High Sustainability Costs
    'C4': false, // Usage in Underground Economy
  };

  final Map<String, bool> _technologicalBarriers = {
    'A4': false, // Technological Complexity
    'A2': false, // Integration Problems
    'A3': false, // Lack of Standardization
    'A5': false, // Technology Risks
    'A1': false, // Scalability Issues
    'A7': false, // Energy Consumption of Blockchain
    'A6': false, // Privacy Risks
  };

  final Map<String, bool> _organizationalBarriers = {
    'B5': false, // Cultural and Organizational Barriers
    'B4': false, // Stakeholder Resistance
    'B3': false, // Training and Resource Limitations
    'B2': false, // Limited Skilled Workforce/ Resource Persons
    'B1': false, // Lack of Knowledge/Employee Training
    'B6': false, // Complexity of Establishment
    'B7': false, // Limited research
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Barrier Categories'),
      ),
      body: Column(
        children: [
          // Scrollable content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Organization: ${widget.organizationName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Project: ${widget.projectName}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Select barrier categories to assess:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryCard(
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
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryCard(
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
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryCard(
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
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24), // Add some padding at the bottom
                ],
              ),
            ),
          ),

          // Fixed button at the bottom
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (_regulatorySelected ||
                        _technologicalSelected ||
                        _organizationalSelected)
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

  Widget _buildCategoryCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required double weight,
    required VoidCallback onTap,
    required VoidCallback onViewDetails,
  }) {
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
                  Icon(
                    icon,
                    size: 32,
                    color: Colors.blue.shade700,
                  ),
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
                      // Text(
                      //   'Weight: ${(weight * 100).toStringAsFixed(0)}%',
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     color: Colors.grey.shade700,
                      //   ),
                      // ),
                    ],
                  ),
                  // const Spacer(),
                  // Checkbox(
                  //   value: isSelected,
                  //   onChanged: (_) => onTap(),
                  //   activeColor: Colors.blue.shade700,
                  // ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
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
