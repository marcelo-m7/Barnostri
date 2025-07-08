import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/language_service.dart';
import '../l10n/generated/app_localizations.dart';
import '../core/theme/theme.dart';

class LanguageSelector extends ConsumerWidget {
  final bool showAsBottomSheet;
  final VoidCallback? onLanguageChanged;
  
  const LanguageSelector({
    super.key,
    this.showAsBottomSheet = false,
    this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageService = ref.watch(languageServiceProvider.notifier);
    final currentLocale = ref.watch(languageServiceProvider);
    final l10n = AppLocalizations.of(context)!;
    
    if (showAsBottomSheet) {
      return _buildBottomSheet(context, languageService, l10n);
    }
    
    return _buildDropdown(context, languageService, l10n);
  }
  
  Widget _buildDropdown(BuildContext context, LanguageService languageService, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Locale>(
          value: currentLocale,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          items: LanguageService.supportedLocales.map((locale) {
            return DropdownMenuItem<Locale>(
              value: locale,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    languageService.getCountryFlag(locale),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    languageService.getLanguageDisplayName(locale),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (Locale? newLocale) {
            if (newLocale != null) {
              languageService.changeLanguage(newLocale);
              onLanguageChanged?.call();
            }
          },
        ),
      ),
    );
  }
  
  Widget _buildBottomSheet(BuildContext context, LanguageService languageService, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.language,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...LanguageService.supportedLocales.map((locale) {
            final isSelected = locale == ref.watch(languageServiceProvider);
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: isSelected 
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    languageService.changeLanguage(locale);
                    Navigator.pop(context);
                    onLanguageChanged?.call();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              languageService.getCountryFlag(locale),
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                languageService.getLanguageDisplayName(locale),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getLanguageSubtitle(locale, l10n),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  
  String _getLanguageSubtitle(Locale locale, AppLocalizations l10n) {
    switch (locale.languageCode) {
      case 'pt':
        return l10n.portuguese;
      case 'en':
        return l10n.english;
      case 'fr':
        return l10n.french;
      default:
        return locale.languageCode.toUpperCase();
    }
  }
  
  static void showLanguageSelector(BuildContext context, {VoidCallback? onLanguageChanged}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => LanguageSelector(
        showAsBottomSheet: true,
        onLanguageChanged: onLanguageChanged,
      ),
    );
  }
}

class LanguageSelectorButton extends ConsumerWidget {
  final VoidCallback? onLanguageChanged;
  
  const LanguageSelectorButton({
    super.key,
    this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageService = ref.watch(languageServiceProvider.notifier);
    final locale = ref.watch(languageServiceProvider);
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            LanguageSelector.showLanguageSelector(
              context,
              onLanguageChanged: onLanguageChanged,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  languageService.getCountryFlag(currentLocale),
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  languageService.getLanguageDisplayName(currentLocale),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}