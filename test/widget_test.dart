import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

void main() {
  group("FormButton tests", () {
    testWidgets("Enabled state test", (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: FormButton(title: "Next", disabled: false),
        ),
      );

      expect(find.text("Next"), findsOneWidget);
      expect(
        tester
            .firstWidget<AnimatedDefaultTextStyle>(
                find.byType(AnimatedDefaultTextStyle))
            .style
            .color,
        Colors.white,
      );
      expect(
        (tester
                .firstWidget<AnimatedContainer>(find.byType(AnimatedContainer))
                .decoration as BoxDecoration)
            .color,
        const Color(0xff6750a4),
      );
    });

    testWidgets("Disabled state test", (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: FormButton(title: "Next", disabled: true),
        ),
      );

      expect(find.text("Next"), findsOneWidget);
      expect(
        tester
            .firstWidget<AnimatedDefaultTextStyle>(
                find.byType(AnimatedDefaultTextStyle))
            .style
            .color,
        Colors.grey.shade400,
      );
    });

    testWidgets("Disabled state on dark mode test", (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(
            platformBrightness: Brightness.dark,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: FormButton(title: "Next", disabled: true),
          ),
        ),
      );

      expect(find.text("Next"), findsOneWidget);
      expect(
        (tester
                .firstWidget<AnimatedContainer>(find.byType(AnimatedContainer))
                .decoration as BoxDecoration)
            .color,
        Colors.grey.shade800,
      );
    });

    testWidgets("Disabled state on light mode test", (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(
            platformBrightness: Brightness.light,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: FormButton(title: "Next", disabled: true),
          ),
        ),
      );

      expect(find.text("Next"), findsOneWidget);
      expect(
        (tester
                .firstWidget<AnimatedContainer>(find.byType(AnimatedContainer))
                .decoration as BoxDecoration)
            .color,
        Colors.grey.shade300,
      );
    });
  });
}
