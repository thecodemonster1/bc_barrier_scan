import '../data/barriers_data.dart';

class ScoreCalculator {
  static double calculateRawCategoryScore(Map<String, bool>? barriers) {
    if (barriers == null) return 0.0;

    double score = 0.0;
    barriers.forEach((code, isSelected) {
      if (isSelected) {
        score += BarriersData.barriersInfo[code]?['weight'] ?? 0.0;
      }
    });

    return score;
  }

  static double calculateCategoryScore(Map<String, bool>? barriers, String categoryType) {
    if (barriers == null) return 0.0;

    double rawScore = calculateRawCategoryScore(barriers);
    double categoryWeight = BarriersData.categoryWeights[categoryType] ?? 0.0;

    return rawScore * categoryWeight;
  }

  static String getScoreInterpretation(double score) {
    if (score < 30) {
      return 'Low barriers to blockchain integration. Implementation should be relatively straightforward.';
    } else if (score < 70) {
      return 'Moderate barriers to blockchain integration. Some challenges may need to be addressed.';
    } else {
      return 'High barriers to blockchain integration. Significant challenges need to be overcome.';
    }
  }
}