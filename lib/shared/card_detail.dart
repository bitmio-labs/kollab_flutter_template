import 'package:flutter/material.dart';

import 'blurred_image.dart';

class CardModel {
  String title;
  String date;
  PersonModel person;
  String description;
  Image background;

  CardModel(
      {this.title, this.date, this.person, this.description, this.background});
}

class PersonModel {
  String name;
  ImageProvider image;

  PersonModel({this.name, this.image});
}

class CardDetailWidget extends StatelessWidget {
  final CardModel model;
  final Function showAssignee;
  final List<Widget> widgets;

  CardDetailWidget({this.model, this.widgets, this.showAssignee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
        leading: new IconButton(
          icon: Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.all(Radius.circular(18))),
            child: new Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                  height: model.background != null ? 300 : 250,
                  color: Theme.of(context).primaryColor,
                  width: double.infinity,
                  child: model.background != null
                      ? BlurredImage(model.background)
                      : null),
              Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(model.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: Colors.white)),
                          SizedBox(height: 20),
                          Wrap(
                            spacing: 20,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              if (model.date != null)
                                Wrap(
                                    spacing: 5,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.calendar_today,
                                          color: Colors.white),
                                      Text(model.date,
                                          style: TextStyle(color: Colors.white))
                                    ]),
                              if (model.person != null)
                                InkWell(
                                    onTap: () {
                                      if (showAssignee != null) showAssignee();
                                    },
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 5,
                                      children: <Widget>[
                                        Container(
                                            width: 30,
                                            height: 30,
                                            child: AspectRatio(
                                              child: CircleAvatar(
                                                  backgroundImage:
                                                      model.person.image),
                                              aspectRatio: 1,
                                            )),
                                        Text(model.person.name,
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ))
                            ],
                          )
                        ],
                      )))
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            width: double.infinity,
            child: Text(model.description),
          ),
          if (widgets != null) Column(children: widgets)
        ]),
      ),
    );
  }
}
