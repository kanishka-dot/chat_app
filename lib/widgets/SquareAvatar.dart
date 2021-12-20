import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

@immutable
class SquareAvatar extends StatelessWidget {
  final String backgroundImage;
  bool isActive = false;

  SquareAvatar(this.backgroundImage, {this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(20.0),
      ),
      child: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
        Container(
            height: 40.0,
            width: 40.0,
            child: backgroundImage == ""
                ? new Image.asset(
                    'assets/person1.png',
                  )
                : CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: backgroundImage == ""
                        ? 'assets/person1.png'
                        : backgroundImage,
                  )),
        ConditionRender(isActive)
      ]),
    );
  }
}

class ConditionRender extends StatelessWidget {
  final bool isActive;
  ConditionRender(this.isActive);

  Widget build(BuildContext context) {
    return Visibility(
      visible: isActive,
      child: Positioned(
          child: Container(
            child: Icon(
              Icons.circle,
              color: Colors.green,
              size: 10,
            ),
          ),
          bottom: 30,
          left: 30),
    );
  }
}
