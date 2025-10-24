import 'package:flutter/material.dart';

enum Gender {Perempuan,Lelaki}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kalkulator BMI", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: DefaultTabController(
          length: 2,
          child: Column(children: [
            TabBar(
              tabs: [
                Tab(text: "Perempuan"),
                Tab(text: "Laki-Laki"),
              ],
            ),
            Expanded(child: TabBarView(children: [
              BMIFormWidget(Gender.Perempuan),
              BMIFormWidget(Gender.Lelaki)
            ])
            )
          ])
      ),
    );
  }
}

class BMIResultDisplay extends StatelessWidget {
  String _bmiInterpretation = "";
  final double? _bmiResult;
  Color _bmiColor = Colors.green;
  Gender? _gender = null;


  BMIResultDisplay(this._bmiResult, this._gender) {
    if(_bmiResult == null || this._gender == null) return;
    switch (_gender) {
      case Gender.Lelaki:
        if (_bmiResult! < 20.0) {
          _bmiInterpretation = 'Kurus';
          _bmiColor = Colors.yellow;
        } else if (_bmiResult! >= 20.0 && _bmiResult! <= 25.0) {
          _bmiInterpretation = 'Normal';
          _bmiColor = Colors.green;
        } else if (_bmiResult! > 25.0 && _bmiResult! <= 30.0) {
          _bmiInterpretation = 'Gemuk';
          _bmiColor = Colors.orange;
        } else {
          _bmiInterpretation = 'Obesitas';
          _bmiColor = Colors.red;
        }
      case Gender.Perempuan:
        if (_bmiResult! < 18.0) {
          _bmiInterpretation = 'Kurus';
          _bmiColor = Colors.yellow;
        } else if (_bmiResult! >= 18.0 && _bmiResult! <= 23.0) {
          _bmiInterpretation = 'Normal';
          _bmiColor = Colors.green;
        } else if (_bmiResult! > 23.0 && _bmiResult! <= 27.0) {
          _bmiInterpretation = 'Gemuk';
          _bmiColor = Colors.orange;
        } else {
          _bmiInterpretation = 'Obesitas';
          _bmiColor = Colors.red;
        }
      default:
        throw UnimplementedError("unknown gender " + _gender.toString());
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

class BMIFormWidget extends StatefulWidget {
  final Gender _gender;
  BMIFormWidget(this._gender);
  @override
  State<StatefulWidget> createState() => BMIFormWidgetState(this._gender);
}

class BMIFormWidgetState extends State<BMIFormWidget> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  double? _bmiResult = null;
  final Gender _gender;

  BMIFormWidgetState(this._gender);

  void _hitungBMI() {
    final double weight = double.tryParse(_weightController.text) ?? 0;
    final double heightInCM = double.tryParse(_heightController.text) ?? 0;


    setState(() {
      if (weight > 0 && heightInCM > 0) {
        final double heightInM = heightInCM / 100;
        final double bmi = weight / (heightInM * heightInM);
        _bmiResult = bmi;
      } else {
        _bmiResult = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          BMIResultDisplay(_bmiResult, this._gender),
        ],
      ),
    );
  }
}
