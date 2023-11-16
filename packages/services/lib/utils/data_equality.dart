import 'package:collection/collection.dart';

abstract class DataEquality {
  /// {@macro equatable}
  const DataEquality();

  /// {@template equatable_props}
  /// The list of properties that will be used to determine whether
  /// two instances are equal.
  /// {@endtemplate}
  List<Object?> get props;

  /// {@template equatable_stringify}
  /// If set to `true`, the [toString] method will be overridden to output
  /// this instance's [props].
  ///
  /// A global default value for [stringify] can be set using
  /// `EquatableConfig.stringify`.
  ///
  /// If this instance's [stringify] is set to null, the value of
  /// `EquatableConfig.stringify` will be used instead. This defaults to
  /// `false`.
  /// {@endtemplate}
  // ignore: avoid_returning_null
  bool? get stringify => null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DataEquality &&
              runtimeType == other.runtimeType &&
              equals(props, other.props);

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode(props);

  @override
  String toString() {
    switch (stringify) {
      case true:
        return mapPropsToString(runtimeType, props);
      case false:
        return '$runtimeType';
      default:
        return EquatableConfig.stringify == true
            ? mapPropsToString(runtimeType, props)
            : '$runtimeType';
    }
  }
}


/// Returns a `hashCode` for [props].
int mapPropsToHashCode(Iterable? props) =>
    _finish(props == null ? 0 : props.fold(0, _combine));

const DeepCollectionEquality _equality = DeepCollectionEquality();

/// Determines whether [list1] and [list2] are equal.
bool equals(List? list1, List? list2) {
  if (identical(list1, list2)) return true;
  if (list1 == null || list2 == null) return false;
  final length = list1.length;
  if (length != list2.length) return false;

  for (var i = 0; i < length; i++) {
    final dynamic unit1 = list1[i];
    final dynamic unit2 = list2[i];

    if (_isEquatable(unit1) && _isEquatable(unit2)) {
      if (unit1 != unit2) return false;
    } else if (unit1 is Iterable || unit1 is Map) {
      if (!_equality.equals(unit1, unit2)) return false;
    } else if (unit1?.runtimeType != unit2?.runtimeType) {
      return false;
    } else if (unit1 != unit2) {
      return false;
    }
  }
  return true;
}

bool _isEquatable(dynamic object) {
  return object is DataEquality || object is EquatableMixin;
}

/// Jenkins Hash Functions
/// https://en.wikipedia.org/wiki/Jenkins_hash_function
int _combine(int hash, dynamic object) {
  if (object is Map) {
    object.keys
        .sorted((dynamic a, dynamic b) => a.hashCode - b.hashCode)
        .forEach((dynamic key) {
      hash = hash ^ _combine(hash, <dynamic>[key, object[key]]);
    });
    return hash;
  }
  if (object is Set) {
    object = object.sorted(((dynamic a, dynamic b) => a.hashCode - b.hashCode));
  }
  if (object is Iterable) {
    for (final value in object) {
      hash = hash ^ _combine(hash, value);
    }
    return hash ^ object.length;
  }

  hash = 0x1fffffff & (hash + object.hashCode);
  hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
  return hash ^ (hash >> 6);
}

int _finish(int hash) {
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}

/// Returns a string for [props].
String mapPropsToString(Type runtimeType, List<Object?> props) =>
    '$runtimeType(${props.map((prop) => prop.toString()).join(', ')})';


/// A mixin that helps implement equality
/// without needing to explicitly override [operator ==] and [hashCode].
///
/// Like with extending [DataEquality], the [EquatableMixin] overrides the
/// [operator ==] as well as the [hashCode] based on the provided [props].
mixin EquatableMixin {
  /// {@macro equatable_props}
  List<Object?> get props;

  /// {@macro equatable_stringify}
  // ignore: avoid_returning_null
  bool? get stringify => null;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EquatableMixin &&
            runtimeType == other.runtimeType &&
            equals(props, other.props);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ mapPropsToHashCode(props);

  @override
  String toString() {
    switch (stringify) {
      case true:
        return mapPropsToString(runtimeType, props);
      case false:
        return '$runtimeType';
      default:
        return EquatableConfig.stringify == true
            ? mapPropsToString(runtimeType, props)
            : '$runtimeType';
    }
  }
}


/// The default configurion for all [DataEquality] instances.
///
/// Currently, this config class only supports setting a default value for
/// [stringify].
///
/// See also:
/// * [DataEquality.stringify]
class EquatableConfig {
  /// {@template stringify}
  /// Global [stringify] setting for all [DataEquality] instances.
  ///
  /// If [stringify] is overridden for a particular [DataEquality] instance,
  /// then the local [stringify] value takes precedence
  /// over [EquatableConfig.stringify].
  ///
  /// This value defaults to true in debug mode and false in release mode.
  /// {@endtemplate}
  static bool get stringify {
    if (_stringify == null) {
      assert(() {
        _stringify = true;
        return true;
      }());
    }
    return _stringify ??= false;
  }

  /// {@macro stringify}
  static set stringify(bool value) => _stringify = value;

  static bool? _stringify;
}
