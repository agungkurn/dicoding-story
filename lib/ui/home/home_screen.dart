import 'package:dicoding_story/auth/auth_bloc.dart';
import 'package:dicoding_story/navigation/app_route.dart';
import 'package:dicoding_story/ui/home/story_list_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  late final StoryListBloc storyBloc;

  @override
  void initState() {
    super.initState();
    storyBloc = context.read<StoryListBloc>();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (storyBloc.state.hasNextPage) {
          storyBloc.add(StoryListEvent.fetchList());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authBlocRead = context.read<AuthBloc>();
    final authBlocWatch = context.watch<AuthBloc>();

    return BlocBuilder<StoryListBloc, StoryListState>(
      builder:
          (context, state) => CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text("Dicoding Story"),
              trailing:
                  authBlocWatch.state is AuthLoading
                      ? CupertinoActivityIndicator()
                      : CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 0,
                        onPressed: () async {
                          final index = await context.push(AppRoute.sheetHome);

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
                state.loading
                    ? _OnLoading()
                    : state.error
                    ? _OnError(state.errorMessage)
                    : _OnSuccess(state),
          ),
    );
  }

  Widget _OnLoading() => Center(child: CupertinoActivityIndicator());

  Widget _OnError(String? message) => Column(
    children: [
      Text(message ?? "Terjadi kesalahan"),
      CupertinoButton(
        child: Text("Coba Lagi"),
        onPressed: () {
          storyBloc.add(StoryListEvent.fetchList());
        },
      ),
    ],
  );

  Widget _OnSuccess(StoryListState state) => ListView.builder(
    controller: scrollController,
    itemCount: state.stories.length + (state.hasNextPage ? 1 : 0),
    itemBuilder: (context, i) {
      if (i == state.stories.length && state.hasNextPage) {
        return _OnLoading();
      }

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

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
