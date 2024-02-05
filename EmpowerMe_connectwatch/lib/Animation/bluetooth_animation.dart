


import 'package:flutter/material.dart';


class PulsatingCircleAnimation extends StatelessWidget{
  const PulsatingCircleAnimation({super.key});

  @override
   Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        
      title:const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        SizedBox(width: 8),
        Text('Samerwatch Connected'),
        
        
        
        ],
        
      ),
      backgroundColor: Colors.blue,
      actions: [
        IconButton(
          icon: const Icon(Icons.watch, color: Colors.white,),onPressed: () { },
        )
      ],
      
    ),
      

    
      body: Center(
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 200),
          duration: const Duration(milliseconds: 1500),
          
          builder: (context, size, widget){
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    spreadRadius: size/2,
                  )
                
                ]
              ),
              child: Image.asset("assets/Blutooth.png"),
            );
          }
        ),
      ),
      
      
      
     );
     
   }
 }
  





