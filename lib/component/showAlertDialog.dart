

/*class ShowAlertDialog {
  void showAppDialog(
      {final title,
      final message,
      final onCancel,
      final onConfirm,
      final cancelColor,
      final image,
      final confirmColor,
      final isCancel,
      final confirmText = 'OK',
      final cancelText = 'Cancel',
      final subtitle,
      final isSubtitle = false}) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titlePadding: EdgeInsets.all(10),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.clear,
                    color: colorTextPrimary,
                    size: SizeConfig.blockSizeHorizontal * 6,
                  ),
                )),
            SvgPicture.asset(
              image,
              width: SizeConfig.blockSizeHorizontal * 20,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              maxLines: 2,
              style:const TextStyle(
                fontSize: 20,
                color: colorBlack,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              message,
              maxLines: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: colorBlack,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0,
              ),
            ),
            isSubtitle
                ? const SizedBox(
                    height: 10,
                  )
                : const SizedBox(),
            isSubtitle ? subtitle : Container(),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
                bottom: 10,
                left: 8,
                right: 8),
            width: 350,
            child: Column(
              // Row()
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isCancel
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(350.0, 30.0),
                          onPrimary: colorWhite,
                          primary: colorPrimary,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: onCancel,
                        child: Text(
                          cancelText,
                          maxLines: 4,
                        ),
                      )

                    : const SizedBox(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(350, 30),
                    onPrimary: colorWhite,
                    primary: colorPrimary,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: onConfirm,
                  child: Text(
                    confirmText,
                    maxLines: 4,
                  ),
                )

              ],
            ),
          )
        ],
      ),
      barrierDismissible: false,
    );
  }


}*/
