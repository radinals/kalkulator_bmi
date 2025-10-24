import 'package:flutter/material.dart';

void main() {
  runApp(const KalkulatorBMIApp());
}

class KalkulatorBMIApp extends StatelessWidget {
  const KalkulatorBMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "KALKULATOR BMI",
      debugShowCheckedModeBanner: false,
      home: KalkulatorBMIScreen(),
    );

  }
}

class KalkulatorBMIScreen extends StatefulWidget {
  const KalkulatorBMIScreen({super.key});

  @override
  State<KalkulatorBMIScreen> createState() => _KalkulatorBMIScreenState();
}

class _KalkulatorBMIScreenState extends State<KalkulatorBMIScreen> {

  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  double? _bmiResult = null;

  void _hitungBMI(){
    final double weight = double.tryParse(_weightController.text) ?? 0;
    final double heightInCM = double.tryParse(_heightController.text) ?? 0;


    setState(() {
      if(weight > 0 && heightInCM > 0 ){
        final double  heightInM = heightInCM/100;
        final double bmi = weight/(heightInM*heightInM);
        _bmiResult = bmi;

      }else{
        _bmiResult=null;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kalkulator BMI", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: _weightController,
              decoration: InputDecoration(
                labelText: "Berat Badan (Kg)",
                icon: Icon(Icons.monitor_weight),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

              ),
            ),
            SizedBox(height: 20,),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: _heightController,
              decoration: InputDecoration(
                labelText: "Tinggi Badan (cm)",
                icon: Icon(Icons.height),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              ElevatedButton(onPressed: _hitungBMI, style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.blue),
              ),
                child: Text("Hitung", style: TextStyle(color: Colors.white),),
              ),
              SizedBox(width: 100),
              ElevatedButton(onPressed: () {
                setState(() {
                  _weightController.clear();
                  _heightController.clear();
                  _bmiResult = null;
                });
              }, style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.yellow), ),
                  child: Text("Reset")),

            ]),
            SizedBox(height: 40),
            BMIResultDisplay(_bmiResult),
          ],
        ),
      ),
    );
  }
}

class BMIResultDisplay extends StatelessWidget {
  String _bmiInterpretation = "";
  final double? _bmiResult;
  Color _bmiColor = Colors.green;


  BMIResultDisplay(this._bmiResult) {
    if (_bmiResult == null) return;
    if(_bmiResult! < 18.5){
      this._bmiInterpretation = "Kekurangan Berat Badan";
      this._bmiColor = Colors.red;
    }else if(_bmiResult! < 25){
      this._bmiInterpretation = "Berat Badan Ideal";
      this._bmiColor = Colors.green;
    }else if(_bmiResult! < 30){
      this._bmiInterpretation = "Kelebihan Berat Badan";
      this._bmiColor = Colors.red;
    }else{
      this._bmiInterpretation = "Obesitas";
      this._bmiColor = Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return (this._bmiResult != null) ? SizedBox(
      width: 300,
      child: Container(
        decoration: BoxDecoration(color: _bmiColor, borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.all(10),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text( "HASIL", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 28)),
          Text(
            _bmiResult?.toStringAsFixed(2) ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 24, fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 8,),
          Text(
            _bmiInterpretation,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold,),
          ),
        ],
      ),
      )
    ): Text("Silahkan masukkan data Anda!", style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic), textAlign: TextAlign.center);

  }

}