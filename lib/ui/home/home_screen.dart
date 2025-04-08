import 'package:dicoding_story/ui/home/story_list_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/remote/display_exception.dart';
import '../../di/di_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Dicoding Story")),
      child: BlocProvider<StoryListBloc>(
        create:
            (context) =>
                getIt<StoryListBloc>()..add(StoryListEvent.fetchList()),
        child: BlocConsumer<StoryListBloc, StoryListState>(
          listener: (context, state) {
            if (state is StoryListDetailsOpened) {
              // TODO: navigate
            } else if (state is StoryListError) {
              final msg =
                  (state.exception != null &&
                          state.exception is DisplayException)
                      ? (state.exception as DisplayException).message
                      : null;

              showCupertinoDialog(
                context: context,
                builder:
                    (context) => CupertinoAlertDialog(
                      title: Text("Terjadi kesalahan"),
                      content: Text(msg ?? "Silahkan coba lagi nanti"),
                      actions: [
                        CupertinoButton(
                          child: Text("Oke"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
              );
            }
          },
          builder: (context, state) {
            final bloc = context.read<StoryListBloc>();

            if (state is StoryListLoading) {
              return Center(child: CupertinoActivityIndicator());
            } else if (state is StoryListSuccess) {
              return ListView.builder(
                itemCount: state.stories.length,
                itemBuilder: (context, i) {
                  final story = state.stories[i];
                  return _StoryItem(
                    context: context,
                    image: story.photoUrl,
                    name: story.name,
                    description: story.description,
                    onTap: () {},
                  );
                },
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _StoryItem({
    required BuildContext context,
    required String image,
    required String name,
    required String description,
    required GestureTapCallback onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: Stack(
      children: [
        AspectRatio(
          aspectRatio: 4.0 / 3.0,
          child: Image.network(image, fit: BoxFit.cover),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CupertinoColors.black.withAlpha(0),
                  CupertinoColors.black.withAlpha(100),
                  CupertinoColors.black.withAlpha(200),
                  CupertinoColors.black,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  name,
                  style: CupertinoTheme.of(context).textTheme.textStyle
                      .copyWith(color: CupertinoColors.white, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  description,
                  style: CupertinoTheme.of(context).textTheme.textStyle
                      .copyWith(color: CupertinoColors.white, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
