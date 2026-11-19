import 'package:clinic_app/app/core/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String hint;
  final IconData? prefixIcon;
  final String? prefixText;
  final IconData? suffixIcon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onTogglePassword;
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool enabled;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final int maxLines;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  const CustomTextField({
    super.key,
    this.label,
    required this.hint,
    this.prefixIcon,
    this.prefixText,
    this.suffixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.onTogglePassword,
    this.controller,
    this.errorText,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly = false,
    this.enabled = true,
    this.focusNode,
    this.onTap,
    this.maxLines = 1,
    this.validator,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      enabled: enabled,
      focusNode: focusNode,
      onTap: onTap,
      maxLines: isPassword ? 1 : maxLines,
      validator: validator,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        hintText: hint,
        errorText: errorText,
        prefixIcon: _buildPrefix(),
        prefixIconConstraints: prefixText == null
            ? null
            : const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.veryLightGray,
                ),
                onPressed: onTogglePassword,
              )
            : suffixIcon != null
            ? Icon(suffixIcon, color: AppColors.veryLightGray, size: 22)
            : null,
      ),
    );

    if (label == null) return field;
    return _withLabel(field);
  }

  Widget? _buildPrefix() {
    if (prefixIcon == null && prefixText == null) return null;
    if (prefixText == null) {
      return Icon(prefixIcon, color: AppColors.veryLightGray, size: 22);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefixIcon != null) ...[
            Icon(prefixIcon, color: AppColors.veryLightGray, size: 22),
            const SizedBox(width: 8),
          ],
          Text(
            prefixText!,
            style: const TextStyle(
              color: AppColors.veryLightGray,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _withLabel(Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }
}
