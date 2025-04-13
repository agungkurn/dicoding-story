import 'package:dicoding_story/data/model/response/story.dart';
import 'package:dicoding_story/ui/details/details_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsScreen extends StatelessWidget {
  final String storyId;

  const DetailsScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DetailsBloc>();

    return BlocBuilder<DetailsBloc, DetailsState>(
      builder:
          (context, state) => CupertinoTheme(
            data: CupertinoTheme.of(
              context,
            ).copyWith(brightness: Brightness.dark),
            child: CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text(
                  state is DetailsSuccess ? state.story.name : "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              child:
                  state is DetailsLoading
                      ? Center(child: CupertinoActivityIndicator())
                      : state is DetailsError
                      ? Column(
                        children: [
                          Text(state.message ?? "Terjadi kesalahan"),
                          CupertinoButton(
                            child: Text("Coba Lagi"),
                            onPressed: () {
                              bloc.add(DetailsEvent.fetchDetails(storyId));
                            },
                          ),
                        ],
                      )
                      : state is DetailsSuccess
                      ? Container(
                        margin: MediaQuery.of(context).padding,
                        child: _DetailsContent(
                          context: context,
                          story: state.story.copyWith(
                            description: state.story.description,
                          ),
                          expandDescription: state.textExpanded,
                          onExpandDescription: () {
                            bloc.add(DetailsEvent.toggleDescription());
                          },
                        ),
                      )
                      : SizedBox.shrink(),
            ),
          ),
    );
  }

  Widget _DetailsContent({
    required BuildContext context,
    required Story story,
    required bool expandDescription,
    required GestureTapCallback onExpandDescription,
  }) => Stack(
    children: [
      SizedBox.expand(
        child: Image.network(story.photoUrl, fit: BoxFit.fitWidth),
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
          child: GestureDetector(
            onTap: onExpandDescription,
            child: AnimatedSize(
              duration: Duration(milliseconds: 100),
              child:
                  expandDescription
                      ? ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 150),
                        child: SingleChildScrollView(
                          child: Text(
                            story.description,
                            style: CupertinoTheme.of(
                              context,
                            ).textTheme.textStyle.copyWith(
                              fontSize: 14,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ),
                      )
                      : Text(
                        story.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: CupertinoTheme.of(
                          context,
                        ).textTheme.textStyle.copyWith(
                          fontSize: 14,
                          color: CupertinoColors.white,
                        ),
                      ),
            ),
          ),
        ),
      ),
    ],
  );
}
