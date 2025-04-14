import 'dart:io';

import 'package:dicoding_story/ui/create/create_story_bloc.dart';
import 'package:dicoding_story/widgets/custom_cupertino_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../navigation/app_route.dart';

class CreateStoryScreen extends StatelessWidget {
  const CreateStoryScreen({super.key});

  @override
  Widget build(
    BuildContext context,
  ) => BlocConsumer<CreateStoryBloc, CreateStoryState>(
    listener: (context, state) {
      if (state.success) {
        context.pop(true);
        return;
      }

      if (state.error) {
            context.push(AppRoute.errorDialog, extra: state.errorMessage);
          }
        },
        builder: (context, state) {
          final bloc = context.read<CreateStoryBloc>();
          return CupertinoTheme(
            data: CupertinoTheme.of(context).copyWith(
                brightness: Brightness.dark),
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
              child: SafeArea(
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
              location: state.location,
              onChooseLocation: () async {
                final currentLat = state.latitude;
                final currentLong = state.longitude;

                final result = await context.push<Map<String, Object>>(
                  "${AppRoute.createStoryMap}?${AppRoute.mapLatitude}=$currentLat&"
                  "${AppRoute.mapLongitude}=$currentLong&",
                );

                if (result != null) {
                  final newLat = double.tryParse(
                    result[AppRoute.mapLatitude]?.toString() ?? "",
                  );
                  final newLong = double.tryParse(
                    result[AppRoute.mapLongitude]?.toString() ?? "",
                  );
                  final newLocation =
                      result[AppRoute.mapAddress]?.toString() ?? "";

                  bloc.add(
                    CreateStoryEvent.locationAdded(
                      newLocation,
                      newLat!,
                      newLong!,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );
    },
  );

  Widget _CreateStoryContent({
    required BuildContext context,
    required bool editable,
    required XFile? image,
    required GestureTapCallback openImagePicker,
    required VoidCallback onRemoveImage,
    required Function(String) onDescriptionChanged,
    required String? descriptionErrorText,
    required String? location,
    required GestureTapCallback onChooseLocation,
  }) => SizedBox.expand(
    child: Column(
      children: [
        Expanded(
          child: AnimatedSwitcher(
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
                    : Stack(
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: CupertinoColors.black),
          child: Column(
            spacing: 16,
            children: [
              CustomCupertinoTextField(
                placeholder: "Deskripsi",
                errorText: descriptionErrorText,
                onChanged: onDescriptionChanged,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 10,
                minLines: 1,
                enabled: editable,
              ),
              _LocationWidget(
                context: context,
                address: location,
                onTap: onChooseLocation,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _LocationWidget({
    required BuildContext context,
    required String? address,
    required GestureTapCallback onTap,
  }) => CupertinoButton.tinted(
    onPressed: onTap,
    child: Row(
      spacing: 8,
      children: [
        Icon(Icons.location_pin),
        Flexible(
          child: Text(
            address ?? "Tambah lokasi",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CupertinoTheme.of(
              context,
            ).textTheme.textStyle.copyWith(fontSize: 14),
          ),
        ),
      ],
    ),
  );
}
