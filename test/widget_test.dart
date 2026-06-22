import 'package:flutter_test/flutter_test.dart';
import 'package:groovy_inventory/main.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GroovyInventoryApp());
    await tester.pumpAndSettle();
    expect(find.text('Dashboard'), findsWidgets);
  });
}
