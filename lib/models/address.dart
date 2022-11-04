class Address {
  String? name;
  String? phoneNumber;
  String? streetNumber;
  String? flatHouseNummber;
  String? city;
  String? stateCountry;
  String? completeAddress;

  Address(
      {this.name,
      this.phoneNumber,
      this.streetNumber,
      this.flatHouseNummber,
      this.city,
      this.stateCountry,
      this.completeAddress});

  Address.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    streetNumber = json['streetNumber'];
    flatHouseNummber = json['flatHouseNummber'];
    city = json['city'];
    stateCountry = json['stateCountry'];
    completeAddress = json['completeAddress'];
  }
}
