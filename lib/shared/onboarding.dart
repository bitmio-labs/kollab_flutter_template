import 'package:flutter/material.dart';
import 'dart:ui';

import 'blurred_image.dart';

class OnboardingPageModel {
  String title;
  String description;
  Image backgroundImage;
  Image logo;
  Widget widget;

  OnboardingPageModel(
      {this.title,
      this.description,
      this.backgroundImage,
      this.logo,
      this.widget});
}

class Onboarding extends StatefulWidget {
  final PageController controller = PageController();

  final List<OnboardingPageModel> model;
  final String startLabel;
  final String continueLabel;
  final String skipLabel;
  final Function completionHandler;
  final String completionRoute;

  Onboarding(
      {this.model,
      this.startLabel = "Get Started",
      this.continueLabel = "Continue",
      this.skipLabel = "Skip",
      this.completionHandler,
      this.completionRoute = '/'});

  @override
  State<StatefulWidget> createState() {
    return _OnboardingState();
  }
}

class _OnboardingState extends State<Onboarding> {
  int currentPageValue = 0;

  bool get isLastPage => widget.model.length == currentPageValue + 1;

  @override
  Widget build(BuildContext context) {
    final pageView = PageView.builder(
      physics: ClampingScrollPhysics(),
      itemCount: widget.model.length,
      onPageChanged: (int page) {
        getChangedPageAndMoveBar(page);
      },
      controller: widget.controller,
      itemBuilder: (context, index) {
        return OnboardingPage(model: widget.model[index]);
      },
    );

    final circleNav = Stack(
      alignment: AlignmentDirectional.topStart,
      children: <Widget>[
        Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < widget.model.length; i++)
                if (i == currentPageValue) ...[circleBar(true)] else
                  circleBar(false),
            ],
          ),
        ),
      ],
    );

    final skipButton = FlatButton(
        onPressed: () => skip(context),
        child: Text(widget.skipLabel,
            style: Theme.of(context).textTheme.button.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                )));

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        pageView,
        Container(
          height: 150,
          margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: Column(
            children: <Widget>[
              SizedBox(height: 15, child: circleNav),
              SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () => nextPage(context),
                    child: Text(
                        isLastPage ? widget.startLabel : widget.continueLabel),
                  )),
              SizedBox(height: 10),
              isLastPage ? Opacity(opacity: 0, child: skipButton) : skipButton
            ],
          ),
        )
      ],
    );
  }

  skip(BuildContext context) {
    if (widget.completionHandler != null) {
      widget.completionHandler();
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
        context, widget.completionRoute, (route) => false);
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  nextPage(BuildContext context) {
    if (isLastPage) {
      skip(context);
    }

    widget.controller.nextPage(
      duration: Duration(milliseconds: 350),
      curve: Curves.easeIn,
    );
  }

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }
}

class OnboardingPage extends StatelessWidget {
  final OnboardingPageModel model;

  OnboardingPage({this.model});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            image: DecorationImage(
                image: model.backgroundImage.image, fit: BoxFit.cover),
          ),
          //child: model.backgroundImage,
        ),
        //BlurredImage(model.backgroundImage),
        if (model.logo != null)
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              alignment: Alignment.bottomCenter,
              color: Colors.white,
              padding: EdgeInsets.all(7),
              height: 110,
              width: 80,
              child: model.logo,
            )
          ]),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Stack(children: <Widget>[
            Positioned(
              top: 80,
              left: 20,
              right: 20,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 200,
                alignment: Alignment.center,
                child: model.widget,
              ),
            ),
            Positioned(
              bottom: 180,
              left: 0,
              right: 0,
              child: BlurredBox(
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(model.title,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.white)),
                      SizedBox(height: 10),
                      Text(model.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: Colors.white))
                    ]),
              )),
            )
          ]),
        )
      ],
    );
  }
}
