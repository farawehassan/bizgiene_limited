/// This class loads available products while entering data in the sales record
class AvailableProducts {

  /// This method checks whether the [query] matches any available product
  /// It returns a list of product names it matches [matches]
  static List<String> getSuggestions(String query, List<String> products) {
    List<String> matches = List();
    matches.addAll(products);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

}