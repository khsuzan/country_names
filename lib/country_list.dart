import 'package:flutter/material.dart';

part 'country.dart';
part 'data.dart';
part 'sorter.dart';

typedef CountryItemBuilder = Widget Function(Country country);
typedef SearchBuilder = Widget Function(TextEditingController controller);

class CountryListView extends StatefulWidget {
  final void Function(Country country)? onSelect;
  final CountryItemBuilder? itemBuilder;
  final SearchBuilder? searchBuilder;
  final OrderBy sortBy;
  final ImageQuality quality;

  const CountryListView({
    super.key,
    this.onSelect,
    this.itemBuilder,
    this.searchBuilder,
    this.sortBy = OrderBy.name,
    this.quality = ImageQuality.small,
  });

  @override
  State<CountryListView> createState() => _CountryListViewState();
}

class _CountryListViewState extends State<CountryListView> {
  late List<_InternalCountry> countries;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    countries = switch (widget.sortBy) {
      OrderBy.name => _sovereignCountries,
      OrderBy.code => List<_InternalCountry>.from(_sovereignCountries)
        ..sort((a, b) => a.code.compareTo(b.code)),
    };

    controller.addListener(() {
      final query = controller.text.toLowerCase();
      setState(() {
        countries =
            switch (widget.sortBy) {
              OrderBy.name => _sovereignCountries,
              OrderBy.code => List<_InternalCountry>.from(_sovereignCountries)
                ..sort((a, b) => a.code.compareTo(b.code)),
            }.where((c) => c.name.toLowerCase().contains(query)).toList();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (widget.searchBuilder != null)
          widget.searchBuilder!.call(controller),
        ...List.generate(countries.length, (index) {
          final country = countries[index].toCountry(quality: widget.quality);
          if (widget.itemBuilder != null) {
            return GestureDetector(
              key: ValueKey(country.code),
              onTap: () => widget.onSelect?.call(country),
              child: AbsorbPointer(
                absorbing: true,
                child: widget.itemBuilder!(country),
              ),
            );
          }
          return ListTile(
            key: ValueKey(country.code),
            leading: Image(image: country.flag, width: 32),
            title: Text(country.name),
            onTap: () => widget.onSelect?.call(country),
          );
        }),
      ],
    );
  }
}
