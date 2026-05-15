/// Extension methods for improved null-safety and null-checking patterns.
/// 
/// These extensions provide consistent, readable ways to check for null and empty values
/// throughout the codebase.

extension NullCheckExtension<T> on T? {
  /// Returns true if value is not null
  bool get isNotNull => this != null;

  /// Returns true if value is null
  bool get isNull => this == null;
}

extension StringExtension on String? {
  /// Returns true if string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns true if string is not null and not empty
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// Returns the string if not null/empty, otherwise returns [defaultValue]
  String orEmpty({String defaultValue = ''}) => isNotNullOrEmpty ? this! : defaultValue;
}

extension ListExtension<T> on List<T>? {
  /// Returns true if list is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns true if list is not null and not empty
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// Returns the list if not null/empty, otherwise returns [defaultValue]
  List<T> orEmpty({List<T>? defaultValue}) =>
      isNotNullOrEmpty ? this! : (defaultValue ?? []);

  /// Returns length of list or 0 if null
  int get lengthOrZero => this?.length ?? 0;
}

extension MapExtension<K, V> on Map<K, V>? {
  /// Returns true if map is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns true if map is not null and not empty
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// Returns the map if not null/empty, otherwise returns [defaultValue]
  Map<K, V> orEmpty({Map<K, V>? defaultValue}) =>
      isNotNullOrEmpty ? this! : (defaultValue ?? {});

  /// Returns length of map or 0 if null
  int get lengthOrZero => this?.length ?? 0;
}

extension IterableExtension<T> on Iterable<T>? {
  /// Returns true if iterable is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns true if iterable is not null and not empty
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// Returns the iterable if not null/empty, otherwise returns [defaultValue]
  Iterable<T> orEmpty({Iterable<T>? defaultValue}) =>
      isNotNullOrEmpty ? this! : (defaultValue ?? []);

  /// Returns length of iterable or 0 if null
  int get lengthOrZero => this?.length ?? 0;
}

extension BoolExtension on bool? {
  /// Returns true if bool is true (handles null as false)
  bool get isTrue => this ?? false;

  /// Returns true if bool is false or null
  bool get isFalse => !(this ?? false);
}
