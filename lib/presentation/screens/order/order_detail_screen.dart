import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paila_kicks/core/ui.dart';
import 'package:paila_kicks/data/models/user/user_model.dart';
import 'package:paila_kicks/logic/cubits/cart_cubit/cart_cubit.dart';
import 'package:paila_kicks/logic/cubits/cart_cubit/cart_state.dart';
import 'package:paila_kicks/logic/cubits/user_cubit/user_cubit.dart';
import 'package:paila_kicks/logic/cubits/user_cubit/user_state.dart';
import 'package:paila_kicks/presentation/screens/order/order_placed_screen.dart';
import 'package:paila_kicks/presentation/screens/order/providers/order_detail_provider.dart';
import 'package:paila_kicks/presentation/screens/user/edit_profile_screen.dart';
import 'package:paila_kicks/presentation/widgets/cart_list_view.dart';
import 'package:paila_kicks/presentation/widgets/gap_widget.dart';
import 'package:paila_kicks/presentation/widgets/link_button.dart';
import 'package:paila_kicks/presentation/widgets/primary_button.dart';
import 'package:provider/provider.dart';

import '../../../logic/cubits/order_cubit/order_cubit.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  static const routeName = "order_detail";

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Order"),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              "User Details :-",
              style: TextStyles.body2.copyWith(fontWeight: FontWeight.bold),
            ),
            const GapWidget(),
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserLoadingState) {
                  return const CircularProgressIndicator();
                }

                if (state is UserLoggedInState) {
                  UserModel user = state.userModel;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${user.fullName}",
                        style: TextStyles.heading3,
                      ),
                      Text(
                        "Email: ${user.email}",
                        style: TextStyles.body2,
                      ),
                      Text(
                        "Phone: ${user.phoneNumber}",
                        style: TextStyles.body2,
                      ),
                      const GapWidget(
                        size: 20,
                      ),
                      Text(
                        "Shipping Address :-",
                        style: TextStyles.body2
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const GapWidget(),
                      Text(
                        "Address: ${user.address}, ${user.city}, ${user.state}",
                        style: TextStyles.body2,
                      ),
                      LinkButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, EditProfileScreen.routeName);
                          },
                          text: "Edit Details"),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
            const GapWidget(
              size: 10,
            ),
            Text(
              "Items",
              style: TextStyles.body2.copyWith(fontWeight: FontWeight.bold),
            ),
            const GapWidget(),
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                if (state is CartLoadingState && state.items.isEmpty) {
                  return const CircularProgressIndicator();
                }

                if (state is CartErrorState && state.items.isEmpty) {
                  return Text(state.message);
                }

                return CartListview(
                  items: state.items,
                  shrinkWrap: true,
                  noScroll: true,
                );
              },
            ),
            const GapWidget(
              size: 10,
            ),
            Text(
              "Payment",
              style: TextStyles.body2.copyWith(fontWeight: FontWeight.bold),
            ),
            const GapWidget(),
            Consumer<OrderDetailProvider>(builder: (context, provider, child) {
              return Column(
                children: [
                  RadioListTile(
                    value: "pay-on-delivery",
                    groupValue: provider.paymentMethod,
                    contentPadding: EdgeInsets.zero,
                    onChanged: provider.changePaymentMethod,
                    title: const Text("Pay On Delivery"),
                  ),
                  RadioListTile(
                    value: "pay-now",
                    groupValue: provider.paymentMethod,
                    contentPadding: EdgeInsets.zero,
                    onChanged: provider.changePaymentMethod,
                    title: const Text("Pay Now"),
                  ),
                ],
              );
            }),
            const GapWidget(),
            PrimaryButton(
                onPressed: () async {
                  bool success = await BlocProvider.of<OrderCubit>(context).createOrder(
                    items: BlocProvider.of<CartCubit>(context).state.items,
                    paymentMethod:
                        Provider.of<OrderDetailProvider>(context, listen: false)
                            .paymentMethod
                            .toString(),
                  );

                  if(success){
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushNamed(context, OrderPlacedScreen.routeName);
                  }
                },
                text: "Place Order"),
          ],
        ),
      ),
    );
  }
}
