import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:curren_see/app.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: CurrenSeeApp()),
    );
    // Splash screen should be visible
    expect(find.textContaining('Curren'), findsWidgets);
  });
}
