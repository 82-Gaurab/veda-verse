import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/common/my_snack_bar.dart';
import 'package:vedaverse/features/cart/presentation/state/cart_state.dart';
import 'package:vedaverse/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:vedaverse/features/cart/presentation/widgets/cart_card.dart';
import 'package:vedaverse/features/order/presentation/states/order_state.dart';
import 'package:vedaverse/features/order/presentation/view_model/order_view_model.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  Future<void> _handleCheckout() async {
    ref.read(orderViewModelProvider.notifier).createOrder();
  }

  Future<void> _handleIncreaseQuantity(String bookId, int quantity) async {
    ref
        .read(cartViewModelProvider.notifier)
        .updateCart(bookId: bookId, quantity: quantity + 1);
  }

  Future<void> _handleDecreaseQuantity(String bookId, int quantity) async {
    ref
        .read(cartViewModelProvider.notifier)
        .updateCart(bookId: bookId, quantity: quantity - 1);
  }

  Future<void> _handleDeleteItem(String bookId) async {
    ref.read(cartViewModelProvider.notifier).deleteCart(bookId);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(cartViewModelProvider.notifier).getMyCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartViewModelProvider);
    final orderState = ref.watch(orderViewModelProvider);
    final cartBooks = cartState.entities ?? [];

    ref.listen(cartViewModelProvider, (previous, next) {
      if (next.status == CartStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? "Failed to fetch cart data",
        );
      }
    });
    ref.listen(orderViewModelProvider, (previous, next) {
      if (next.status == OrderStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? "Failed to create order",
        );
      } else if (next.status == OrderStatus.loaded) {
        SnackbarUtils.showSuccess(context, "Order Created successfully");
        ref.read(cartViewModelProvider.notifier).getMyCart();
      }
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(
          context,
        ).scaffoldBackgroundColor, // adapts to theme
        automaticallyImplyLeading: true, // shows back button automatically
        title: Text(
          'My Cart',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        iconTheme: IconThemeData(
          color: Theme.of(context).iconTheme.color, // back button color adapts
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),

                SingleChildScrollView(
                  child: cartState.status == CartStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : cartBooks.isEmpty
                      ? Center(child: const Text("No Item in Cart"))
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: cartBooks.map((book) {
                                    return CartCard(
                                      book: book,
                                      onDecrease: () => _handleDecreaseQuantity(
                                        book.bookId,
                                        book.quantity,
                                      ),
                                      onIncrease: () => _handleIncreaseQuantity(
                                        book.bookId,
                                        book.quantity,
                                      ),
                                      onRemove: () =>
                                          _handleDeleteItem(book.bookId),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: 56,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed:
                                      orderState.status == OrderStatus.loading
                                      ? null
                                      : _handleCheckout,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child:
                                      orderState.status == OrderStatus.loading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const Text(
                                          'Checkout',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
