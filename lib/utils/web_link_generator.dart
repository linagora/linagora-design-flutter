import 'dart:developer';

/// Utility class for generating web links in flat subdomain format.
///
/// This class generates HTTPS URLs by combining a workplace FQDN with an
/// optional app slug in a flat subdomain structure (e.g., `alice-notes.example.com`).
class WebLinkGenerator {
  /// Maximum length for FQDN to prevent DoS attacks (253 chars per RFC 1035).
  static const int _maxFqdnLength = 253;

  /// Maximum length for slug to prevent DoS attacks (63 chars per RFC 1035).
  static const int _maxSlugLength = 63;

  /// Maximum length for pathname to prevent DoS attacks.
  static const int _maxPathnameLength = 2048;

  /// Regex pattern for validating slugs (lowercase alphanumeric + hyphens, not starting/ending with hyphen).
  static final RegExp _slugPattern = RegExp(r'^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$');

  /// Ensures that a path starts with `/`.
  static String _ensureFirstSlash(String? path) {
    if (path == null || path.isEmpty) return '/';
    return path.startsWith('/') ? path : '/$path';
  }

  /// Validates if a given FQDN looks valid (has at least 2 parts and non-empty).
  ///
  /// Additional validation:
  /// - Must not exceed 253 characters
  /// - Must contain at least one dot
  /// - Must have at least 2 non-empty parts after filtering empty segments
  static bool _isValidFqdn(String fqdn) {
    final trimmed = fqdn.trim();
    if (trimmed.isEmpty || trimmed.length > _maxFqdnLength) return false;
    if (!trimmed.contains('.')) return false;

    // Remove trailing dot if present (valid in DNS)
    final normalized = trimmed.endsWith('.')
        ? trimmed.substring(0, trimmed.length - 1)
        : trimmed;

    final parts = normalized.split('.').where((p) => p.trim().isNotEmpty).toList();
    return parts.length >= 2;
  }

  /// Validates if a given slug is properly formatted.
  ///
  /// A valid slug must:
  /// - Not exceed 63 characters
  /// - Be lowercase alphanumeric with hyphens
  /// - Not start or end with a hyphen
  static bool _isValidSlug(String slug) {
    if (slug.isEmpty || slug.length > _maxSlugLength) return false;
    return _slugPattern.hasMatch(slug);
  }

  /// Generates a web link based on a workplace FQDN and app slug.
  ///
  /// Creates an HTTPS URL in flat subdomain format. If a [slug] is provided,
  /// it will be prepended to the first part of the FQDN with a hyphen.
  ///
  /// Example:
  /// ```dart
  /// final url = WebLinkGenerator.generateWebLink(
  ///   workplaceFqdn: 'alice.example.com',
  ///   slug: 'notes',
  ///   pathname: 'public',
  ///   hash: '/n/4',
  ///   searchParams: [['key', 'value']],
  /// );
  /// // Returns: 'https://alice-notes.example.com/public?key=value#/n/4'
  /// ```
  ///
  /// Parameters:
  /// - [workplaceFqdn]: The base fully qualified domain name (required, must be valid)
  /// - [slug]: Optional app identifier (will be auto-converted to lowercase)
  /// - [pathname]: Optional URL path (will be prefixed with `/` if missing)
  /// - [hash]: Optional URL fragment/hash (will be prefixed with `/` if missing)
  /// - [searchParams]: Optional query parameters as list of [key, value] pairs
  ///
  /// Throws [ArgumentError] when:
  /// - [workplaceFqdn] is invalid or exceeds 253 characters
  /// - [slug] contains invalid characters or exceeds 63 characters
  /// - [pathname] exceeds 2048 characters
  static String generateWebLink({
    required String workplaceFqdn,
    String? slug,
    String? pathname,
    String? hash,
    List<List<String>>? searchParams,
  }) {
    if (!_isValidFqdn(workplaceFqdn)) {
      throw ArgumentError(
        'Invalid workplace FQDN: "$workplaceFqdn". '
        'Must be a valid domain name with at least 2 parts (e.g., "example.com") '
        'and not exceed $_maxFqdnLength characters.',
      );
    }

    if (pathname != null && pathname.length > _maxPathnameLength) {
      throw ArgumentError(
        'Pathname exceeds maximum length of $_maxPathnameLength characters.',
      );
    }

    // Normalize FQDN by trimming and removing trailing dot if present
    final trimmedFqdn = workplaceFqdn.trim();
    final normalizedFqdn = trimmedFqdn.endsWith('.')
        ? trimmedFqdn.substring(0, trimmedFqdn.length - 1)
        : trimmedFqdn;

    // Start from the base host
    String newHost = normalizedFqdn;

    // Only modify the host when slug is non-null and not empty
    if (slug != null && slug.trim().isNotEmpty) {
      // Auto-convert to lowercase and trim for user convenience
      final normalizedSlug = slug.trim().toLowerCase();

      if (!_isValidSlug(normalizedSlug)) {
        throw ArgumentError(
          'Invalid slug: "$slug". '
          'Must be lowercase alphanumeric with hyphens, '
          'not starting/ending with hyphen, '
          'and not exceed $_maxSlugLength characters.',
        );
      }

      final hostParts =
          normalizedFqdn.split('.').where((p) => p.trim().isNotEmpty).toList();

      // Insert slug as a prefix to the first part (flat subdomain)
      hostParts[0] = '${hostParts[0]}-$normalizedSlug';
      newHost = hostParts.join('.');
    }

    final safePath = _ensureFirstSlash(pathname);
    final safeHash =
        (hash == null || hash.isEmpty) ? null : _ensureFirstSlash(hash);

    final queryParams = <String, String>{};
    for (final param in searchParams ?? const []) {
      if (param.length == 2) queryParams[param[0]] = param[1];
    }

    final uri = Uri(
      scheme: 'https',
      host: newHost,
      path: safePath,
      queryParameters: queryParams.isEmpty ? null : queryParams,
      fragment: safeHash,
    );

    return uri.toString();
  }

  /// A safe version of [generateWebLink] that **never throws**.
  ///
  /// Returns `''` (empty string) when an error occurs and logs the error.
  ///
  /// This is useful when you want to generate a link but don't want to handle
  /// exceptions explicitly. Any validation errors will be logged using `dart:developer`.
  ///
  /// Example:
  /// ```dart
  /// final url = WebLinkGenerator.safeGenerateWebLink(
  ///   workplaceFqdn: 'invalid',  // Invalid FQDN
  ///   slug: 'notes',
  /// );
  /// // Returns: '' (empty string) and logs the error
  /// ```
  ///
  /// See [generateWebLink] for parameter documentation.
  static String safeGenerateWebLink({
    required String workplaceFqdn,
    String? slug,
    String? pathname,
    String? hash,
    List<List<String>>? searchParams,
  }) {
    try {
      return generateWebLink(
        workplaceFqdn: workplaceFqdn,
        slug: slug,
        pathname: pathname,
        hash: hash,
        searchParams: searchParams,
      );
    } catch (e, stackTrace) {
      log(
        '[WebLinkGenerator] Error generating web link',
        error: e,
        stackTrace: stackTrace,
      );
      return '';
    }
  }
}
