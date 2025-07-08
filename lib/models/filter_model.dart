class FilterModel {
  final String? location;
  final int? minPrice;
  final int? maxPrice;
  final String? status;
  final List<String> tags;

  const FilterModel({
    this.location,
    this.minPrice,
    this.maxPrice,
    this.status,
    this.tags = const [],
  });

  FilterModel copyWith({
    String? location,
    int? minPrice,
    int? maxPrice,
    String? status,
    List<String>? tags,
  }) {
    return FilterModel(
      location: location ?? this.location,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      status: status ?? this.status,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toQueryParams() {
    return {
      if (location != null) 'location': location,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      if (status != null) 'status': status,
      if (tags.isNotEmpty) 'tags': tags,
    };
  }

  bool get isEmpty =>
      location == null &&
          minPrice == null &&
          maxPrice == null &&
          status == null &&
          tags.isEmpty;

  bool get isNotEmpty => !isEmpty;
}
