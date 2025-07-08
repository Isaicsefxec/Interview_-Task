class PropertyModel {
  PropertyModel.empty()
      : id = '',
        title = '',
        price = 0,
        status = '',
        description = '',
        tags = [],
        images = [],
        agent = AgentModel(name: '', email: '', contact: ''),
        location = LocationModel(
          address: '',
          city: '',
          state: '',
          country: '',
          zip: '',
          latitude: null,
          longitude: null,
        ),
        areaSqFt = 0,
        bedrooms = 0,
        bathrooms = 0,
        currency = 'USD',
        dateListed = DateTime.now();
  final String id;
  final String title;
  final int price;
  final String status;
  final String description;
  final List<String> tags;
  final List<String> images;
  final AgentModel agent;
  final LocationModel location;

  // ✅ New fields from API
  final int areaSqFt;
  final int bedrooms;
  final int bathrooms;
  final String currency;
  final DateTime dateListed;

  PropertyModel({
    required this.id,
    required this.title,
    required this.price,
    required this.status,
    required this.description,
    required this.tags,
    required this.images,
    required this.agent,
    required this.location,
    required this.areaSqFt,
    required this.bedrooms,
    required this.bathrooms,
    required this.currency,
    required this.dateListed,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: json['price'] ?? 0,
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      agent: AgentModel.fromJson(json['agent'] ?? {}),
      location: LocationModel.fromJson(json['location'] ?? {}),
      areaSqFt: json['areaSqFt'] ?? 0,
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      currency: json['currency'] ?? 'USD',
      dateListed: DateTime.tryParse(json['dateListed'] ?? '') ?? DateTime.now(),
    );
  }
}

class AgentModel {
  final String name;
  final String email;
  final String contact;

  AgentModel({
    required this.name,
    required this.email,
    required this.contact,
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      contact: json['contact'] ?? '',
    );
  }
}

class LocationModel {
  final String address;
  final String city;
  final String state;
  final String country;
  final String zip;
  final double? latitude;
  final double? longitude;

  LocationModel({
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.zip,
    this.latitude,
    this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      zip: json['zip'] ?? '',
      latitude: (json['latitude'] is num) ? (json['latitude'] as num).toDouble() : null,
      longitude: (json['longitude'] is num) ? (json['longitude'] as num).toDouble() : null,
    );
  }
}
