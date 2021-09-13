import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_provider.dart';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/widgets/shimmer_loading.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;
  const NewsListTile({
    Key? key,
    required this.itemId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
        stream: bloc.items,
        builder:
            (context, AsyncSnapshot<Map<int, Future<ItemModel?>>> snapshot) {
          if (!snapshot.hasData) {
            return const ShimmerLoading();
          }

          return FutureBuilder(
            future: snapshot.data![itemId],
            builder: (context, AsyncSnapshot<ItemModel?> itemSnapshot) {
              if (!itemSnapshot.hasData) {
                return const ShimmerLoading();
              }
              return buildTile(context, itemSnapshot.data!);
            },
          );
        });
  }

  Widget buildTile(BuildContext context, ItemModel item) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/${item.id}');
          },
          title: Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.message),
              Text('${item.descendants}'),
            ],
          ),
          subtitle: Text('${item.score} Points'),
        ),
        Divider(
          height: 8,
        )
      ],
    );
  }
}
