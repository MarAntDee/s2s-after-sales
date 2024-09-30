import 'package:flutter/material.dart';

import '../models/products.dart';

class ProductShelf extends StatelessWidget {
  final List<Product> products;
  final Product? initialProduct;
  final FormFieldValidator<Product>? validator;
  final FormFieldSetter<Product>? onSaved;
  const ProductShelf(this.products,
      {super.key, this.validator, this.onSaved, this.initialProduct});

  @override
  Widget build(BuildContext context) {
    return FormField<Product>(
      initialValue: initialProduct,
      validator: validator,
      onSaved: onSaved,
      builder: (state) => ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              state.errorText ?? "",
              style: Theme.of(state.context).textTheme.caption!.apply(
                    color: Theme.of(state.context).errorColor,
                  ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: products.map(
              (product) {
                return ProductCard(
                  product,
                  selected: state.value == product,
                  onChanged: (isSelected) => state.didChange(product),
                );
              },
            ).toList(),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: 30.0, bottom: state.hasError ? 20 : 0),
            child: Text(
              state.errorText ?? "",
              style: Theme.of(state.context).textTheme.caption!.apply(
                    color: Theme.of(state.context).errorColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final ValueChanged<bool>? onChanged;
  final bool selected;
  final double _padding;

  const ProductCard(this.product,
      {super.key, this.selected = false, this.onChanged})
      : _padding = 30;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCirc,
      margin: EdgeInsets.symmetric(horizontal: _padding, vertical: 6),
      height: 140,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        border: Border.all(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.onBackground.withOpacity(0.6),
          width: selected ? 4 : 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        onTap: onChanged == null ? null : () => onChanged!(selected),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        product.name,
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (product.hasDescription)
                    Text(
                      product.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.6),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 72,
              height: 72,
              child: AspectRatio(
                aspectRatio: 1,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.secondary,
                        width: 4,
                      ),
                    ),
                    child: FittedBox(
                      child: Text(
                        product.price.toInt().toString(),
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: theme.colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}