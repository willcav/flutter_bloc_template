import 'package:flutter/material.dart';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/widgets/shimmer_loading.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel?>> itemMap;
  final int depth;
  const Comment(
      {Key? key, required this.itemId, required this.itemMap, this.depth = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel?> snapshot) {
        if (!snapshot.hasData) {
          return const ShimmerLoading();
        }
        final item = snapshot.data!;

        final children = <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: ListTile(
              contentPadding: EdgeInsets.only(left: depth * 16, right: 16),
              title: buildText(item.text),
              subtitle: item.by == ''
                  ? Text(
                      'deleted',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    )
                  : Text(item.by),
            ),
          ),
          Divider()
        ];

        item.kids.forEach((kidId) {
          children.add(Comment(
            itemId: kidId,
            itemMap: itemMap,
            depth: depth + 1,
          ));
        });

        return Column(
          children: children,
        );
      },
    );
  }

  Widget buildText(String text) {
    final replacedText = text
        .replaceAll('&#x27;', '\'')
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', '');
    return Text(replacedText);
  }
}
