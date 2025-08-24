import 'dart:io';

import 'package:camerawesome/pigeon.dart';
import 'package:check_object/core/remote_api_service.dart';
import 'package:check_object/providers/multi_select_provider.dart';
import 'package:check_object/widgets/custom_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:provider/provider.dart';

class CameraPage extends StatefulWidget {
  final VoidCallback? saveForm;
  final Function(bool)? onDone;

  const CameraPage({super.key, this.saveForm, this.onDone});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final selectedObjects = context.read<MultiSelectProvider>().data;

    return Center(
      child: CameraAwesomeBuilder.awesome(
        sensorConfig: SensorConfig.single(
          flashMode: FlashMode.auto,
          aspectRatio: CameraAspectRatios.ratio_16_9,
        ),
        theme: AwesomeTheme(bottomActionsBackgroundColor: Colors.transparent),
        saveConfig: SaveConfig.photo(
          exifPreferences: ExifPreferences(saveGPSLocation: true),
          pathBuilder: (sensors) async {
            Directory appDocumentsDir = await getApplicationDocumentsDirectory();
            Directory pictureDir = Directory("${appDocumentsDir.path}/pictures");

            final String filePath =
                "${pictureDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

            return SingleCaptureRequest(filePath, sensors.first);
          },
        ),
        bottomActionsBuilder: (state) {
          return Stack(
            children: [
              Center(
                child: IconButton(
                  iconSize: 68,
                  color: Colors.yellowAccent,
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    state.when(
                      onPhotoMode: (photoState) async {
                        setState(() {
                          loading = true;
                        });

                        var captureRequest = await photoState.takePhoto() as SingleCaptureRequest;
                        final filePath = captureRequest.path;

                        bool success = false;

                        if (filePath != null) {
                          try {
                            final objectId = selectedObjects.hashCode.toString();
                            final metadata = {
                              "object_id": objectId,
                              "timestamp": DateTime.now().toIso8601String(),
                              "selected_objects": selectedObjects,
                            };

                            await RemoteApiService()
                                .sendDataToS3(filePath, metadata, objectId);

                            print("File and metadata uploaded successfully to S3!");
                            success = true;
                          } catch (e) {
                            print("Error uploading file to S3: $e");
                          }
                        } else {
                          print("Error: No file path found");
                        }

                        context.read<MultiSelectProvider>().clear();
                        setState(() {
                          loading = false;
                        });
                        widget.saveForm?.call();

                        if (!mounted) return;

                        if (success) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Успешно'),
                                content: const Text('Данные успешно отправлены'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Закрыть диалог
                                      widget.onDone?.call(true);
                                    },
                                    child: const Text('ОК'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          widget.onDone?.call(false);
                        }
                      },
                    );
                  },
                  icon: const Icon(Icons.camera),
                ),
              ),
              if (loading) const CustomCircularLoading(),
            ],
          );
        },
      ),
    );
  }
}