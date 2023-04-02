import 'dart:ui';

import 'package:flutter/material.dart';

Future<void> showCoreDialog(context,
    {required Widget child,
    
    required String title}) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    context: context,
    pageBuilder: (_, __, ___) {
      return CoreDialog(
        title: title,
       
        child: child,
      );
    },
  );
}

class CoreDialog extends StatefulWidget {
  final Widget child;
  final String title;
  
  const CoreDialog(
      {super.key, required this.child, required this.title,});

  @override
  State<CoreDialog> createState() => _CommonDialogState();
}

class _CommonDialogState extends State<CoreDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  void closeDialog() {
    _controller.reverse().then((value) => Navigator.pop(context));
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        milliseconds: 500,
      ),
      vsync: this,
    );

    _animation = CurveTween(curve: Curves.easeInToLinear).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x2e4cbcfc),
                          offset: Offset(0, 6),
                          blurRadius: 22,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Stack(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    widget.title,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () {
                                    closeDialog();
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: widget.child,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // widget.onPressed != null ? Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: SizedBox(
            //     height: 50,
            //     width: double.infinity,
            //     child: ElevatedButton(
            //       onPressed: () async {
            //         await widget.onPressed!.call();
            //         closeDialog();
            //       },
            //       style: ButtonStyle(
            //         // backgroundColor:
            //         //     MaterialStateProperty.all(Colors.red),
            //         shape: MaterialStateProperty.all(RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(20),
            //         )),
            //       ),
            //       child: const Text("Submit"),
            //     ),
            //   ),
            // ) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
