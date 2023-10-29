import 'package:circle/constant/constant_builder.dart';

ClipRRect skeletonBox(double width, double height){
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: SizedBox(
      width: width,
      height: height,
      child: const LinearProgressIndicator(
        color: Color.fromARGB(255, 204, 204, 204),
        backgroundColor: Color.fromARGB(255, 214, 214, 214),
      )
    )
  );
  
}
