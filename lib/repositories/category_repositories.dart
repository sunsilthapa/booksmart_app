import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/category_model.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class CategoryRepository {
  CollectionReference<CategoryModel> categoryRef =
      FirebaseService.db.collection("categories").withConverter<CategoryModel>(
            fromFirestore: (snapshot, _) {
              return CategoryModel.fromFirebaseSnapshot(snapshot);
            },
            toFirestore: (model, _) => model.toJson(),
          );
  Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      if (!hasData) {
        makeCategory().forEach((element) async {
          await categoryRef.add(element);
        });
      }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>> getCategory(String categoryId) async {
    try {
      print(categoryId);
      final response = await categoryRef.doc(categoryId).get();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  List<CategoryModel> makeCategory() {
    return [
      CategoryModel(
          categoryName: "Romantic",
          status: "active",
          imageUrl:
              "https://imgs.search.brave.com/m2-N4t3mrI8UTO2my7ANemfZaPv_Dzifj2sm1-sFids/rs:fit:625:225:1/g:ce/aHR0cHM6Ly90c2Uz/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5r/eGdKRFItOWVOQ0ln/djZlX016VElBSGFG/biZwaWQ9QXBp"),
      CategoryModel(
          categoryName: "Mystery",
          status: "active",
          imageUrl:
              "https://imgs.search.brave.com/n5x356R46zs1m2cfm0kVjsN9VAZSAHxaOIV1nuESQbU/rs:fit:727:474:1/g:ce/aHR0cDovLzIuYnAu/YmxvZ3Nwb3QuY29t/L19NM0tjRERwVVVm/by9TOEJBeTk1WUwy/SS9BQUFBQUFBQUFi/OC9oUFdKYlo1NE10/ay9zMTYwMC9NeXN0/ZXJ5TE9HTy5qcGc"),
      CategoryModel(
          categoryName: "Fiction ",
          status: "active",
          imageUrl:
              "https://imgs.search.brave.com/VLc4XsEIyN05Rp8ZtYewq9Mqfs3iO6BnI3BhqTfUpU8/rs:fit:870:225:1/g:ce/aHR0cHM6Ly90c2Uz/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5M/cVUzNHh2OWJWVjgx/dDNJTWg5LUZnSGFF/QyZwaWQ9QXBp"),
      CategoryModel(
          categoryName: "Memoir",
          status: "active",
          imageUrl:
              "https://imgs.search.brave.com/5_mwXmT4QmTuD49e2aCC0SmOT1vbR_bItuqzTV9RDoA/rs:fit:678:225:1/g:ce/aHR0cHM6Ly90c2U0/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC4y/MVNIcmFmMkpDY210/aDlfS28xRVFRSGFG/TCZwaWQ9QXBp"),
      CategoryModel(
          categoryName: "Culture",
          status: "active",
          imageUrl:
              "https://imgs.search.brave.com/ncYgEMfGyE6wqfHK4avOY1hLg0E9ODrTGtgym-C2-Zk/rs:fit:632:225:1/g:ce/aHR0cHM6Ly90c2Uy/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5Y/dVVId1R0OWtubDhL/UEw2Y19obnlBSGFG/aiZwaWQ9QXBp"),
    ];
  }
}
