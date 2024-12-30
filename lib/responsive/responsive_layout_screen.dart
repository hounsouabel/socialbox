import 'package:flutter/material.dart';
import 'package:groupe7/utilities/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;


  @override

  const ResponsiveLayout({super.key, required this.mobileScreenLayout, required this.webScreenLayout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints)
    {
      if(constraints.maxWidth >webScreenSize)
      {
          return webScreenLayout;
      }
      return mobileScreenLayout;
  });}
}
