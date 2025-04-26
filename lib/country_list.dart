import 'package:flutter/material.dart';

part 'country.dart';
part 'data.dart';
part 'sorter.dart';

typedef CountryItemBuilder =
    Widget Function(BuildContext context, InternalCountry country);

class CountryListView extends StatefulWidget {
  final void Function(InternalCountry country)? onSelect;
  final CountryItemBuilder? itemBuilder;
  final OrderBy sortBy;
  final ImageQuality quality;

  const CountryListView({
    super.key,
    this.onSelect,
    this.itemBuilder,
    this.sortBy = OrderBy.name,
    this.quality = ImageQuality.small,
  });

  @override
  State<CountryListView> createState() => _CountryListViewState();
}

class _CountryListViewState extends State<CountryListView> {
  late List<InternalCountry> countries;

  AssetImage getFlag(ImageQuality quality, String code) {
    final subdir = quality == ImageQuality.small ? "_80" : "_160";
    return AssetImage("assets/$subdir/$code.png", package: "country_list");
  }

  @override
  void initState() {
    super.initState();
    countries = switch (widget.sortBy) {
      OrderBy.name => sovereignCountries,
      OrderBy.code => List<InternalCountry>.from(sovereignCountries)
        ..sort((a, b) => a.code.compareTo(b.code)),
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        final flag = getFlag(widget.quality, country.code);
        if (widget.itemBuilder != null) {
          return GestureDetector(
            onTap: () => widget.onSelect?.call(country),
            child: AbsorbPointer(
              absorbing: true,
              child: widget.itemBuilder!(context, country),
            ),
          );
        }
        return ListTile(
          leading: Image(image: flag, width: 32),
          title: Text(country.name),
          onTap: () => widget.onSelect?.call(country),
        );
      },
    );
  }
}
