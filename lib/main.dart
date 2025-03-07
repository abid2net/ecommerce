import 'package:ecommerce/common/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/auth_repository.dart';
import 'blocs/auth/auth_bloc.dart';
import 'controllers/app_controller.dart';
import 'theme/app_theme.dart';
import 'blocs/product/product_bloc.dart';
import 'routes/routes.dart';
import 'repositories/product_repository.dart';
import 'blocs/wishlist/wishlist_bloc.dart';
import 'repositories/wishlist_repository.dart';
import 'blocs/cart/cart_bloc.dart';
import 'repositories/cart_repository.dart';
import 'blocs/order/order_bloc.dart';
import 'repositories/order_repository.dart';
import 'repositories/category_repository.dart';
import 'blocs/category/category_bloc.dart';
import 'blocs/review/review_bloc.dart';
import 'repositories/review_repository.dart';
import 'blocs/voucher/voucher_bloc.dart';
import 'repositories/voucher_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
        ),
        BlocProvider(
          create:
              (context) => ProductBloc(productRepository: ProductRepository()),
        ),
        BlocProvider(
          create: (_) => WishlistBloc(wishlistRepository: WishlistRepository()),
        ),
        BlocProvider(
          create: (context) => CartBloc(cartRepository: CartRepository()),
        ),
        BlocProvider(
          create: (_) => OrderBloc(orderRepository: OrderRepository()),
        ),
        BlocProvider(
          create: (_) => CategoryBloc(categoryRepository: CategoryRepository()),
        ),
        BlocProvider(
          create:
              (context) => ReviewBloc(
                reviewRepository: ReviewRepository(),
                productBloc: context.read<ProductBloc>(),
              ),
        ),
        BlocProvider(
          create:
              (context) => VoucherBloc(voucherRepository: VoucherRepository()),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        home: const AppController(),
        routes: Routes.getRoutes(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
