import 'package:flutter/material.dart';

import '../data/avia_repository.dart';
import '../theme/vk_colors.dart';
import 'vk_icon.dart';

enum SnackbarKind { success, error, offline }

/// VKUI `Snackbar` with a status icon.
void showVkSnackbar(
  BuildContext context,
  String text, {
  SnackbarKind kind = SnackbarKind.success,
}) {
  final vk = context.vk;
  final icon = switch (kind) {
    SnackbarKind.success => VkIcon(
      'icon_done',
      size: 24,
      color: vk.textPositive,
    ),
    SnackbarKind.error => VkIcon(
      'icon_cancel',
      size: 24,
      color: vk.textNegative,
    ),
    SnackbarKind.offline => VkIcon(
      'icon_globe_cross_outline',
      size: 24,
      color: vk.textNegative,
    ),
  };
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
        content: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
}

void showErrorSnackbar(BuildContext context, Object error) {
  final repositoryError = error is RepositoryException
      ? error.error
      : RepositoryError.unknown;
  showVkSnackbar(
    context,
    repositoryError.message,
    kind: repositoryError == RepositoryError.network
        ? SnackbarKind.offline
        : SnackbarKind.error,
  );
}
