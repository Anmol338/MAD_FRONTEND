import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paila_kicks/data/models/cart/cart_item_model.dart';
import 'package:paila_kicks/data/models/product/product_model.dart';
import 'package:paila_kicks/data/repositories/cart_repository.dart';
import 'package:paila_kicks/logic/cubits/cart_cubit/cart_state.dart';
import 'package:paila_kicks/logic/cubits/user_cubit/user_state.dart';
import '../user_cubit/user_cubit.dart';

class CartCubit extends Cubit<CartState>{
  final UserCubit _userCubit;
  StreamSubscription? _userSubscription;

  CartCubit(this._userCubit) : super( CartInitialState() ) {
    
    // initial value
    _handelUserState(_userCubit.state);

    // Listening to the User Cubit for future update
    _userSubscription =  _userCubit.stream.listen(_handelUserState);
  }

  void _handelUserState(UserState userState) {
    if(userState is UserLoggedInState){
      _initialize(userState.userModel.sId!);
    }
    else if(state is UserLoggedOutState){
      emit( CartInitialState() );
    }
  }

  final _cartRepository = CartRepository();

  void sortAndLoad(List<CartItemModel> items){
    items.sort((a, b) => b.product!.title!.compareTo(a.product!.title!));
    emit( CartLoadedState(items) );
  }

  void _initialize(String userId) async{
    emit( CartLoadingState(state.items) );
    try{
      final items = await _cartRepository.fetchCartForUser(userId);
      sortAndLoad(items);
    }
    catch(ex) {
      emit( CartErrorState(ex.toString(), state.items) );
    }
  }

  void addToCart(ProductModel product, int quantity) async{
    emit( CartLoadingState(state.items) );
    try{
      if(_userCubit.state is UserLoggedInState){
        UserLoggedInState userState = _userCubit.state as UserLoggedInState;

        CartItemModel newItem = CartItemModel(
            product: product,
            quantity: quantity
        );
        final items = await _cartRepository.addToCart(newItem, userState.userModel.sId!);
        sortAndLoad(items);
      }
      else {
        throw "An error occured while adding the item!";
      }
    }
    catch(ex) {
      emit( CartErrorState(ex.toString(), state.items) );
    }
  }

  void removeFromCart(ProductModel product) async{
    emit( CartLoadingState(state.items) );
    try{
      if(_userCubit.state is UserLoggedInState){
        UserLoggedInState userState = _userCubit.state as UserLoggedInState;

        final items = await _cartRepository.removeFromCart(product.sId!, userState.userModel.sId!);
        sortAndLoad(items);
      }
      else {
        throw "An error occured while removing the item!";
      }
    }
    catch(ex) {
      emit( CartErrorState(ex.toString(), state.items) );
    }
  }

  bool cartContains(ProductModel product){
    if(state.items.isNotEmpty){
      final foundItem = state.items.where((item) => item.product!.sId!
      == product.sId!).toList();
      if(foundItem.isNotEmpty) {
        return true;
      }
      else {
        return false;
      }
    }
    return false;
  }

  void clearCart() {
    emit( CartLoadedState([]) );
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

}