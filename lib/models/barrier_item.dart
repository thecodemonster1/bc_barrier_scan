class BarrierItem {
  final String code;
  final String description;
  final double weight;
  bool isSelected;

  BarrierItem({
    required this.code,
    required this.description,
    required this.weight,
    this.isSelected = false,
  });
}