import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monogram/Constants/app_colors.dart';
import 'package:monogram/SharedWidgets/circular_clipper.dart';
import 'package:monogram/generated/l10n.dart';

class ProfilePicture extends StatefulWidget {
  final XFile? selectedImage;
  final Function(XFile?) getNewSelectedImage;

  const ProfilePicture({
    Key? key,
    required this.getNewSelectedImage,
    this.selectedImage,
  }) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  XFile? image;

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            barrierColor: Colors.transparent,
            constraints: BoxConstraints(
              maxHeight: 160,
              minWidth: MediaQuery.of(context).size.width,
            ),
            backgroundColor: AppColors.grey,
            shape: const OutlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            image = await picker.pickImage(source: ImageSource.camera);
                            widget.getNewSelectedImage(image);
                          },
                          child: Text(
                            S.of(context).camera,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          style: ButtonStyle(overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.white,
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.image,
                          color: Colors.white,
                          size: 26,
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            image = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            widget.getNewSelectedImage(image);
                          },
                          child: Text(
                            S.of(context).gallery,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          style: ButtonStyle(overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)),
                        ),
                      ],
                    ),
                    if (widget.selectedImage != null)
                      const Divider(
                        thickness: 0.5,
                        color: Colors.white,
                        height: 5,
                      ),
                    if (widget.selectedImage != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 26,
                          ),
                          TextButton(
                            onPressed: () async {
                              image = null;
                              widget.getNewSelectedImage(image);
                              Navigator.pop(context);
                            },
                            child: Text(
                              S.of(context).remove,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            style: ButtonStyle(overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            });
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          widget.selectedImage == null
              ? const Icon(
                  Icons.account_circle,
                  color: Colors.grey,
                  size: 290,
                )
              : ClipOval(
                  clipper: CircularClipper(),
                  child: Image.file(
                    File(widget.selectedImage!.path),
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
          widget.selectedImage == null
              ? const Positioned(
                  bottom: 15,
                  right: 25,
                  child: Icon(
                    Icons.add_circle,
                    size: 65,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
