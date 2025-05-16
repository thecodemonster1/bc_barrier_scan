import 'package:flutter/material.dart';
import '../data/barriers_data.dart';
import '../utils/score_calculator.dart';

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
    double totalScore = regulatoryScore + technologicalScore + organizationalScore;
    
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
                'regulatory'
              ),
            if (technologicalBarriers != null)
              _buildCategoryReportCard(
                context,
                'Technological Barriers',
                technologicalBarriers!,
                BarriersData.categoryWeights['technological']!,
                Icons.computer,
                Colors.blue.shade100,
                Colors.blue.shade700,
                'technological'
              ),
            if (organizationalBarriers != null)
              _buildCategoryReportCard(
                context,
                'Organizational Barriers',
                organizationalBarriers!,
                BarriersData.categoryWeights['organizational']!,
                Icons.people,
                Colors.green.shade100,
                Colors.green.shade700,
                'organizational'
              ),
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
    double weightedScore = ScoreCalculator.calculateCategoryScore(barriers, categoryType);
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
                                        BarriersData.barriersInfo[code]?['description'] ??
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
    List<String> recommendations = [];
    
    if (score > 60) {
      recommendations = [
        'Consider starting with small proof-of-concept projects',
        'Invest in training and education about blockchain technology',
        'Engage with regulatory bodies to address compliance concerns',
        'Partner with experienced blockchain implementation specialists',
        'Create a detailed implementation roadmap addressing identified barriers'
      ];
    } else if (score > 30) {
      recommendations = [
        'Identify specific use cases where blockchain adds clear value',
        'Build partnerships with technology providers experienced in blockchain',
        'Develop a phased implementation strategy',
        'Conduct training programs to address knowledge gaps',
        'Start with non-critical applications to gain experience'
      ];
    } else {
      recommendations = [
        'Proceed with blockchain implementation planning',
        'Document your integration process to share best practices',
        'Consider becoming a mentor organization to others in your industry',
        'Focus on optimizing your blockchain implementation',
        'Explore advanced blockchain features for your business'
      ];
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
                      Expanded(child: Text(recommendation)),
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

  void _shareReport(BuildContext context) {
    // In a real app, this would generate and share the report
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Shared'),
        content: const Text(
          'Your BC Integration Barriers report has been generated and is ready to share.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'OK',
              style: TextStyle(color: Colors.blue.shade700),
            ),
          ),
        ],
      ),
    );
  }
}