import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class FormButton extends StatelessWidget {
  const FormButton({
    super.key,
    required this.disabled,
    this.onPressed,
  });

  final bool disabled;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
              color: disabled
                  ? Colors.grey.shade300
                  : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(Sizes.size5)),
          padding: const EdgeInsets.symmetric(vertical: Sizes.size16),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyle(
              color: disabled ? Colors.grey.shade400 : Colors.white,
              fontWeight: FontWeight.w600,
            ),
            child: const Text(
              'Next',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
