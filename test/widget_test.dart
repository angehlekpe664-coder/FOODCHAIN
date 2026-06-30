import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:foodchain/main.dart';
import 'package:foodchain/state/app_state.dart';

void main() {
  testWidgets('Splash screen loads test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: const FoodChainApp(),
      ),
    );

    // Verify that the splash screen loads with securing connection text.
    expect(find.text('SECURING CONNECTION'), findsOneWidget);

    // Allow splash timer to complete and navigate to clean up timers
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
