class Farm {
  final String id;
  final String farmerId;
  final String name;
  final double sizeAcres;
  final String region;
  final String district;
  final String location;
  final String mainCrop;
  final String contactPerson;

  Farm({
    required this.id,
    required this.farmerId,
    required String name,
    required double sizeAcres,
    required String region,
    required String district,
    required String location,
    required String mainCrop,
    required String contactPerson,
  })  : name = _normalizeText(name),
        sizeAcres = sizeAcres,
        region = region,
        district = district,
        location = _normalizeText(location),
        mainCrop = _normalizeText(mainCrop),
        contactPerson = _normalizePersonName(contactPerson) {
    _validateIds(id, farmerId);
    _validateSize(sizeAcres);
    _validateRegionAndDistrict(region, district);
    _validateText(this.name, 'Farm name', minWords: 1);
    _validateText(this.location, 'Location', minWords: 1);
    _validateText(this.mainCrop, 'Main crop', minWords: 1);
    _validateText(this.contactPerson, 'Contact person', minWords: 2);
  }

  // =======================
  // UGANDA REGIONS DATA
  // =======================

  static const Map<String, List<String>> ugandaRegions = {
    'Central Region': [
      "Buikwe",
      "Bukomansimbi",
      "Butambala",
      "Buvuma",
      "Gomba",
      "Kalangala",
      "Kalungu",
      "Kampala",
      "Kayunga",
      "Kiboga",
      "Kyankwanzi",
      "Luweero",
      "Lwengo",
      "Lyantonde",
      "Masaka",
      "Mityana",
      "Mpigi",
      "Mubende",
      "Mukono",
      "Nakaseke",
      "Nakasongola",
      "Rakai",
      "Sembabule",
      "Wakiso",
      "Kyotera",
      "Kasanda"
    ],
    'Eastern Region': [
      "Amuria",
      "Budaka",
      "Bududa",
      "Bugiri",
      "Bukedea",
      "Bulambuli",
      "Bukwa",
      "Busia",
      "Butaleja",
      "Buyende",
      "Iganga",
      "Jinja",
      "Kaberamaido",
      "Kaliro",
      "Kamuli",
      "Kapchorwa",
      "Katakwi",
      "Kibuku",
      "Kumi",
      "Kween",
      "Luuka",
      "Manafwa",
      "Mayuge",
      "Mbale",
      "Namayingo",
      "Namutumba",
      "Ngora",
      "Pallisa",
      "Serere",
      "Sironko",
      "Soroti",
      "Tororo",
      "Butebo",
      "Namisindwa",
      "Bugweri",
      "Kapelebyongo"
    ],
    'Northern Region': [
      "Abim",
      "Adjumani",
      "Agago",
      "Alebtong",
      "Amolatar",
      "Amudat",
      "Amuru",
      "Apac",
      "Arua",
      "Dokolo",
      "Gulu",
      "Kaabong",
      "Kitgum",
      "Koboko",
      "Kole",
      "Kotido",
      "Lamwo",
      "Lira",
      "Maracha",
      "Moroto",
      "Moyo",
      "Nakapiripirit",
      "Napak",
      "Nebbi",
      "Nwoya",
      "Otuke",
      "Oyam",
      "Pader",
      "Yumbe",
      "Zombo",
      "Omoro",
      "Kwania",
      "Nabilatuk",
      "Obongi",
      "Madi-Okollo",
      "Karenga"
    ],
    'Western Region': [
      "Buhweju",
      "Buliisa",
      "Bundibugyo",
      "Bushenyi",
      "Hoima",
      "Ibanda",
      "Isingiro",
      "Kabale",
      "Kabarole",
      "Kamwenge",
      "Kanungu",
      "Kasese",
      "Kibaale",
      "Kiruhura",
      "Kiryandongo",
      "Kisoro",
      "Kyenjojo",
      "Masindi",
      "Mbarara",
      "Mitooma",
      "Ntoroko",
      "Ntungamo",
      "Rubirizi",
      "Rukungiri",
      "Sheema",
      "Kagadi",
      "Kakumiro",
      "Rubanda",
      "Kibuube",
      "Kazo",
      "Rwampara",
      "Kitagwenda",
      "Bunyangabu"
    ],
  };

  // =======================
  // NORMALIZATION
  // =======================

  static String _normalizeText(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .toLowerCase()
        .split(' ')
        .map((p) => p[0].toUpperCase() + p.substring(1))
        .join(' ');
  }

  static String _normalizePersonName(String value) {
    return _normalizeText(value);
  }

  // =======================
  // INTERNAL VALIDATION
  // =======================

  static void _validateIds(String id, String farmerId) {
    if (id.isEmpty || farmerId.isEmpty) {
      throw ArgumentError('IDs cannot be empty');
    }
  }

  static void _validateSize(double size) {
    if (size <= 0 || size.isNaN || size.isInfinite) {
      throw ArgumentError('Farm size must be greater than zero');
    }
  }

  static void _validateText(String value, String field,
      {required int minWords}) {
    final parts = value.split(' ');
    if (parts.length < minWords) {
      throw ArgumentError('$field must contain at least $minWords word(s)');
    }
    for (final p in parts) {
      if (p.length < 3 || !RegExp(r'^[A-Za-z]+$').hasMatch(p)) {
        throw ArgumentError(
          '$field must contain only letters and at least 3 characters',
        );
      }
    }
  }

  static void _validateRegionAndDistrict(String region, String district) {
    if (!ugandaRegions.containsKey(region)) {
      throw ArgumentError('Invalid region selected');
    }
    if (!ugandaRegions[region]!.contains(district)) {
      throw ArgumentError(
        'District does not belong to the selected region',
      );
    }
  }

  // =======================
  // FORM HELPERS (UI)
  // =======================

  static List<String> getRegions() => ugandaRegions.keys.toList();

  static List<String> getDistrictsForRegion(String region) =>
      ugandaRegions[region] ?? [];

  static String? validateDropdown(String? value, String field) {
    if (value == null || value.isEmpty) {
      return '$field is required';
    }
    return null;
  }

  static String? validateTextField(String? value, String field,
      {int minWords = 1}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  static String? validateSizeField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Farm size is required';
    }
    final parsed = double.tryParse(value);
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid size greater than zero';
    }
    return null;
  }

  // =======================
  // SERIALIZATION
  // =======================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'name': name,
      'sizeAcres': sizeAcres,
      'region': region,
      'district': district,
      'location': location,
      'mainCrop': mainCrop,
      'contactPerson': contactPerson,
    };
  }

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
      id: json['id'],
      farmerId: json['farmerId'],
      name: json['name'],
      sizeAcres: (json['sizeAcres'] as num).toDouble(),
      region: json['region'],
      district: json['district'],
      location: json['location'],
      mainCrop: json['mainCrop'],
      contactPerson: json['contactPerson'],
    );
  }
}
