class BarriersData {
  static const Map<String, Map<String, dynamic>> barriersInfo = {
    // Regulatory Barriers
    'C6': {'description': 'No Laws', 'weight': 0.33},
    'C2': {'description': 'Market-Based Risks', 'weight': 0.20},
    'C5': {'description': 'Lack of Awareness and Expertise', 'weight': 0.16},
    'C1': {'description': 'Regulatory Uncertainty', 'weight': 0.15},
    'C3': {'description': 'High Sustainability Costs', 'weight': 0.09},
    'C4': {'description': 'Usage in Underground Economy', 'weight': 0.08},
    // Technological Barriers
    'A4': {'description': 'Technological Complexity', 'weight': 0.29},
    'A2': {'description': 'Integration Problems', 'weight': 0.21},
    'A3': {'description': 'Lack of Standardization', 'weight': 0.144},
    'A5': {'description': 'Technology Risks', 'weight': 0.143},
    'A1': {'description': 'Scalability Issues', 'weight': 0.08},
    'A7': {'description': 'Energy Consumption of Blockchain', 'weight': 0.07},
    'A6': {'description': 'Privacy Risks', 'weight': 0.06},
    // Organizational Barriers
    'B5': {'description': 'Cultural and Organizational Barriers', 'weight': 0.28},
    'B4': {'description': 'Stakeholder Resistance', 'weight': 0.19},
    'B3': {'description': 'Training and Resource Limitations', 'weight': 0.143},
    'B2': {'description': 'Limited Skilled Workforce/ Resource Persons', 'weight': 0.138},
    'B1': {'description': 'Lack of Knowledge/Employee Training', 'weight': 0.12},
    'B6': {'description': 'Complexity of Establishment', 'weight': 0.07},
    'B7': {'description': 'Limited research', 'weight': 0.06},
  };

  static const Map<String, double> categoryWeights = {
    'regulatory': 0.74,
    'technological': 0.19,
    'organizational': 0.08,
  };
}