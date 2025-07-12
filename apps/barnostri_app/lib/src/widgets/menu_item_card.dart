import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_models/shared_models.dart';
import 'package:barnostri_app/l10n/generated/app_localizations.dart';

class MenuItemCard extends StatefulWidget {
  final MenuItem item;
  final VoidCallback onTap;

  const MenuItemCard({super.key, required this.item, required this.onTap});

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.05 * 255).round()),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withAlpha((0.1 * 255).round()),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image section
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: widget.item.imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: widget.item.imageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Theme.of(context).colorScheme.surface,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  _buildPlaceholderImage(),
                            )
                          : _buildPlaceholderImage(),
                    ),
                  ),

                  // Content section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and price row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.item.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                formatCurrency(widget.item.price),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),

                        // Description
                        if (widget.item.description != null &&
                            widget.item.description!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            widget.item.description!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withAlpha((0.7 * 255).round()),
                                  height: 1.4,
                                ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        const SizedBox(height: 12),

                        // Category and availability
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Category tag
                            if (widget.item.category != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withAlpha((0.1 * 255).round()),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  widget.item.category!.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),

                            // Availability indicator
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: widget.item.available
                                    ? Colors.green.withAlpha(
                                        (0.1 * 255).round(),
                                      )
                                    : Colors.red.withAlpha((0.1 * 255).round()),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    widget.item.available
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    size: 12,
                                    color: widget.item.available
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.item.available
                                        ? AppLocalizations.of(context).available
                                        : AppLocalizations.of(
                                            context,
                                          ).unavailable,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: widget.item.available
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Icon(
              Icons.fastfood,
              size: 64,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withAlpha((0.3 * 255).round()),
            ),
          ),
          if (!widget.item.available)
            Container(
              color: Colors.black.withAlpha((0.5 * 255).round()),
              child: const Center(
                child: Icon(Icons.no_food, size: 48, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
