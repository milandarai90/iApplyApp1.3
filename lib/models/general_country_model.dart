class General_country_model {
  final String id;
  final String? country;
  final String? map;
  final List<Guidelines_model> guidelines_data;

  General_country_model({required this.id, required this.country, required this.map, required this.guidelines_data});


}
class Guidelines_model{
  final String? id;
  final String? Guidelines;

  Guidelines_model({required this.id, required this.Guidelines});
}