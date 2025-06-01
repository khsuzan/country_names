part of 'country_list.dart';

class _InternalCountry {
  final String name;
  final String code;

  const _InternalCountry({required this.name, required this.code});

  Country toCountry({required ImageQuality quality}) {
    return Country._(getFlag(quality, code), name: name, code: code);
  }

  String getFlag(ImageQuality quality, String code) {
    final subdir = quality == ImageQuality.small ? "_80" : "_160";
    return "assets/$subdir/$code.png";
  }
}

class Country {
  final String name;
  final String code;
  final String _flag;

  const Country._(this._flag,{required this.name, required this.code});

  AssetImage get flag => AssetImage(_flag, package: "country_names");
}
