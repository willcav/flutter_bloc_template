import 'package:flutter/material.dart';
import 'package:news/src/blocs/comments_provider.dart';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/widgets/comment.dart';
import 'package:news/src/widgets/shimmer_loading.dart';

class NewsDetailScreen extends StatelessWidget {
  final int itemId;
  const NewsDetailScreen({Key? key, required this.itemId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
        stream: bloc.itemWithComments,
        builder:
            (context, AsyncSnapshot<Map<int, Future<ItemModel?>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final itemFuture = snapshot.data![itemId];

          return FutureBuilder(
            future: itemFuture,
            builder: (context, AsyncSnapshot<ItemModel?> itemSnapshot) {
              if (!itemSnapshot.hasData) {
                return const ShimmerLoading();
              }
              return buildList(itemSnapshot.data!, snapshot.data!);
            },
          );
        });
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel?>> itemMap) {
    final List<Widget> children = <Widget>[];
    children.add(buildTitle(item));

    final List<Widget> commentsList = item.kids.map((kidId) {
      return Comment(
        itemId: kidId,
        itemMap: itemMap,
      );
    }).toList();

    children.addAll(commentsList);

    return ListView(
      cacheExtent: itemMap.length.toDouble(),
      children: children,
    );
  }

  Widget buildTitle(ItemModel item) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.all(10),
      child: Text(
        item.title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
