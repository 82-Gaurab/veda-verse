import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/app/theme/theme_extensions.dart';
import 'package:vedaverse/common/my_snack_bar.dart';
import 'package:vedaverse/features/order/presentation/states/order_state.dart';
import 'package:vedaverse/features/order/presentation/view_model/order_view_model.dart';
import 'package:vedaverse/features/order/presentation/widgets/order_card.dart';

class MyOrders extends ConsumerStatefulWidget {
  const MyOrders({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyOrdersState();
}

class _MyOrdersState extends ConsumerState<MyOrders> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(orderViewModelProvider.notifier).getMyOrders();
    });
  }

  void _navigateBack() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderViewModelProvider);
    final orders = orderState.orders;

    ref.listen(orderViewModelProvider, (previous, next) {
      if (next.status == OrderStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? "Failed To fetch order data",
        );
      } else if (next.status == OrderStatus.paid) {
        SnackbarUtils.showSuccess(context, "Payment Successful");

        ref.read(orderViewModelProvider.notifier).getMyOrders();
      }
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: context.softShadow,
            ),
            child: Icon(Icons.arrow_back, color: context.textPrimary, size: 20),
          ),
          onPressed: _navigateBack,
        ),
      ),
      body: SafeArea(
        child: orderState.status == OrderStatus.loading
            ? const Center(child: CircularProgressIndicator())
            : orders.isEmpty
            ? const Text("No Orders found")
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];

                  final books = order.books.map((b) {
                    return {"title": b.title, "quantity": b.quantity};
                  }).toList();

                  return OrderCard(
                    onPay: () {
                      ref
                          .read(orderViewModelProvider.notifier)
                          .payOrder(order.id);
                    },
                    orderId: order.id,
                    status: order.status,
                    totalPrice: (order.totalPrice as num).toDouble(),
                    createdAt: DateTime.parse("${order.createdAt}"),
                    books: books,
                  );
                },
              ),
      ),
    );
  }
}
