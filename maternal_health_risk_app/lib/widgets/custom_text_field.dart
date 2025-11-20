import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maternal_health_risk_app/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final double minValue;
  final double maxValue;
  final String unit;
  final int decimalPlaces;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.minValue,
    required this.maxValue,
    required this.unit,
    this.decimalPlaces = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(
            decimal: decimalPlaces > 0,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              decimalPlaces > 0
                  ? RegExp(r'^\d*\.?\d{0,' + decimalPlaces.toString() + r'}')
                  : RegExp(r'^\d*\.?\d*'),
            ),
          ],
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            suffixText: unit,
            suffixStyle: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            prefixIcon: Icon(icon, color: AppColors.secondary),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            final numValue = double.tryParse(value);
            if (numValue == null) {
              return 'Please enter a valid number';
            }
            if (numValue < minValue || numValue > maxValue) {
              return 'Value must be between $minValue and $maxValue $unit';
            }
            return null;
          },
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            'Range: $minValue - $maxValue $unit',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }
}
