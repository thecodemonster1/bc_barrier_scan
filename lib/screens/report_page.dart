import 'package:flutter/material.dart';
import '../data/barriers_data.dart';
import '../utils/score_calculator.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class ReportPage extends StatelessWidget {
  final String organizationName;
  final String projectName;
  final Map<String, bool>? regulatoryBarriers;
  final Map<String, bool>? technologicalBarriers;
  final Map<String, bool>? organizationalBarriers;

  const ReportPage({
    super.key,
    required this.organizationName,
    required this.projectName,
    this.regulatoryBarriers,
    this.technologicalBarriers,
    this.organizationalBarriers,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate scores
    double regulatoryScore = ScoreCalculator.calculateCategoryScore(
        regulatoryBarriers, 'regulatory');
    double technologicalScore = ScoreCalculator.calculateCategoryScore(
        technologicalBarriers, 'technological');
    double organizationalScore = ScoreCalculator.calculateCategoryScore(
        organizationalBarriers, 'organizational');

    // Calculate total score
    double totalScore =
        regulatoryScore + technologicalScore + organizationalScore;

    // Calculate percentage score (out of 100%)
    double percentageScore = totalScore * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BC Integration Assessment Report'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.blue.shade50,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Organization: $organizationName',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Project: $projectName',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total Score: ${percentageScore.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildScoreIndicator(percentageScore),
                  const SizedBox(height: 16),
                  Text(
                    ScoreCalculator.getScoreInterpretation(percentageScore),
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Category Breakdown',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (regulatoryBarriers != null)
              _buildCategoryReportCard(
                  context,
                  'Regulatory Barriers',
                  regulatoryBarriers!,
                  BarriersData.categoryWeights['regulatory']!,
                  Icons.gavel,
                  Colors.red.shade100,
                  Colors.red.shade700,
                  'regulatory'),
            if (technologicalBarriers != null)
              _buildCategoryReportCard(
                  context,
                  'Technological Barriers',
                  technologicalBarriers!,
                  BarriersData.categoryWeights['technological']!,
                  Icons.computer,
                  Colors.blue.shade100,
                  Colors.blue.shade700,
                  'technological'),
            if (organizationalBarriers != null)
              _buildCategoryReportCard(
                  context,
                  'Organizational Barriers',
                  organizationalBarriers!,
                  BarriersData.categoryWeights['organizational']!,
                  Icons.people,
                  Colors.green.shade100,
                  Colors.green.shade700,
                  'organizational'),
            const SizedBox(height: 24),
            _buildRecommendationsSection(percentageScore),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  _shareReport(context);
                },
                icon: const Icon(Icons.share),
                label: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'SHARE REPORT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreIndicator(double score) {
    Color indicatorColor;
    if (score < 30) {
      indicatorColor = Colors.green;
    } else if (score < 70) {
      indicatorColor = Colors.orange;
    } else {
      indicatorColor = Colors.red;
    }

    return Container(
      width: double.infinity,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: score / 100,
            child: Container(
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryReportCard(
    BuildContext context,
    String title,
    Map<String, bool> barriers,
    double categoryWeight,
    IconData icon,
    Color backgroundColor,
    Color iconColor,
    String categoryType,
  ) {
    // Calculate category score
    double rawScore = ScoreCalculator.calculateRawCategoryScore(barriers);
    double weightedScore =
        ScoreCalculator.calculateCategoryScore(barriers, categoryType);
    double categoryPercentage = (weightedScore / categoryWeight) * 100;

    // Get selected barriers
    List<String> selectedBarrierCodes = barriers.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Category Impact: ${(categoryPercentage).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
                const Spacer(),
                Text(
                  'Weight: ${(categoryWeight * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: categoryPercentage / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(iconColor),
            ),
          ],
        ),
        children: [
          Container(
            color: backgroundColor.withOpacity(0.3),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Barriers:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                selectedBarrierCodes.isEmpty
                    ? const Text(
                        'No barriers selected in this category.',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : Column(
                        children: selectedBarrierCodes
                            .map(
                              (code) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$code: ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        BarriersData.barriersInfo[code]
                                                ?['description'] ??
                                            'Unknown',
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${((BarriersData.barriersInfo[code]?['weight'] ?? 0.0) * 100).toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection(double score) {
    // Map barrier codes to specific recommendations
    final Map<String, String> barrierRecommendations = {
      // Regulatory
      'C6':
          'Advocate for clear blockchain regulations with industry groups and policymakers.',
      'C2':
          'Develop risk mitigation strategies for market-based uncertainties.',
      'C5':
          'Organize awareness and training sessions for staff and stakeholders.',
      'C1': 'Consult legal experts to navigate regulatory uncertainty.',
      'C3': 'Explore funding or partnerships to offset sustainability costs.',
      'C4': 'Implement robust compliance and anti-fraud measures.',
      // Technological
      'A4':
          'Simplify technical architecture and provide technical documentation.',
      'A2': 'Work closely with IT teams to ensure seamless integration.',
      'A3': 'Adopt or contribute to open standards for blockchain.',
      'A5':
          'Conduct risk assessments and pilot new technologies in controlled environments.',
      'A1': 'Plan for scalability from the outset and monitor performance.',
      'A7': 'Optimize blockchain protocols for energy efficiency.',
      'A6': 'Implement strong privacy and data protection measures.',
      // Organizational
      'B5': 'Foster a culture open to innovation and change.',
      'B4': 'Engage stakeholders early and address their concerns.',
      'B3': 'Invest in training and resource development.',
      'B2': 'Recruit or upskill staff in blockchain technologies.',
      'B1': 'Provide ongoing education and training for employees.',
      'B6': 'Break down implementation into manageable steps.',
      'B7': 'Encourage research and collaboration with academic institutions.',
    };

    // Gather selected barriers
    final selectedCodes = [
      ...?regulatoryBarriers?.entries.where((e) => e.value).map((e) => e.key),
      ...?technologicalBarriers?.entries
          .where((e) => e.value)
          .map((e) => e.key),
      ...?organizationalBarriers?.entries
          .where((e) => e.value)
          .map((e) => e.key),
    ];

    // Build recommendations for selected barriers
    final recommendations = selectedCodes
        .map((code) => barrierRecommendations[code])
        .where((rec) => rec != null)
        .toSet()
        .toList();

    // Fallback if none selected
    if (recommendations.isEmpty) {
      recommendations.add(
          'No specific barriers selected. Proceed with general best practices for blockchain integration.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Recommendations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...recommendations.map((recommendation) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.arrow_right, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          Expanded(child: Text(recommendation!)),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _shareReport(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Text('BC Integration Barriers Report',
              style: pw.TextStyle(
                  fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 12),
          pw.Text('Organization: $organizationName'),
          pw.Text('Project: $projectName'),
          pw.SizedBox(height: 12),
          pw.Text(
              'Total Score: ${((ScoreCalculator.calculateCategoryScore(
                              regulatoryBarriers, "regulatory") +
                          ScoreCalculator.calculateCategoryScore(
                              technologicalBarriers, "technological") +
                          ScoreCalculator.calculateCategoryScore(
                              organizationalBarriers, "organizational")) *
                      100).toStringAsFixed(1)}%'),
          pw.SizedBox(height: 12),
          pw.Text('Selected Barriers:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ...[
            ...?regulatoryBarriers
                ?.entries
                .where((e) => e.value)
                .map((e) => pw.Bullet(
                    text:
                        'Regulatory: ${e.key} - ${BarriersData.barriersInfo[e.key]?['description'] ?? ''}')),
            ...?technologicalBarriers
                ?.entries
                .where((e) => e.value)
                .map((e) => pw.Bullet(
                    text:
                        'Technological: ${e.key} - ${BarriersData.barriersInfo[e.key]?['description'] ?? ''}')),
            ...?organizationalBarriers
                ?.entries
                .where((e) => e.value)
                .map((e) => pw.Bullet(
                    text:
                        'Organizational: ${e.key} - ${BarriersData.barriersInfo[e.key]?['description'] ?? ''}')),
          ],
          pw.SizedBox(height: 12),
          pw.Text('Recommendations:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ..._getPdfRecommendations(),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/bc_barriers_report.pdf');
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }

  // Helper for PDF recommendations
  List<pw.Widget> _getPdfRecommendations() {
    final Map<String, String> barrierRecommendations = {
      // Regulatory
      'C6':
          'Advocate for clear blockchain regulations with industry groups and policymakers.',
      'C2':
          'Develop risk mitigation strategies for market-based uncertainties.',
      'C5':
          'Organize awareness and training sessions for staff and stakeholders.',
      'C1': 'Consult legal experts to navigate regulatory uncertainty.',
      'C3': 'Explore funding or partnerships to offset sustainability costs.',
      'C4': 'Implement robust compliance and anti-fraud measures.',
      // Technological
      'A4':
          'Simplify technical architecture and provide technical documentation.',
      'A2': 'Work closely with IT teams to ensure seamless integration.',
      'A3': 'Adopt or contribute to open standards for blockchain.',
      'A5':
          'Conduct risk assessments and pilot new technologies in controlled environments.',
      'A1': 'Plan for scalability from the outset and monitor performance.',
      'A7': 'Optimize blockchain protocols for energy efficiency.',
      'A6': 'Implement strong privacy and data protection measures.',
      // Organizational
      'B5': 'Foster a culture open to innovation and change.',
      'B4': 'Engage stakeholders early and address their concerns.',
      'B3': 'Invest in training and resource development.',
      'B2': 'Recruit or upskill staff in blockchain technologies.',
      'B1': 'Provide ongoing education and training for employees.',
      'B6': 'Break down implementation into manageable steps.',
      'B7': 'Encourage research and collaboration with academic institutions.',
    };

    final selectedCodes = [
      ...?regulatoryBarriers?.entries.where((e) => e.value).map((e) => e.key),
      ...?technologicalBarriers?.entries.where((e) => e.value).map((e) => e.key),
      ...?organizationalBarriers?.entries.where((e) => e.value).map((e) => e.key),
    ];

    final recommendations = selectedCodes
        .map((code) => barrierRecommendations[code])
        .where((rec) => rec != null)
        .toSet()
        .toList();

    if (recommendations.isEmpty) {
      return [
        pw.Bullet(
            text:
                'No specific barriers selected. Proceed with general best practices for blockchain integration.')
      ];
    }

    return recommendations.map((rec) => pw.Bullet(text: rec!)).toList();
  }
}
