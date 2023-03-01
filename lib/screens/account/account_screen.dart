import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:n_baz/services/local_notification_service.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  void logout() async {
    _ui.loadState(true);
    try {
      await _auth.logout().then((value) {
        Navigator.of(context).pushReplacementNamed('/login');
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(50),
          elevation: 20,
        ));
      });
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        elevation: 20,
      ));
    }
    _ui.loadState(false);
  }

  late GlobalUIViewModel _ui;
  late AuthViewModel _auth;
  @override
  void initState() {
    _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
    _auth = Provider.of<AuthViewModel>(context, listen: false);
    super.initState();
  }

  double rating = 0;
  createRating() {
    return SizedBox(
      child: RatingBar.builder(
        initialRating: rating,
        minRating: 1,
        itemSize: 35,
        itemPadding: EdgeInsets.symmetric(horizontal: 1),
        itemBuilder: (context, _) => Icon(
          CupertinoIcons.heart_fill,
          color: Colors.redAccent,
        ),
        updateOnDrag: true,
        onRatingUpdate: (rating) => setState(() {
          this.rating = rating;
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Your Profile"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              icon: const Icon(Icons.sell),
              tooltip: 'Open shopping cart',
              onPressed: () {
                Navigator.of(context).pushNamed("/my-products");
              })
        ],
      ),
      body: Container(
        color: Color(0xFFD6D6D6),
        child: ListView(
          children: [colorTiles(), logoutButton()],
        ),
      ),
    );
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.all(0.5),
      child: Divider(
        thickness: 1.5,
      ),
    );
  }

  Widget colorTiles() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 50),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            ListTile(
              leading: Container(
                child: Icon(Icons.person_outline, color: Colors.deepPurple),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              title: Text("Personal Data",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              trailing:
                  Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
              onTap: () {
                Navigator.of(context).pushNamed("/your_profile");
              },
            ),
            divider(),
            ListTile(
              leading: Container(
                child: Icon(Icons.email_outlined, color: Colors.blue),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              title: Text("Change your email",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              trailing:
                  Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
              onTap: () {
                Navigator.of(context).pushNamed("/change_email");
              },
            ),
            divider(),
            ListTile(
              leading: Container(
                child: Icon(Icons.password_outlined, color: Colors.pink),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              title: Text("Change your password",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              trailing:
                  Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
              onTap: () {
                Navigator.of(context).pushNamed("/change_password");
              },
            ),
            divider(),
            ListTile(
              leading: Container(
                child: Icon(Icons.info_outline, color: Colors.black),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              title:
                  Text("FAQ's", style: TextStyle(fontWeight: FontWeight.w700)),
              trailing:
                  Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
              onTap: () {
                Navigator.of(context).pushNamed("/faqs");
              },
            ),
            divider(),
            ListTile(
              leading: Container(
                child: Icon(Icons.rate_review, color: Colors.black),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              title: Text("Rate Our App",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              trailing:
                  Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
              onTap: () {
                Navigator.push(context, showPopUpRatingDialog(context));
              },
            ),
          ],
        ),
      ),
    );
  }

  showPopUpRatingDialog(BuildContext context) => showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: Text("Your opinion matters to us!"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  // padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                        "If you enjoy using our app, would you mind rating?",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center),
                  ),
                ),
                createRating(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.push(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (rating == 0) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    Navigator.push(context, showPopUpThankYouDialog(context));
                    setState(() {
                      rating = 0;
                    });
                  }
                },
                child: Text(
                  "OK",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ));

  showPopUpThankYouDialog(BuildContext context) => showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            title: Text("Thank You!"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  // height: 100,
                  // width: 50,
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  // padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text("For rating our app",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center),
                  ),
                ),
                Positioned(
                    top: -100,
                    child: Image.asset('assets/images/thankyou.png',
                        width: 150, height: 150))
                // createRating(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ));

  Widget logoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            logout();
            // Add your code for logging out here
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: const Text(
            "Log out",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
