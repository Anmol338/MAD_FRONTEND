import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:paila_kicks/data/models/cart/cart_item_model.dart';
import 'package:paila_kicks/logic/cubits/cart_cubit/cart_cubit.dart';
import 'package:paila_kicks/presentation/widgets/link_button.dart';

import '../../logic/services/formatter.dart';

class CartListview extends StatelessWidget {
  final List<CartItemModel> items;
  final bool shrinkWrap;
  final bool noScroll;
  const CartListview({super.key, required this.items, this.shrinkWrap = false, this.noScroll=false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: (noScroll) ? const NeverScrollableScrollPhysics() : null,
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return ListTile(
          leading: CachedNetworkImage(
            width: 50,
              imageUrl: item.product!.images![0]),
          title: Text("${item.product?.title}"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "${Formatter.formatPrice(item.product!.price!)} "
                      "x ${item.quantity} = ${Formatter.formatPrice(item.product!.price! * item.quantity!)}"),

              LinkButton(
                onPressed: () {
                  BlocProvider.of<CartCubit>(context).removeFromCart(item.product!);
                },
                text: "Delete",
                color: Colors.red,
              ),
            ],
          ),
          trailing: InputQty(
            maxVal: 99,
            initVal: item.quantity!, // Product Initial Quantity
            minVal: 1,
            onQtyChanged: (value) {
              if(value == item.quantity) {
                return;
              }
              // int num = value.toInt();
              BlocProvider.of<CartCubit>(context).addToCart(item.product!, value.toInt() as int);
            },
          ),
        );
      },
    );
  }
}
