import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_merchant/utils/SizeConfig.dart';
import 'package:get/get.dart';

import '../../constant/app_color.dart';
import '../../utils/ImagePicker.dart';
import 'ImagePreviewController.dart';

class PreviewImages extends StatelessWidget {
  PreviewImages({
    required this.selectedImages,
  });
  List<String>  selectedImages;
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    ImagePreviewController controller = Get.put(ImagePreviewController(selectedImages));
    return Scaffold(
      backgroundColor: colorWhite,
      body:  Obx(()=> controller.newList.isNotEmpty ?
      Stack(alignment: Alignment.topCenter,
        children:[ PageView.builder(
            padEnds: false,
            controller: controller.pageController,
            itemCount: controller.newList.length,
            pageSnapping: true,
            onPageChanged: (page) {
              controller.activePage.value = page;
            },
            itemBuilder: (context, pagePosition) {
              return
                     Image.file(
                    File(controller
                        .newList[pagePosition]),
                       fit: BoxFit.fitWidth,
                       //height: MediaQuery.of(context).size.height-kToolbarHeight,
                   );
            }),

          Container(width: SizeConfig.blockSizeHorizontal*100,
            margin:  EdgeInsets.only(top: MediaQuery.of(context).padding.top+2),
            padding: const EdgeInsets.only(left: 3,right: 3),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width:SizeConfig.blockSizeHorizontal*40-3,
                  child: Align(alignment: AlignmentDirectional.topStart,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black45),
                      child: IconButton(onPressed: () { Get.back(); }, icon: const Icon(
                        Icons.arrow_back,
                        color: colorWhite,
                      ),),
                    ),
                )),
                SizedBox(width:SizeConfig.blockSizeHorizontal*60-3,
                  child: Align(alignment: AlignmentDirectional.topEnd,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black45,
                        ),
                          child: IconButton(
                            onPressed: () {
                              controller.deleteImage();

                            },
                            icon: const Icon(
                              Icons.delete_outline_outlined,
                              color: colorWhite,
                            ),
                          ),
                        ),
                        Container(decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black45,
                        ),
                          child: IconButton(
                            onPressed: () async {
                            await ImgPicker.cropImage(controller.newList[controller.activePage.value])
                                ?.then((value) {
                              if (value != null) {
                              controller.newList[controller.activePage.value] = value;
                              controller.newList.refresh();
                              }
                            }); },
                            icon: const Icon(
                              Icons.crop,
                              color: colorWhite,
                            ),
                          ),
                        ),
                        Container(decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black45,
                        ),
                          child: IconButton(
                            onPressed: () {
                              controller.done();
                            },
                            icon: const Icon(
                              Icons.done,
                              color: colorWhite,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
      ]): const Center(child: Text("No Image Found"),)),


    );

  }
}