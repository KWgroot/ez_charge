import 'package:ez_charge/app/design/btn.dart';
import 'package:ez_charge/app/design/design.dart';
import 'package:ez_charge/app/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class body extends StatefulWidget{
  @override
  _body createState() => _body();

}

class _body extends State<body> {
  int currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      "text": "Maak een account aan",
      "image": "assets/images/registreren.png"
    },
    {
      "text": "Klik op 'Start session' en scan de QR code",
      "image": "assets/images/hoofdscherm.png"
    },
    {
      "text": "Start de sessie",
      "image": "assets/images/startsessie.png"
    },
    {
      "text": "Bekijk facturen",
      "image": "assets/images/facturen.png"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 5,
                child: PageView.builder(
                    onPageChanged: (value){
                      setState(() {
                        currentPage = value;
                      });
                    },
                    itemCount: onboardingData.length,
                    itemBuilder: (context, index) => OnboardingContent(
                      image: onboardingData[index]["image"],
                      text: onboardingData[index]["text"],
                ))
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Spacer(flex: 1,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center ,
                      children: List.generate(onboardingData.length, (index) => buildDot(index: index)),
                    ),
                    Spacer(flex: 7,),
                    Button(onPressed: () {Navigator.of(context).pop();}, text: 'Registreer nu', color: theme.buttonColor , tStyle: theme.textTheme.bodyText1),
                    Spacer(flex: 4,)
                  ],
                ),
              ),

            )
          ],
        ),
      )
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: ANIMATION_DURATION,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 12 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? SELECTED_DOT : UNSELECTED_DOT,
        borderRadius:  BorderRadius.circular(3)
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    Key key,
    this.text,
    this.image,
  }) : super(key: key);

  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(
          flex: 3,
        ),
        Text(
          "EzCharge",
          style: TextStyle(
              fontSize: 50.0,
              fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily
          )
        ),
        Spacer(
          flex: 6,
        ),
        Text(
          text,
          style: TextStyle(
              color: Colors.black45,
              fontFamily: GoogleFonts.sairaSemiCondensed().fontFamily
          ),
          textAlign: TextAlign.center,
        ),
        Spacer(
          flex: 1,
        ),
        Image.asset(
          image,
          width: 180,
        )
      ],
    );
  }
}
