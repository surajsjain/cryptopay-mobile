import 'package:crypto_pay/utils/ColorCombo.dart';
import 'package:crypto_pay/utils/HexColor.dart';
import 'package:flutter/material.dart';

class HeadedCard extends StatelessWidget {
  const HeadedCard({
    Key key,
    @required this.headContent,
    @required this.bodyContent,
    @required this.colorScheme,
    @required this.cardPress,
    this.usePad = true,
  }) : super(key: key);

  final Widget headContent, bodyContent;
  final Function cardPress;
  final ColorCombo colorScheme;
  final bool usePad;

  @override
  Widget build(BuildContext context) {
    HexColor hxc = HexColor();

    return GestureDetector(
      onTap: this.cardPress,
      child: Card(
        color: colorScheme.backgoundColor,
        elevation: 2.0,
        child: Padding(
          padding: (this.usePad)
              ? const EdgeInsets.all(12.0)
              : const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: this.headContent,
              ),
              Expanded(
                flex: 9,
                child: this.bodyContent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
