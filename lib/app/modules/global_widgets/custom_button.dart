import 'package:flutter/material.dart';

/// Tombol utama yang dipakai di seluruh aplikasi (CTA, submit form, dll)
/// supaya style tombol konsisten dan tidak perlu diulang-ulang di tiap View.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double height;
  final double width;
  final Color textColor;
  final double borderRadius;
  final Color? backgroundColor;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 50,
    this.width = double.infinity,
    this.textColor = Colors.white,
    this.borderRadius = 25.0,
    this.backgroundColor,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedTextColor = isOutlined
        ? (backgroundColor ?? Theme.of(context).primaryColor)
        : textColor;

    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: resolvedTextColor,
                side: BorderSide(
                  color: backgroundColor ?? Theme.of(context).primaryColor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: _buildChild(resolvedTextColor),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                foregroundColor: textColor,
                backgroundColor:
                    backgroundColor ?? Theme.of(context).primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: _buildChild(textColor),
            ),
    );
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(color: color, strokeWidth: 2.5),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.5,
              color: color,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        letterSpacing: 0.5,
        color: color,
      ),
    );
  }
}
