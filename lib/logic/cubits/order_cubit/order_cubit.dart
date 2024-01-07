import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paila_kicks/data/models/order/order_model.dart';
import 'package:paila_kicks/data/repositories/order_repository.dart';
import 'package:paila_kicks/logic/cubits/order_cubit/order_state.dart';
import 'package:paila_kicks/logic/cubits/user_cubit/user_state.dart';

import '../../../data/models/cart/cart_item_model.dart';
import '../cart_cubit/cart_cubit.dart';
import '../user_cubit/user_cubit.dart';

class OrderCubit extends Cubit<OrderState> {
  final UserCubit _userCubit;
  final CartCubit _cartCubit;
  StreamSubscription? _userSubscription;

  OrderCubit(this._userCubit, this._cartCubit) : super(OrderInitialState()) {
    // initial value
    _handelUserState(_userCubit.state);

    // Listening to the User Cubit for future update
    _userSubscription = _userCubit.stream.listen(_handelUserState);
  }

  void _handelUserState(UserState userState) {
    if (userState is UserLoggedInState) {
      _initialize(userState.userModel.sId!);
    } else if (state is UserLoggedOutState) {
      emit(OrderInitialState());
    }
  }

  final _orderRepository = OrderRepository();

  void _initialize(String userId) async {
    emit(OrderLoadingState(state.orders));
    try {
      final orders = await _orderRepository.fetchOrdersForUser(userId);
      emit(OrderLoadedState(orders));
    } catch (ex) {
      emit(OrderErrorState(ex.toString(), state.orders));
    }
  }

  Future<bool> createOrder(
      {required List<CartItemModel> items,
      required String paymentMethod}) async {
    emit(OrderLoadingState(state.orders));

    try {
      if(_userCubit.state is! UserLoggedInState) {
        return false;
      }

      OrderModel newOrder = OrderModel(
        items: items,
        user: (_userCubit.state as UserLoggedInState).userModel,
        status: (paymentMethod == "pay-on-delivery") ? "order-placed" : "payment-pending"
      );
      final order = await _orderRepository.createOrder(newOrder);

      List<OrderModel> orders = [ order, ...state.orders];

      emit( OrderLoadedState(orders) );

      // Clear the cart
      _cartCubit.clearCart();

      return true;
    } catch (ex) {
      emit(OrderErrorState(ex.toString(), state.orders));
      return false;
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    // TODO: implement close
    return super.close();
  }
}
