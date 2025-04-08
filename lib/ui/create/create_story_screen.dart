import 'dart:io';

import 'package:dicoding_story/di/di_config.dart';
import 'package:dicoding_story/ui/create/create_story_bloc.dart';
import 'package:dicoding_story/widgets/custom_cupertino_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CreateStoryScreen extends StatelessWidget {
  const CreateStoryScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<CreateStoryBloc>(
    create: (_) => getIt<CreateStoryBloc>(),
    child: BlocConsumer<CreateStoryBloc, CreateStoryState>(
      listener: (context, state) {
        if (state.success) {
          context.pop(true);
          return;
        }

        if (state.error) {
          showCupertinoDialog(
            context: context,
            builder:
                (context) => CupertinoAlertDialog(
                  title: Text("Terjadi kesalahan"),
                  content: Text(
                    state.errorMessage ?? "Silahkan coba lagi nanti",
                  ),
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
        final bloc = context.read<CreateStoryBloc>();
        return CupertinoTheme(
          data: CupertinoTheme.of(
            context,
          ).copyWith(brightness: Brightness.dark),
          child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text("Buat Story Baru"),
              trailing: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child:
                    state.loading
                        ? CupertinoActivityIndicator()
                        : state.canSubmit
                        ? CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 0,
                          child: Icon(Icons.send),
                          onPressed: () {
                            bloc.add(CreateStoryEvent.onSubmit());
                          },
                        )
                        : SizedBox.shrink(),
              ),
            ),
            child: Container(
              margin: MediaQuery.of(context).padding,
              child: _CreateStoryContent(
                context: context,
                editable: !state.loading,
                image: state.image,
                openImagePicker: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (pickedFile != null) {
                    bloc.add(CreateStoryEvent.addImage(pickedFile));
                  }
                },
                onRemoveImage: () {
                  bloc.add(CreateStoryEvent.removeImage());
                },
                onDescriptionChanged: (text) {
                  bloc.add(CreateStoryEvent.onDescriptionChanges(text));
                },
                descriptionErrorText:
                    state.descriptionIsEmpty
                        ? "Deskripsi tidak boleh kosong"
                        : null,
              ),
            ),
          ),
        );
      },
    ),
  );

  Widget _CreateStoryContent({
    required BuildContext context,
    required bool editable,
    required XFile? image,
    required GestureTapCallback openImagePicker,
    required VoidCallback onRemoveImage,
    required Function(String) onDescriptionChanged,
    required String? descriptionErrorText,
  }) => SizedBox.expand(
    child: Stack(
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child:
              image == null
                  ? GestureDetector(
                    onTap: openImagePicker,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: CupertinoColors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: CupertinoColors.white),
                          Text(
                            "Tambah foto",
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .copyWith(color: CupertinoColors.white),
                          ),
                        ],
                      ),
                    ),
                  )
                  : Align(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.file(File(image.path), fit: BoxFit.fitWidth),
                        if (editable)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CupertinoButton(
                              color: CupertinoColors.systemRed,
                              padding: EdgeInsets.zero,
                              sizeStyle: CupertinoButtonSize.small,
                              onPressed: onRemoveImage,
                              child: Icon(
                                Icons.clear,
                                color: CupertinoColors.white,
                              ),
                            ),
                          ),
                      ],
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: CupertinoColors.black),
            child: CustomCupertinoTextField(
              placeholder: "Deskripsi",
              errorText: descriptionErrorText,
              onChanged: onDescriptionChanged,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 10,
              minLines: 1,
              enabled: editable,
            ),
          ),
        ),
      ],
    ),
  );
}
