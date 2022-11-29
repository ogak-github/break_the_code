import 'package:break_the_code/game_engine.dart';
import 'package:break_the_code/widgets/common_alertdialog.dart';
import 'package:break_the_code/widgets/common_card.dart';
import 'package:break_the_code/widgets/number_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => GameEngine()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Break The Code"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: GameBoard(),
          ),
        ],
      ),
    );
  }
}

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late int _currentLevel = GameEngine().level;
  late int _currentAdd = GameEngine().add;
  late int _currentMultiply = GameEngine().multiply;

  @override
  void initState() {
    GameEngine().generateNumber(_currentLevel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _currentLevel = context.watch<GameEngine>().level;
    _currentAdd = context.watch<GameEngine>().add;
    _currentMultiply = context.watch<GameEngine>().multiply;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Level: ($_currentLevel/5)',
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: CommonCard(title: '$_currentAdd = ... + ... + ...')),
            Expanded(
                child: CommonCard(
              title: '$_currentMultiply = ... x ... x ...',
            )),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //FormField(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FormField()
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class FormField extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> c1State = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> c2State = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> c3State = GlobalKey<FormFieldState>();
  final TextEditingController c1 = TextEditingController();
  final TextEditingController c2 = TextEditingController();
  final TextEditingController c3 = TextEditingController();
  FormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int level = context.watch<GameEngine>().level;
    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 30.0,
                  width: 60.0,
                  child: NumberFormField(
                      key: c1State,
                      controller: c1,
                      label: '',
                      textInputType: TextInputType.number),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                SizedBox(
                  height: 30.0,
                  width: 60.0,
                  child: NumberFormField(
                      key: c2State,
                      controller: c2,
                      label: '',
                      textInputType: TextInputType.number),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                SizedBox(
                  height: 30.0,
                  width: 60.0,
                  child: NumberFormField(
                      key: c3State,
                      controller: c3,
                      label: '',
                      textInputType: TextInputType.number),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            SubmitButton(
              formKey: formKey,
              c1Key: c1State,
              c2Key: c2State,
              c3Key: c3State,
              c1: c1,
              c2: c2,
              c3: c3,
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
                onPressed: () {
                  Provider.of<GameEngine>(context, listen: false)
                      .generateNumber(level);
                },
                child: const Text('Shuffle'))
          ],
        ),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final GlobalKey<FormFieldState> c1Key;
  final GlobalKey<FormFieldState> c2Key;
  final GlobalKey<FormFieldState> c3Key;
  final TextEditingController c1;
  final TextEditingController c2;
  final TextEditingController c3;
  const SubmitButton({
    Key? key,
    required this.formKey,
    required this.c1Key,
    required this.c2Key,
    required this.c3Key,
    required this.c1,
    required this.c2,
    required this.c3,
  }) : super(key: key);

  bool validateForm() {
    if (c1.text.isEmpty && c2.text.isEmpty && c2.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    int add = context.watch<GameEngine>().add.toInt();
    int multiply = context.watch<GameEngine>().multiply.toInt();
    return ElevatedButton(
        onPressed: () {
          print(GameEngine().isCorrect(int.parse(c1.text), int.parse(c2.text),
              int.parse(c3.text), add, multiply));

          if (GameEngine().isCorrect(int.parse(c1.text), int.parse(c2.text),
                  int.parse(c3.text), add, multiply) ==
              true) {
            showDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 275.0,
                    width: 450.0,
                    child: const CommonAlertDialog(
                      icon: Icon(
                        Icons.check_circle_outline_outlined,
                        size: 80,
                      ),
                      textName: 'Nice, Go to next level',
                    ),
                  ),
                );
              },
            );
            context.read<GameEngine>().levelUp();
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 275.0,
                    width: 450.0,
                    child: const CommonAlertDialog(
                      icon: Icon(
                        Icons.error_outline_outlined,
                        size: 80.0,
                      ),
                      textName: 'Please check again',
                    ),
                  ),
                );
              },
            );
            c1.text = "";
            c2.text = "";
            c3.text = "";
            print('Incorrect');
          }

          print('C1 value: ${c1.text}');
          print('C2 value: ${c2.text}');
          print('C3 value: ${c3.text}');
        },
        child: const Text('Check'));
  }
}
