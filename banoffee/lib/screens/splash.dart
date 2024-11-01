import 'package:flutter/material.dart';
import 'menu.dart'; 


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MenuScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 16, 16, 16),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://cdn-icons-png.flaticon.com/256/10609/10609073.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 30), 
              Text(
                'MOVIE VIEW FINDER',
                style: TextStyle(
                  color: Colors.grey[50], 
                  fontSize: 28.0, 
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class SplashScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => MenuScreen()),
//       );
//     });

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 16, 16, 16), 
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.network(
//               'https://cdn-icons-png.flaticon.com/256/10609/10609073.png',
//               width: 100, 
//               height: 100, 
//             ),
//             const SizedBox(height: 30),
//             Text(
//               'MOVIE VIEW FINDER',
//               style: TextStyle(
//                 color: Colors.grey[50], 
//                 fontSize: 28.0, 
//                 fontWeight: FontWeight.w300, 
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }