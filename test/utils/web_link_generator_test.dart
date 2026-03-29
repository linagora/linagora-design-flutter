import 'package:flutter_test/flutter_test.dart';
import 'package:linagora_design_flutter/utils/web_link_generator.dart';

void main() {
  group('WebLinkGenerator', () {
    test('should generate correct link for flat subdomain', () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: 'alice.example.app',
        searchParams: [
          ['sharecode', 'sharingIsCaring'],
          ['username', 'alice'],
        ],
        pathname: 'public',
        hash: '/n/4',
        slug: 'notes',
      );

      expect(
        result,
        'https://alice-notes.example.app/public?sharecode=sharingIsCaring&username=alice#/n/4',
      );
    });

    test('should prepend slash to path and hash if missing', () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: 'bob.example.tools',
        pathname: 'files',
        hash: 'folder/123',
        slug: 'drive',
      );

      expect(result, 'https://bob-drive.example.tools/files#/folder/123');
    });

    test('should work with no search params', () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: 'charlie.domain.com',
        slug: 'settings',
      );

      expect(result, 'https://charlie-settings.domain.com/');
    });

    test('should throw when workplaceFqdn is empty', () {
      expect(
        () => WebLinkGenerator.generateWebLink(
          workplaceFqdn: '',
          slug: 'notes',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw when workplaceFqdn only contains TLD', () {
      expect(
        () => WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'com',
          slug: 'notes',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw when workplaceFqdn has no dot', () {
      expect(
        () => WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'localhost',
          slug: 'notes',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should handle malformed FQDN gracefully (multiple dots)', () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: '....example..app',
        slug: 'notes',
      );

      expect(result.startsWith('https://'), isTrue);
      expect(result.contains('-notes'), isTrue);
    });

    test('should ignore malformed searchParams', () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: 'dave.example.app',
        slug: 'drive',
        searchParams: [
          ['username'],
          ['key', 'value'],
        ],
      );

      expect(result, 'https://dave-drive.example.app/?key=value');
    });

    test('should not add fragment when hash is empty string', () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: 'eve.example.app',
        slug: 'settings',
        hash: '',
      );

      expect(result, 'https://eve-settings.example.app/');
    });

    test('should keep original host when slug is null', () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: 'alice.example.app',
        slug: null,
      );

      expect(result, 'https://alice.example.app/');
    });

    test('should keep original host when slug is empty', () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: 'alice.example.app',
        slug: '',
      );

      expect(result, 'https://alice.example.app/');
    });

    test('should keep original host when slug is only whitespace', () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: 'bob.example.app',
        slug: '   ',
      );

      expect(result, 'https://bob.example.app/');
    });

    test('generateWebLink should include path and no hash when hash is null',
        () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: 'alice.example.app',
        slug: 'notes',
        pathname: 'welcome',
        hash: null,
      );

      expect(result, 'https://alice-notes.example.app/welcome');
      expect(result.contains('#'), isFalse);
    });

    test('generateWebLink should include path and no hash when hash is empty',
        () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: 'bob.example.app',
        slug: 'drive',
        pathname: 'folder/123',
        hash: '',
      );

      expect(result, 'https://bob-drive.example.app/folder/123');
      expect(result.contains('#'), isFalse);
    });

    test('generateWebLink should return root path when pathname is null', () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: 'charlie.example.app',
        slug: 'settings',
        pathname: null,
      );

      expect(result, 'https://charlie-settings.example.app/');
      expect(result.contains('#'), isFalse);
    });

    test(
        'generateWebLink should include path and no hash when slug is null and only pathname is provided',
        () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: 'alice.example.app',
        slug: null,
        pathname: 'welcome',
      );

      expect(result, 'https://alice.example.app/welcome');
      expect(result.contains('#'), isFalse);
    });

    test(
        'generateWebLink should include path and no hash when slug is empty and only pathname is provided',
        () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: 'bob.example.app',
        slug: '',
        pathname: 'dashboard',
      );

      expect(result, 'https://bob.example.app/dashboard');
      expect(result.contains('#'), isFalse);
    });

    test(
        'generateWebLink should handle multi-segment pathname with leading slash when slug is null',
        () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: 'alice.example.app',
        slug: null,
        pathname: '/name1/name2',
      );

      expect(result, 'https://alice.example.app/name1/name2');
      expect(result.contains('#'), isFalse);
    });

    test(
        'generateWebLink should handle multi-segment pathname without leading slash when slug is null',
        () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: 'bob.example.app',
        slug: null,
        pathname: 'name1/name2',
      );

      expect(result, 'https://bob.example.app/name1/name2');
      expect(result.contains('#'), isFalse);
    });

    test(
        'generateWebLink should handle deep multi-segment pathname with leading slash when slug is empty',
        () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: 'charlie.example.app',
        slug: '',
        pathname: '/a/b/c/d',
      );

      expect(result, 'https://charlie.example.app/a/b/c/d');
      expect(result.contains('#'), isFalse);
    });

    test(
        'generateWebLink should handle deep multi-segment pathname without leading slash when slug is empty',
        () {
      final result = WebLinkGenerator.generateWebLink(
        workplaceFqdn: 'dave.example.app',
        slug: '',
        pathname: 'a/b/c/d',
      );

      expect(result, 'https://dave.example.app/a/b/c/d');
      expect(result.contains('#'), isFalse);
    });

    test('safeGenerateWebLink should return empty string on invalid FQDN', () {
      final result = WebLinkGenerator.safeGenerateWebLink(
        workplaceFqdn: '',
        slug: 'notes',
      );

      expect(result, '');
    });

    test('safeGenerateWebLink should return valid URL on missing slug', () {
      final result = WebLinkGenerator.safeGenerateWebLink(
        workplaceFqdn: 'alice.example.app',
        slug: '',
      );

      expect(result, 'https://alice.example.app/');
    });

    test('safeGenerateWebLink should still return valid URL when input ok', () {
      final result = WebLinkGenerator.safeGenerateWebLink(
        workplaceFqdn: 'bob.example.app',
        slug: 'drive',
      );

      expect(result, 'https://bob-drive.example.app/');
    });

    test('safeGenerateWebLink should handle slug = null gracefully', () {
      final result = WebLinkGenerator.safeGenerateWebLink(
        workplaceFqdn: 'example.com',
        slug: null,
      );

      expect(result, 'https://example.com/');
    });

    test(
        'safeGenerateWebLink should include path and no hash when hash is null',
        () {
      final result = WebLinkGenerator.safeGenerateWebLink(
        workplaceFqdn: 'dave.example.app',
        slug: 'profile',
        pathname: 'user/info',
        hash: null,
      );

      expect(result, 'https://dave-profile.example.app/user/info');
      expect(result.contains('#'), isFalse);
    });

    test(
        'safeGenerateWebLink should include path and no hash when hash is empty',
        () {
      final result = WebLinkGenerator.safeGenerateWebLink(
        workplaceFqdn: 'eve.example.app',
        slug: 'docs',
        pathname: 'help',
        hash: '',
      );

      expect(result, 'https://eve-docs.example.app/help');
      expect(result.contains('#'), isFalse);
    });

    test('safeGenerateWebLink should return root path when pathname is null',
        () {
      final result = WebLinkGenerator.safeGenerateWebLink(
        workplaceFqdn: 'frank.example.app',
        slug: 'notes',
        pathname: null,
      );

      expect(result, 'https://frank-notes.example.app/');
      expect(result.contains('#'), isFalse);
    });

    test(
        'safeGenerateWebLink should handle no slug and only pathname (slug = null)',
        () {
      final result = WebLinkGenerator.safeGenerateWebLink(
        workplaceFqdn: 'charlie.example.app',
        slug: null,
        pathname: 'home',
      );

      expect(result, 'https://charlie.example.app/home');
      expect(result.contains('#'), isFalse);
    });

    test(
        'safeGenerateWebLink should handle no slug and only pathname (slug = empty string)',
        () {
      final result = WebLinkGenerator.safeGenerateWebLink(
        workplaceFqdn: 'dave.example.app',
        slug: '',
        pathname: 'portal',
      );

      expect(result, 'https://dave.example.app/portal');
      expect(result.contains('#'), isFalse);
    });

    test(
        'safeGenerateWebLink should handle multi-segment pathname with leading slash and no slug',
        () {
      final result = WebLinkGenerator.safeGenerateWebLink(
        workplaceFqdn: 'eve.example.app',
        slug: null,
        pathname: '/x/y/z',
      );

      expect(result, 'https://eve.example.app/x/y/z');
      expect(result.contains('#'), isFalse);
    });

    test(
        'safeGenerateWebLink should handle multi-segment pathname without leading slash and no slug',
        () {
      final result = WebLinkGenerator.safeGenerateWebLink(
        workplaceFqdn: 'frank.example.app',
        slug: null,
        pathname: 'x/y/z',
      );

      expect(result, 'https://frank.example.app/x/y/z');
      expect(result.contains('#'), isFalse);
    });

    group('Edge cases - FQDN validation', () {
      test('should handle FQDN with trailing dot', () {
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'alice.example.com.',
          slug: 'notes',
        );

        expect(result, 'https://alice-notes.example.com/');
      });

      test('should handle FQDN with trailing dot and no slug', () {
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'bob.example.org.',
        );

        expect(result, 'https://bob.example.org/');
      });

      test('should handle FQDN with multiple trailing dots', () {
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'charlie.example.net...',
          slug: 'app',
        );

        expect(result, startsWith('https://'));
        expect(result.contains('-app'), isTrue);
      });

      test('should throw for FQDN exceeding 253 characters', () {
        // Create FQDN exceeding 253 chars
        final longFqdn = '${'a' * 250}.example.com'; // 250 + 12 = 262 chars
        expect(
          () => WebLinkGenerator.generateWebLink(
            workplaceFqdn: longFqdn,
            slug: 'test',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should handle FQDN with uppercase letters', () {
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'Alice.Example.COM',
          slug: 'notes',
        );

        expect(result, startsWith('https://'));
        expect(result.contains('-notes'), isTrue);
      });

      test('should throw for FQDN with only whitespace', () {
        expect(
          () => WebLinkGenerator.generateWebLink(
            workplaceFqdn: '   ',
            slug: 'notes',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('Edge cases - Slug validation', () {
      test('should auto-convert uppercase slug to lowercase', () {
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'alice.example.com',
          slug: 'Notes',
        );

        expect(result, 'https://alice-notes.example.com/');
      });

      test('should throw for slug with hyphens (no longer allowed)', () {
        expect(
          () => WebLinkGenerator.generateWebLink(
            workplaceFqdn: 'bob.example.com',
            slug: 'my-app',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw for slug starting with hyphen', () {
        expect(
          () => WebLinkGenerator.generateWebLink(
            workplaceFqdn: 'alice.example.com',
            slug: '-notes',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw for slug ending with hyphen', () {
        expect(
          () => WebLinkGenerator.generateWebLink(
            workplaceFqdn: 'alice.example.com',
            slug: 'notes-',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw for slug with special characters', () {
        expect(
          () => WebLinkGenerator.generateWebLink(
            workplaceFqdn: 'alice.example.com',
            slug: 'my_app',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw for slug with spaces', () {
        expect(
          () => WebLinkGenerator.generateWebLink(
            workplaceFqdn: 'alice.example.com',
            slug: 'my app',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw for slug exceeding 63 characters', () {
        final longSlug = 'a' * 64;
        expect(
          () => WebLinkGenerator.generateWebLink(
            workplaceFqdn: 'alice.example.com',
            slug: longSlug,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should accept slug with exactly 63 characters', () {
        final maxSlug = 'a' * 63;
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'alice.example.com',
          slug: maxSlug,
        );

        expect(result, startsWith('https://alice-'));
      });
    });

    group('Edge cases - Pathname validation', () {
      test('should throw for pathname exceeding 2048 characters', () {
        final longPath = 'a' * 2049;
        expect(
          () => WebLinkGenerator.generateWebLink(
            workplaceFqdn: 'alice.example.com',
            slug: 'notes',
            pathname: longPath,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should accept pathname with exactly 2048 characters', () {
        final maxPath = 'a' * 2048;
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'alice.example.com',
          slug: 'notes',
          pathname: maxPath,
        );

        expect(result, startsWith('https://alice-notes.example.com/'));
      });

      test('should handle pathname with special characters', () {
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'alice.example.com',
          slug: 'drive',
          pathname: 'folder/file with spaces.txt',
        );

        expect(result, contains('file%20with%20spaces.txt'));
      });

      test('should handle pathname that is just a slash', () {
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'alice.example.com',
          slug: 'notes',
          pathname: '/',
        );

        expect(result, 'https://alice-notes.example.com/');
      });
    });

    group('Edge cases - Search params', () {
      test('should filter out empty key in search params', () {
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'alice.example.com',
          slug: 'notes',
          searchParams: [
            ['', 'value'],
            ['key', 'value'],
          ],
        );

        // Empty keys are now filtered out by _buildQueryParams
        expect(result, 'https://alice-notes.example.com/?key=value');
      });

      test('should handle empty value in search params', () {
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'alice.example.com',
          slug: 'notes',
          searchParams: [
            ['key', ''],
          ],
        );

        // Empty values are included in query string (Uri omits the '=' for empty values)
        expect(result, contains('?key'));
      });

      test('should handle duplicate keys in search params (last wins)', () {
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'alice.example.com',
          slug: 'notes',
          searchParams: [
            ['key', 'value1'],
            ['key', 'value2'],
          ],
        );

        expect(result, contains('key=value2'));
        expect(result, isNot(contains('value1')));
      });

      test('should handle search params with special characters', () {
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'alice.example.com',
          slug: 'notes',
          searchParams: [
            ['key', 'value with spaces & special=chars'],
          ],
        );

        // Uri encodes spaces as + and special chars appropriately
        expect(result, contains('value+with+spaces'));
        expect(result, contains('%26')); // & is encoded as %26
      });

      test('should ignore empty list in search params', () {
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'alice.example.com',
          slug: 'notes',
          searchParams: [],
        );

        expect(result, 'https://alice-notes.example.com/');
        expect(result.contains('?'), isFalse);
      });
    });

    group('Edge cases - Hash validation', () {
      test('should handle hash with only whitespace', () {
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'alice.example.com',
          slug: 'notes',
          hash: '   ',
        );

        expect(result, 'https://alice-notes.example.com/#/%20%20%20');
      });

      test('should handle hash with special characters', () {
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'alice.example.com',
          slug: 'notes',
          hash: 'section with spaces',
        );

        expect(result, contains('#/section%20with%20spaces'));
      });
    });

    group('Security - DoS attack prevention', () {
      test('should prevent DoS via extremely long FQDN (memory exhaustion)', () {
        // Attempt to create FQDN that would consume excessive memory
        final maliciousFqdn = '${'x' * 300}.example.com';
        expect(
          () => WebLinkGenerator.generateWebLink(
            workplaceFqdn: maliciousFqdn,
            slug: 'app',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should prevent DoS via extremely long pathname (buffer overflow)', () {
        // Attempt pathname longer than web server limits
        final maliciousPath = 'a' * 5000;
        expect(
          () => WebLinkGenerator.generateWebLink(
            workplaceFqdn: 'alice.example.com',
            slug: 'notes',
            pathname: maliciousPath,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should prevent DoS via extremely long slug (subdomain attack)', () {
        // Attempt slug longer than DNS label limit
        final maliciousSlug = 'b' * 100;
        expect(
          () => WebLinkGenerator.generateWebLink(
            workplaceFqdn: 'alice.example.com',
            slug: maliciousSlug,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should handle edge case: FQDN at exactly 253 chars (boundary test)', () {
        // Test at exact RFC 1035 limit
        final exactLimitFqdn = '${'a' * 240}.example.com'; // 240 + 12 = 252 chars
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: exactLimitFqdn,
          slug: 'app',
        );

        expect(result, startsWith('https://'));
      });

      test('should handle edge case: pathname at exactly 2048 chars (boundary test)', () {
        // Test at exact common web server limit
        final exactLimitPath = 'x' * 2048;
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'alice.example.com',
          slug: 'notes',
          pathname: exactLimitPath,
        );

        expect(result, startsWith('https://alice-notes.example.com/'));
      });

      test('should handle edge case: slug at exactly 63 chars (DNS label limit)', () {
        // Test at exact RFC 1035 DNS label limit
        final exactLimitSlug = 'c' * 63;
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'alice.example.com',
          slug: exactLimitSlug,
        );

        expect(result, startsWith('https://alice-'));
        expect(result.contains(exactLimitSlug), isTrue);
      });

      test('should prevent DoS via malicious searchParams (resource exhaustion)', () {
        // Attempt to create thousands of query parameters
        final maliciousParams = List.generate(
          10000,
          (i) => ['key$i', 'value$i'],
        );

        // Should not throw, but implementation handles it gracefully
        final result = WebLinkGenerator.generateWebLink(
          workplaceFqdn: 'alice.example.com',
          slug: 'notes',
          searchParams: maliciousParams,
        );

        expect(result, startsWith('https://'));
      });
    });

    group('Edge cases - safeGenerateWebLink', () {
      test('should return empty string for FQDN exceeding max length', () {
        // Create FQDN exceeding 253 chars
        final longFqdn = '${'a' * 250}.example.com'; // 250 + 12 = 262 chars
        final result = WebLinkGenerator.safeGenerateWebLink(
          workplaceFqdn: longFqdn,
          slug: 'test',
        );

        expect(result, '');
      });

      test('should return empty string for invalid slug', () {
        final result = WebLinkGenerator.safeGenerateWebLink(
          workplaceFqdn: 'alice.example.com',
          slug: '-invalid',
        );

        expect(result, '');
      });

      test('should return empty string for pathname exceeding max length', () {
        final longPath = 'a' * 2049;
        final result = WebLinkGenerator.safeGenerateWebLink(
          workplaceFqdn: 'alice.example.com',
          slug: 'notes',
          pathname: longPath,
        );

        expect(result, '');
      });
    });
  });
}
