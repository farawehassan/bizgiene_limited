/// This class loads available products while entering data in the sales record
class Suggestions {

  /// This method checks whether the [query] matches any available product
  /// It returns a list of product names it matches [matches]
  static List<String> getProductSuggestions(String query, List<String> products) {
    List<String> matches = List();
    matches.addAll(products);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  /// This method checks whether the [query] matches any customer name
  /// It returns a list of customer names it matches [matches]
  static List<String> getCustomerSuggestions(String query, List<String> customerNames) {
    List<String> matches = List();
    matches.addAll(customerNames);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

}