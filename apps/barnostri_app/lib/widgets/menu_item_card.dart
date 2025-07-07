import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_models/shared_models.dart';
import '../core/theme/theme.dart';
import '../core/services/order_service.dart';


class MenuItemCard extends StatefulWidget {
  final ItemCardapio item;
  final VoidCallback onTap;

  const MenuItemCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
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
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
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
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      child: widget.item.imagemUrl != null
                          ? CachedNetworkImage(
                              imageUrl: widget.item.imagemUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Theme.of(context).colorScheme.surface,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).colorScheme.primary,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => _buildPlaceholderImage(),
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
                                widget.item.nome,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
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
                                OrderService().formatPrice(widget.item.preco),
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        // Description
                        if (widget.item.descricao != null && widget.item.descricao!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            widget.item.descricao!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
                            if (widget.item.categoria != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  widget.item.categoria!.nome,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,
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
                                color: widget.item.disponivel
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    widget.item.disponivel
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    size: 12,
                                    color: widget.item.disponivel
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.item.disponivel ? 'Disponível' : 'Indisponível',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: widget.item.disponivel
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
    // Get food-related image based on item name/category
    String keyword = widget.item.nome.toLowerCase();
    String category = 'food';
    
    if (keyword.contains('bebida') || keyword.contains('cerveja') || 
        keyword.contains('caipirinha') || keyword.contains('suco') ||
        keyword.contains('refrigerante') || keyword.contains('água')) {
      category = 'drinks';
      keyword = 'brazilian drinks';
    } else if (keyword.contains('sobremesa') || keyword.contains('pudim') ||
               keyword.contains('brigadeiro') || keyword.contains('sorvete')) {
      category = 'desserts';
      keyword = 'brazilian desserts';
    } else if (keyword.contains('camarão') || keyword.contains('peixe') ||
               keyword.contains('moqueca') || keyword.contains('siri')) {
      keyword = 'brazilian seafood';
    } else if (keyword.contains('entrada') || keyword.contains('petisco') ||
               keyword.contains('pastel') || keyword.contains('bolinho')) {
      keyword = 'brazilian appetizers';
    } else {
      keyword = 'brazilian food';
    }

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Stack(
        children: [
          Image.network(
            "https://images.unsplash.com/photo-1636892909247-8357a029ce91?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NTE3OTk3OTZ8&ixlib=rb-4.1.0&q=80&w=1080",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.restaurant_menu,
                size: 48,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
            ),
          ),
          if (!widget.item.disponivel)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Icon(
                  Icons.no_food,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}