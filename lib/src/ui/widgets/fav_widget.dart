import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../data/tvshow_details.dart';
import '../../models/fav_model.dart';
import '../../utils/styles.dart';
import '../../utils/unicons_icons.dart';
import 'image_widget.dart';
import 'modal_sheet_widget.dart';
import 'random_button_widget.dart';

class FavWidget extends StatelessWidget {
  const FavWidget({Key key, @required this.tvshowDetails}) : super(key: key);
  final TvshowDetails tvshowDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(borderRadius: BORDER_RADIUS),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            right: 8.0,
            left: 8.0,
            top: 8.0,
            bottom: 24.0,
            child: _image(context),
          ),
          Align(
            alignment: Alignment.topRight,
            child: _deleteButton(context),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: RandomButtonWidget(tvshowDetails: tvshowDetails),
          ),
        ],
      ),
    );
  }

  Widget _image(BuildContext context) {
    return GestureDetector(
        onTap: () => _showModalSheet(context),
        child: ImageWidget(
            name: tvshowDetails.name,
            url: tvshowDetails.posterPath,
            isModal: false));
  }

  Widget _deleteButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _deleteConfirm(context).then((bool result) {
        if (result) {
          ScopedModel.of<FavModel>(context).deleteFav(tvshowDetails.rowId);
          ScopedModel.of<FavModel>(context).getFavs();
        }
      }),
      child: Container(
        height: 20.0,
        width: 20.0,
        decoration: BoxDecoration(
          color: StyleColor.WHITE,
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          border: Border.all(),
        ),
        child: Icon(
          Unicons.close,
          size: 12.0,
          color: StyleColor.PRIMARY,
        ),
      ),
    );
  }

  Future<bool> _deleteConfirm(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          title:
              Text(FlutterI18n.translate(context, 'app.delete_dialog.title')),
          content: Text(
              FlutterI18n.translate(context, 'app.delete_dialog.subtitle')),
          actions: <Widget>[
            FlatButton(
              textColor: StyleColor.PRIMARY,
              color: StyleColor.WHITE,
              child: Text(FlutterI18n.translate(
                  context, 'app.delete_dialog.button_cancel')),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(color: StyleColor.PRIMARY)),
                textColor: StyleColor.PRIMARY,
                color: StyleColor.WHITE,
                child: Text(FlutterI18n.translate(
                    context, 'app.delete_dialog.button_delete')),
                onPressed: () {
                  Navigator.of(context).pop(true);
                })
          ],
        );
      },
    );
  }

  void _showModalSheet(BuildContext context) {
    showModalBottomSheet<Column>(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        elevation: 0.0,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadiusDirectional.vertical(top: Radius.circular(16.0)),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 424,
              child: MenuPanelWidget(
                tvshowDetails: tvshowDetails,
                inDatabase: true,
              ));
        });
  }
}
