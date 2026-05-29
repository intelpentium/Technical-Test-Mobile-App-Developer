import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_recitation_player/features/quran_player/presentation/widgets/search_input.dart';

void main() {
  testWidgets('shows search input and reports text changes', (tester) async {
    var query = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchInput(query: query, onChanged: (value) => query = value),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('search_input')), findsOneWidget);
    expect(find.text('Search surah or reciter'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'baqara');
    await tester.pump();

    expect(query, 'baqara');
  });
}
