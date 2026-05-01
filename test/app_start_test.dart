import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:urdu_learning_app/main.dart';
import 'package:urdu_learning_app/providers/app_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app starts and renders initial screen', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppProvider(),
        child: const UrduLearningApp(),
      ),
    );

    // Startup splash should render immediately.
    expect(find.text('اردو'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
