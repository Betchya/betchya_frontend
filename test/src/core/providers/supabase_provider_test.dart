import 'package:betchya_frontend/src/core/providers/supabase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUpAll(() async {
    // Register the in-memory fake before initializing Supabase
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://test.supabase.co',
      anonKey: 'test-anon-key',
    );
  });

  test('supabaseProvider returns a SupabaseClient', () {
    final container = ProviderContainer();
    final client = container.read(supabaseClientProvider);
    expect(client, isA<SupabaseClient>());
    // Optionally: check URL/key if you want to ensure correct instance
    // expect(client.restUrl, equals('https://your.supabase.url'));
  });
}
