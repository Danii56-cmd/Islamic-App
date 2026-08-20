import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamic_app/core/theme_extensions.dart';

class CustomPopScope extends StatelessWidget {
  final Widget child;
  final bool Function() onBackPressed;
  final bool isRoot;

  const CustomPopScope({
    super.key,
    required this.child,
    required this.onBackPressed,
    this.isRoot = false,
  });

  Future<void> _showExitDialog(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

        // TITLE
        title: Text(
          'Exit App',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: context.textPrimary,
          ),
        ),

        // CONTENT
        content: Text(
          'Are you sure you want to close the app?',
          style: TextStyle(color: context.textSecondary),
        ),

        // ACTIONS
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
            child: Text(
              'No',
              style: TextStyle(
                color: context.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primary,
              foregroundColor: context.textOnPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
            child: const Text(
              'Yes, Exit',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
    if (shouldExit == true) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final consumed = onBackPressed();
        if (consumed) return;
        // Root screen → show exit dialog
        if (isRoot) {
          await _showExitDialog(context);
        }
        // Other screens → go back normally
        else {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      child: child,
    );
  }
}
