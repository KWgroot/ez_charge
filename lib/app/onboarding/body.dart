import 'package:ez_charge/app/global_variables.dart';
import 'package:flutter/material.dart';

class body extends StatefulWidget{
  @override
  _body createState() => _body();

}

class _body extends State<body> {
  int currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      "text": "Maak een account aan",
      "image": "assets/images/registreren.jpg"
    },
    {
      "text": "Klik op 'Start session' en scan de QR code",
      "image": "assets/images/hoofdscherm.jpg"
    },
    {
      "text": "Start de sessie",
      "image": "assets/images/startsessie.jpg"
    },
    {
      "text": "Bekijk facturen",
      "image": "assets/images/aanmelden.jpg"
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
              child: Column(
                children: <Widget>[
                  Row(
                    children: List.generate(onboardingData.length, (index) => buildDot(index: index)),
                  )
                ],
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
      width: currentPage == index ? 20 : 6,
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
          flex: 4,
        ),
        Text(
          "EzCharge",
          style: TextStyle(
              fontSize: 50.0
          )
        ),
        Spacer(
          flex: 5,
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.black45
          ),
          textAlign: TextAlign.center,
        ),
        Spacer(
          flex: 5,
        ),
        Image.asset(
          image,
          width: 180,
        )
      ],
    );
  }
}
