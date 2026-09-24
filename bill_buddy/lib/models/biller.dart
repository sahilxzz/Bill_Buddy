class Biller {
  final String id;
  final String name;
  final String category;
  final List<BillerField> fields;

  const Biller({
    required this.id,
    required this.name,
    required this.category,
    required this.fields,
  });

  factory Biller.fromJson(Map<String, dynamic> json) {
    return Biller(
      id: json['_id'],
      name: json['name'],
      category: json['category'],
      fields: (json['fields'] as List)
          .map(
            (field) => BillerField.fromJson(
              field as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class BillerField {
  final String key;
  final String label;
  final String type;
  final bool required;
  final int? minLength;
  final int? maxLength;

  const BillerField({
    required this.key,
    required this.label,
    required this.type,
    required this.required,
    this.minLength,
    this.maxLength,
  });

  factory BillerField.fromJson(Map<String, dynamic> json) {
    return BillerField(
      key: json['key'],
      label: json['label'],
      type: json['type'],
      required: json['required'],
      minLength: json['minLength'],
      maxLength: json['maxLength'],
    );
  }
}