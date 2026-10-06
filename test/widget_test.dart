import 'package:flutter_test/flutter_test.dart';
import 'package:trading_dashboard/main.dart';

void main() {
  testWidgets('dashboard shows portfolio, markets, and transactions', (tester) async {
    await tester.pumpWidget(const TradingDashboardApp());
    expect(find.text('Trading Dashboard'), findsOneWidget);
    expect(find.text('\$24,850.50'), findsWidgets);
    expect(find.text('BTC/USD'), findsOneWidget);
    expect(find.text('Recent transactions'), findsOneWidget);
  });

  testWidgets('timeframe buttons are interactive', (tester) async {
    await tester.pumpWidget(const TradingDashboardApp());
    await tester.tap(find.text('1W'));
    await tester.pump();
    expect(find.text('Tue'), findsOneWidget);
  });
}
