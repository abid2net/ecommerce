import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/models/order_model.dart';
import 'package:ecommerce/repositories/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;

  OrderBloc({required OrderRepository orderRepository})
    : _orderRepository = orderRepository,
      super(OrderInitial()) {
    on<LoadOrders>(_onLoadOrders);
  }

  Future<void> _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    try {
      emit(OrderLoading());
      await emit.forEach(
        _orderRepository.getOrders(),
        onData: (List<OrderModel> orders) => OrderLoaded(orders),
        onError: (error, stackTrace) => OrderError(error.toString()),
      );
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
