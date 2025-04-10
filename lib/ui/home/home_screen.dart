import 'package:dicoding_story/auth/auth_bloc.dart';
import 'package:dicoding_story/navigation/app_route.dart';
import 'package:dicoding_story/ui/home/story_list_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../di/di_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBlocRead = context.read<AuthBloc>();
    final authBlocWatch = context.watch<AuthBloc>();

    return BlocProvider<StoryListBloc>(
      create:
          (context) => getIt<StoryListBloc>()..add(StoryListEvent.fetchList()),
      child: BlocBuilder<StoryListBloc, StoryListState>(
        builder: (context, state) {
          final storyBloc = context.read<StoryListBloc>();

          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text("Dicoding Story"),
              trailing:
                  authBlocWatch.state is AuthLoading
                      ? CupertinoActivityIndicator()
                      : CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 0,
                        onPressed: () async {
                          final index = await showCupertinoModalPopup<int>(
                            context: context,
                            builder: (context) => _MoreOptions(context),
                          );

                          switch (index) {
                            case 0:
                              final uploaded = await context.push<bool>(
                                AppRoute.createStory,
                              );
                              if (uploaded == true) {
                                storyBloc.add(StoryListEvent.fetchList());
                              }

                              break;
                            case 1:
                              authBlocRead.add(AuthEvent.logout());
                              break;
                            default:
                              break;
                          }
                        },
                        child: Icon(CupertinoIcons.ellipsis),
                      ),
            ),
            child:
                state is StoryListLoading
                    ? Center(child: CupertinoActivityIndicator())
                    : state is StoryListSuccess
                    ? ListView.builder(
                      itemCount: state.stories.length,
                      itemBuilder: (context, i) {
                        final story = state.stories[i];
                        return _StoryItem(
                          context: context,
                          image: story.photoUrl,
                          name: story.name,
                          description: story.description,
                          onTap: () {
                            context.push(AppRoute.details, extra: story.id);
                          },
                        );
                      },
                    )
                    : state is StoryListError
                    ? Column(
                      children: [
                        Text(state.message ?? "Terjadi kesalahan"),
                        CupertinoButton(
                          child: Text("Coba Lagi"),
                          onPressed: () {
                            storyBloc.add(StoryListEvent.fetchList());
                          },
                        ),
                      ],
                    )
                    : SizedBox.shrink(),
          );
        },
      ),
    );
  }

  CupertinoActionSheet _MoreOptions(BuildContext context) =>
      CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context, 0);
            },
            child: Text("Buat Story"),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context, 1);
            },
            child: Text("Keluar"),
          ),
        ],
      );

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
