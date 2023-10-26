
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/food_model.dart';
import 'package:food_delivery_app/resourese/auth_methods.dart';
import 'package:food_delivery_app/resourese/databaseSQL.dart';
import 'package:food_delivery_app/resourese/firebase_helper.dart';

class FoodDetailPageBloc with ChangeNotifier {
  AuthMethods mAuthMethods = AuthMethods();
  FirebaseHelper mFirebaseHelper = FirebaseHelper();

  List<FoodModel> foodList = [];


  var random = new Random();
  String rating = "1.00";


  int mItemCount = 1;

  BuildContext? context;

  addToCart(FoodModel food) async {
    DatabaseSql databaseSql = DatabaseSql();
    await databaseSql.openDatabaseSql();
    await databaseSql.insertData(food);
    await databaseSql.getData();
    final snackBar = SnackBar(
      content: Text('Food Added To Cart'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {

        },
      ),
    );
    mItemCount = 1;
    if (context != null) {
      ScaffoldMessenger.of(context!).showSnackBar(snackBar);
    }
    notifyListeners();
  }

  getPopularFoodList() {

    mFirebaseHelper.fetchSpecifiedFoods("06").then((List<FoodModel> list) {
      foodList = list;
      notifyListeners();
    });
  }

  void increamentItems() {
    mItemCount++;
    notifyListeners();
  }

  void decreamentItems() {
    mItemCount--;
    notifyListeners();
  }

  void generateRandomRating() {
    rating = doubleInRange(random, 3.5, 5.0).toStringAsFixed(1);
  }

  double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;
}
