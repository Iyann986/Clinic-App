import 'package:clinic_app/app/assets/resource_path.dart';
import 'package:clinic_app/app/core/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Tombol "Masuk/Daftar dengan Google", dipakai di Login & Register.
/// Terpisah dari [CustomButton] karena butuh render ikon SVG multi-warna
/// (bukan [IconData] biasa).
class GoogleSigninButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const GoogleSigninButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.text = 'Masuk dengan Google',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          side: BorderSide(color: AppColors.gray),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ResourcePath.googleIconSvg,
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
