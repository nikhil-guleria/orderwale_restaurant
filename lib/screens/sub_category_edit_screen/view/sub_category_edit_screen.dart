import 'package:flutter/material.dart';
import 'package:food_merchant/constant/app_color.dart';
import 'package:food_merchant/screens/sub_category_edit_screen/controller/sub_category_edit_controller.dart';
import 'package:get/get.dart';
import '../../../component/ColorLoader.dart';
import '../../../component/TextWidget.dart';
import '../../../constant/app_constant.dart';
import '../../../constant/string_constants.dart';
import '../../../utils/SizeConfig.dart';



class SubCategoryEditScreen extends GetView<SubCategoryEditController> {
  const SubCategoryEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var child = Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: TextWidget(text:  subCategoryEditAppTitle,
            color: Colors.black,
            fontSize: SizeConfig.appbarTitleSize,
            fontFamily: fontSemiBold,
            weight: FontWeight.w600,),
          elevation: 0.0,
          centerTitle: true),
      body:
      Obx(()=>
      Container(
        height: Get.height,
        width: Get.width,
        padding: EdgeInsets.only(
            bottom:  SizeConfig.blockSizeHorizontal*2,
            left: SizeConfig.blockSizeHorizontal*3,
            right: SizeConfig.blockSizeHorizontal*3
        ),
        child:
        controller.initialLoad.value ?
            Center(
              child: ColorLoader(),
            )

       : ListView.builder(
            itemCount: controller.subCategoryList.length,
            itemBuilder: (context, index){
              return Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          controller.deleteButtonClick(index);
                        },
                        child: Container(
                          padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal * 0.75),
                          child: Center(
                              child: Icon(Icons.remove_circle, color: Colors.red,
                                  size: SizeConfig.blockSizeHorizontal*6)),
                        ),
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                      Expanded(
                        child: TextWidget(text: "${controller.subCategoryList[index].title}",
                        ),
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal*2),
                      InkWell(
                        onTap: (){
                          controller.editButtonClick(index);
                        },
                        child: Container(
                          padding:  EdgeInsets.all(SizeConfig.blockSizeHorizontal * 0.75),
                          width: SizeConfig.blockSizeHorizontal * 10,
                          child: Center(
                              child: Icon(Icons.edit_outlined, color: colorPrimary,
                                  size: SizeConfig.blockSizeHorizontal*6.5)),
                        ),
                      ),


                    ],
                  ),

                  Visibility(
                    visible: index != controller.subCategoryList.length - 1,
                    child: Divider(color: Colors.grey[350],),
                  ),
                ],
              );

            })




      ),
      ));

    widgetList.add(child);
    final modal = Obx(
          () => controller.showLoader.value
          ? Stack(
        alignment: Alignment.center,
        children: [
          const Opacity(
            opacity: 0.6,
            child: ModalBarrier(dismissible: false, color: Colors.white),
          ),
          ColorLoader()
        ],
      )
          : const SizedBox(),
    );
    widgetList.add(modal);
    return Stack(children: widgetList);
  }

}