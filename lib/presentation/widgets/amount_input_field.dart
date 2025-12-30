import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInputField extends StatelessWidget {
  final double amount;
  final ValueChanged<double> onChanged;
  final String? currencySymbol;

  const AmountInputField({
    super.key,
    required this.amount,
    required this.onChanged,
    this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Amount',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        TextFormField(
          initialValue: amount == 1.0 ? '' : amount.toString(),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            hintText: 'Enter amount',
            prefixIcon: currencySymbol != null
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      currencySymbol!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : const Icon(Icons.attach_money),
            suffixIcon: amount > 0
                ? IconButton(
                    onPressed: () => onChanged(0),
                    icon: Icon(
                      Icons.clear,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
          ),
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
          onChanged: (value) {
            final doubleValue = double.tryParse(value);
            if (doubleValue != null && doubleValue >= 0) {
              onChanged(doubleValue);
            } else if (value.isEmpty) {
              onChanged(0);
            }
          },
        ),
      ],
    );
  }
}
