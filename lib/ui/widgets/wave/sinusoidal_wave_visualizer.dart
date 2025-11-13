import 'package:flutter/material.dart';
// import 'package:flutter_sinusoidals/flutter_sinusoidals.dart';
import 'package:voicetruth/data/constants/app_colors.dart';
import 'package:voicetruth/ui/app_navigation.dart';

// class SinusoidalWaveVisualizer extends StatelessWidget {
//   const SinusoidalWaveVisualizer({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     double amplitude = 10;
//     final margin = size.h1 * 0;
//     return SizedBox(
//       height: size.h1 * 100,
//       child: Stack(children: [
//         Positioned(
//           left: 0, right: 0,
//           bottom: size.h1 * 50, top: margin,
//           child: CombinedWave(
//             reverse: false,
//             models: [
//               SinusoidalModel(
//                 // formular: WaveFormular.travelling
//                 amplitude: amplitude,
//                 waves: 20,
//                 translate: 2.5,
//                 frequency: 0.5,
//               ),
//               SinusoidalModel(
//                 // formular: WaveFormular.travelling
//                 amplitude: amplitude,
//                 waves: 15,
//                 translate: 7.5,
//                 frequency: 1.5,
//               ),
//             ],
//             child: Container(
//               decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                       stops: [0,1000],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         AppColors.purpleBlue,
//                         AppColors.purpleBlue,
//                       ]
//                   )
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           left: 0, right: 0,
//           top: size.h1 * 50, bottom: margin,
//           child: CombinedWave(
//             reverse: true,
//             models: [
//               SinusoidalModel(
//                 // formular: WaveFormular.travelling
//                 amplitude: amplitude,
//                 waves: 20,
//                 translate: 2.5,
//                 frequency: 0.5,
//               ),
//               SinusoidalModel(
//                 // formular: WaveFormular.travelling
//                 amplitude: amplitude,
//                 waves: 15,
//                 translate: 7.5,
//                 frequency: 1.5,
//               ),
//             ],
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   stops: [0,0.5],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     AppColors.purpleBlue,
//                     AppColors.indigoBlue
//                   ]
//                 )
//               ),
//             ),
//           ),
//         )
//       ],),
//     );
//   }
// }
