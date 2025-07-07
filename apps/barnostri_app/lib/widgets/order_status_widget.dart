import 'package:flutter/material.dart';
import '../core/modelos/app_models.dart';
import '../core/servicos/order_service.dart';
import '../core/tema/theme.dart';

class OrderStatusWidget extends StatelessWidget {
  final Pedido pedido;
  final bool isAdminView;

  const OrderStatusWidget({
    super.key,
    required this.pedido,
    this.isAdminView = false,
  });

  @override
  Widget build(BuildContext context) {
    final currentStatus = OrderStatus.fromString(pedido.status);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header
          _buildOrderHeader(context),
          
          const SizedBox(height: 24),
          
          // Status timeline
          _buildStatusTimeline(context, currentStatus),
          
          const SizedBox(height: 32),
          
          // Order details
          _buildOrderDetails(context),
          
          if (isAdminView) ...[
            const SizedBox(height: 24),
            _buildAdminActions(context, currentStatus),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pedido #${pedido.id.substring(0, 8)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  pedido.status,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (pedido.mesa != null)
            Row(
              children: [
                Icon(
                  Icons.table_restaurant,
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Mesa ${pedido.mesa!.numero}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                OrderService().formatDateTime(pedido.createdAt),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.payment,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                pedido.formaPagamento,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(BuildContext context, OrderStatus currentStatus) {
    final statuses = [
      OrderStatus.recebido,
      OrderStatus.emPreparo,
      OrderStatus.pronto,
      OrderStatus.entregue,
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status do Pedido',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          ...statuses.asMap().entries.map((entry) {
            final index = entry.key;
            final status = entry.value;
            final isActive = statuses.indexOf(currentStatus) >= index;
            final isCurrent = status == currentStatus;
            
            return _buildStatusStep(
              context,
              status,
              isActive,
              isCurrent,
              index < statuses.length - 1,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildStatusStep(
    BuildContext context,
    OrderStatus status,
    bool isActive,
    bool isCurrent,
    bool showConnector,
  ) {
    return Column(
      children: [
        Row(
          children: [
            // Status icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getStatusIcon(status),
                color: isActive
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                size: 20,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Status text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.displayName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                      color: isActive
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    _getStatusDescription(status),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isActive
                          ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
            
            // Current indicator
            if (isCurrent)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 8,
                      height: 8,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Atual',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        
        if (showConnector) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 20),
              Container(
                width: 2,
                height: 24,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ] else
          const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildOrderDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Itens do Pedido',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          ...pedido.itens.map((item) => _buildOrderItem(context, item)).toList(),
          
          const SizedBox(height: 16),
          
          Divider(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                OrderService().formatPrice(pedido.total),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, ItemPedido item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${item.quantidade}x',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemCardapio?.nome ?? 'Item',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (item.observacao != null && item.observacao!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Obs: ${item.observacao}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          Text(
            OrderService().formatPrice(item.subtotal),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminActions(BuildContext context, OrderStatus currentStatus) {
    final nextStatus = _getNextStatus(currentStatus);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ações do Administrador',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              if (nextStatus != null)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _updateOrderStatus(context, nextStatus),
                    icon: const Icon(Icons.arrow_forward),
                    label: Text('Marcar como ${nextStatus.displayName}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              
              if (nextStatus != null && currentStatus != OrderStatus.cancelado)
                const SizedBox(width: 12),
              
              if (currentStatus != OrderStatus.cancelado && currentStatus != OrderStatus.entregue)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _updateOrderStatus(context, OrderStatus.cancelado),
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancelar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      side: BorderSide(color: Theme.of(context).colorScheme.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.recebido:
        return Icons.receipt;
      case OrderStatus.emPreparo:
        return Icons.restaurant;
      case OrderStatus.pronto:
        return Icons.check_circle;
      case OrderStatus.entregue:
        return Icons.delivery_dining;
      case OrderStatus.cancelado:
        return Icons.cancel;
    }
  }

  String _getStatusDescription(OrderStatus status) {
    switch (status) {
      case OrderStatus.recebido:
        return 'Pedido recebido pela cozinha';
      case OrderStatus.emPreparo:
        return 'Preparando seus pratos';
      case OrderStatus.pronto:
        return 'Pedido pronto para retirada';
      case OrderStatus.entregue:
        return 'Pedido entregue';
      case OrderStatus.cancelado:
        return 'Pedido cancelado';
    }
  }

  OrderStatus? _getNextStatus(OrderStatus currentStatus) {
    switch (currentStatus) {
      case OrderStatus.recebido:
        return OrderStatus.emPreparo;
      case OrderStatus.emPreparo:
        return OrderStatus.pronto;
      case OrderStatus.pronto:
        return OrderStatus.entregue;
      case OrderStatus.entregue:
      case OrderStatus.cancelado:
        return null;
    }
  }

  Future<void> _updateOrderStatus(BuildContext context, OrderStatus newStatus) async {
    final orderService = OrderService();
    final success = await orderService.updateOrderStatus(pedido.id, newStatus);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status atualizado para ${newStatus.displayName}'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar status: ${orderService.error}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}