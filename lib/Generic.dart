import 'package:flutter/material.dart';

class GenericFutureBuilder<T> extends StatelessWidget {
  final Future<List<T>> future;
  final List<T> initialData;
  final Widget Function(BuildContext context, List<T> data) builder;

  const GenericFutureBuilder({
    required this.future,
    required this.initialData,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      initialData: initialData,
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No data found', style: TextStyle(color: Colors.white)));
        } else {
          return builder(context, snapshot.data!);
        }
      },
    );
  }
}