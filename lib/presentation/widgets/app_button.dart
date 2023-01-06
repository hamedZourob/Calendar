import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    required this.listenable,
    required this.enable,
    required this.onPress,
    required this.loading,
  }) : super(key: key);

  final Listenable listenable;
  final bool Function() enable;
  final VoidCallback onPress;
  final bool Function() loading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: AnimatedBuilder(
        animation: listenable,
        builder: (context, _) {
          return RawMaterialButton(
            onPressed: enable() ? () => onPress() : null,
            fillColor:
                enable() ? Theme.of(context).primaryColor : Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(minHeight: 50),
            child: loading()
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 8,
                    ),
                  )
                : Text(
                    "Save",
                    style: theme.textTheme.button!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          );
        },
      ),
    );
  }
}
