import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class RatInfo extends StatefulWidget {
  const RatInfo({super.key, required this.info,});

  final dynamic info;

  @override
  State<RatInfo> createState() => _RatInfoState(info: info);
}

class _RatInfoState extends State<RatInfo> {
  _RatInfoState({required this.info});

  final dynamic info;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('data'),);
  }
}