// test/widget_test.dart
import 'package:elimapass/screens/login.dart';
import 'package:elimapass/services/login_service.dart';
import 'package:elimapass/widgets/loading_foreground.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:elimapass/screens/app_home.dart';
import 'package:elimapass/screens/payments/payment_select_page.dart';
import 'package:elimapass/screens/payments/billetera_digital_page.dart';
import 'package:flutter/rendering.dart';

class MockLoginService extends Mock implements LoginService {}

void main() {
  late MockLoginService mockLoginService;

  setUp(() {
    mockLoginService = MockLoginService();
  });

  // Success case: should navigate to AppHome
  testWidgets('shows loading, calls login, and navigates on success', (WidgetTester tester) async {
    when(() => mockLoginService.login('12345678', 'password123'))
        .thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(loginService: mockLoginService),
      ),
    );

    await tester.enterText(find.byKey(const Key('dniField')), '12345678');
    await tester.enterText(find.byKey(const Key('passwordField')), 'password123');
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump(); // Start loading

    verify(() => mockLoginService.login('12345678', 'password123')).called(1);

    // Wait for navigation
    await tester.pump();
    expect(find.byType(AppHome), findsOneWidget);

    // Tap the "Recargar" button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Recargar'));
    await tester.pumpAndSettle();

    // Should navigate to PaymentSelectPage
    expect(find.byType(PaymentSelectPage), findsOneWidget);
    // Tap the "Recargar" button
  });

// Error case: should show SnackBar on login failure
  testWidgets('shows SnackBar on login failure', (WidgetTester tester) async {
    when(() => mockLoginService.login('12345678', 'wrongpass'))
        .thenThrow(Exception('Credenciales inválidas'));

    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(loginService: mockLoginService),
      ),
    );

    await tester.enterText(find.byKey(const Key('dniField')), '12345678');
    await tester.enterText(find.byKey(const Key('passwordField')), 'wrongpass');
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump(); // Start loading

    verify(() => mockLoginService.login('12345678', 'wrongpass')).called(1);

    // Wait for SnackBar to appear
    await tester.pump(); // Show SnackBar
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('Error de autenticación'), findsOneWidget);
  });
}