part of 'country_list.dart';

class InternalCountry {
  final String name;
  final String code;

  const InternalCountry({required this.name, required this.code});

  factory InternalCountry.fromJson(Map<String, dynamic> json) {
    return InternalCountry(
      name: json['name'],
      code: json['code']
    );
  }
}

class Country {
  final String name;
  final String code;
  final String flag;
  const Country({required this.name, required this.code, required this.flag});
}
