import 'package:dicoding_story/data/model/response/story.dart';
import 'package:dicoding_story/di/di_config.dart';
import 'package:dicoding_story/ui/details/details_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsScreen extends StatelessWidget {
  final String storyId;

  const DetailsScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoTheme.of(context).copyWith(brightness: Brightness.dark),
      child: CupertinoPageScaffold(
        child: BlocProvider<DetailsBloc>(
          create:
              (_) =>
                  getIt<DetailsBloc>()..add(DetailsEvent.fetchDetails(storyId)),
          child: BlocBuilder<DetailsBloc, DetailsState>(
            builder: (context, state) {
              final bloc = context.read<DetailsBloc>();

              if (state is DetailsLoading) {
                return Center(child: CupertinoActivityIndicator());
              } else if (state is DetailsError) {
                return Column(
                  children: [
                    Text(state.message ?? "Terjadi kesalahan"),
                    CupertinoButton(
                      child: Text("Coba Lagi"),
                      onPressed: () {
                        bloc.add(DetailsEvent.fetchDetails(storyId));
                      },
                    ),
                  ],
                );
              } else if (state is DetailsSuccess) {
                return Container(
                  margin: MediaQuery.of(context).padding.copyWith(top: 0),
                  child: _DetailsContent(context, state.story),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _DetailsContent(BuildContext context, Story story) => Stack(
    children: [
      SizedBox.expand(
        child: Image.network(story.photoUrl, fit: BoxFit.fitWidth),
      ),
      Positioned(
        top: 0,
        right: 0,
        left: 0,
        child: CupertinoNavigationBar(
          middle: Text(
            story.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
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
          child: Text(
            story.description,
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ],
  );
}
