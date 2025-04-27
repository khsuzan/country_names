import 'package:flutter/material.dart';

part 'country.dart';
part 'data.dart';
part 'sorter.dart';

typedef CountryItemBuilder =
    Widget Function(BuildContext context, Country country);

class CountryListView extends StatefulWidget {
  final void Function(Country country)? onSelect;
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
  late List<_InternalCountry> countries;

  @override
  void initState() {
    super.initState();
    countries = switch (widget.sortBy) {
      OrderBy.name => _sovereignCountries,
      OrderBy.code => List<_InternalCountry>.from(_sovereignCountries)
        ..sort((a, b) => a.code.compareTo(b.code)),
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index].toCountry(quality: widget.quality);
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
          leading: Image(image: country.flag, width: 32),
          title: Text(country.name),
          onTap: () => widget.onSelect?.call(country),
        );
      },
    );
  }
}
