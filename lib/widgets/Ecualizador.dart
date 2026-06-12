import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';

class Ecualizador extends StatefulWidget{
  const Ecualizador({super.key});

  @override
  State<Ecualizador> createState() => _EqualizerWidgetState();
}

class _EqualizerWidgetState extends State<Ecualizador> {



  final List<double> _heights = List.filled(3,4);
  Timer? _timer;
  final Random _random = Random();

  @override
  void initState(){
    super.initState();
    _startAnimation();
  }


  void _startAnimation(){

    _timer = Timer.periodic(Duration(milliseconds: 300),(timer) {
      setState(() {
        for(int i =0; i<_heights.length;i++){
          _heights[i] =_random.nextInt(45).toDouble();
        }
      });
    });
  }

  @override
 void dispose(){
  _timer?.cancel();
  super.dispose();
 }

 @override
  Widget build(BuildContext context) {
      final musicProvider = context.watch<MusicProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end, // Alinea las barras abajo
      children: List.generate(_heights.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150), // Duración de la transición
            curve: Curves.easeInOut, // Curva de animación suave
            width: 12,
            height:musicProvider.isPlaying ? _heights[index] : 0,
            decoration: BoxDecoration(
              color: Colors.purpleAccent,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        );
      }),
    );
  }
}