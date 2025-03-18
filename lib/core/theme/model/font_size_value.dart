enum FontSizeValue {
  small(text: 'Klein', size: 12),
  normal(text: 'Normal', size: 16),
  large(text: 'Groß', size: 20);

  final int size;
  final String text;

  const FontSizeValue({required this.size, required this.text});
}
