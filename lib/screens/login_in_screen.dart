import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class registration_form extends StatefulWidget {
  @override
  registration_form_state createState() => registration_form_state();
}

class registration_form_state extends State<registration_form> {
  String err_on_grp_name = null;
  String err_on_usr_name = null;
  String err_on_pwd = null;
  String err_on_confirm_pwd = null;
  final _formKey = GlobalKey<FormState>();

  TextEditingController group_controller = TextEditingController();
  TextEditingController user_contoller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController confirm_pwd_controller = TextEditingController();

  bool on_submit_usr = false;
  bool on_submit_pwd = false;
  bool on_submit_confirm_pwd = false;
  bool isbuttondisabled = false;

  String user_name;

  String password;

  bool user_name_verifier() {
    if (user_contoller.text.isEmpty && on_submit_usr) {
      setState(() {
        on_submit_usr = false;
        err_on_usr_name = "username can't be empty";
      });
      return false;
    }
    if (user_contoller.text.contains(' ') ||
        user_contoller.text.contains('\t')) {
      setState(() {
        on_submit_usr = false;
        err_on_usr_name = "whitespaces not allowed in username";
      });
      return false;
    }
    setState(() {
      on_submit_usr = false;
      err_on_usr_name = null;
    });
    return true;
  }

  bool password_verifier() {
    if ('${password_controller.text}'.isEmpty && on_submit_pwd) {
      setState(() {
        on_submit_pwd = false;
        err_on_pwd = "Password can't be empty";
      });
      return false;
    }
    setState(() {
      on_submit_pwd = false;
      err_on_pwd = null;
    });
    return true;
  }

  bool confirm_password() {
    if (password_controller.text == '' || password_controller.text == null) {
      setState(() {
        on_submit_confirm_pwd = false;
        err_on_confirm_pwd = null;
      });
      return false;
    } else {
      if ((password_controller.text != confirm_pwd_controller.text) &&
          on_submit_confirm_pwd) {
        setState(() {
          on_submit_confirm_pwd = false;
          err_on_confirm_pwd = "Those Passwords didn't match";
        });
        return false;
      }
    }
    setState(() {
      on_submit_confirm_pwd = false;
      err_on_confirm_pwd = null;
    });
    return true;
  }

  void initState() {
    super.initState();
    password_controller.addListener(password_verifier);
    user_contoller.addListener(user_name_verifier);
    confirm_pwd_controller.addListener(confirm_password);
  }

  Widget create_form(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("I was tapped...");
        setState(() {});
      },
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(25, 40, 20, 0),
                child: TextFormField(
                  controller: user_contoller,
                  onSaved: (String value) {
                    user_name = "$value".trim();
                  },
                  decoration: InputDecoration(
                    labelText: "Enter username",
                    hintText: " whitespace not allowed",
                    helperStyle:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.w100),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(),
                    ),
                    errorText: err_on_usr_name,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(25, 40, 20, 0),
                child: TextFormField(
                  controller: password_controller,
                  obscureText: true,
                  onSaved: (String value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    labelText: "Enter Password",
                    hintText: " whitespace not allowed",
                    helperStyle:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.w100),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(),
                    ),
                    errorText: err_on_pwd,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(25, 40, 20, 0),
                child: TextFormField(
                  controller: confirm_pwd_controller,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(),
                    ),
                    errorText: err_on_confirm_pwd,
                  ),
                ),
              ),
              ChangeNotifierProvider(
                    builder: (context) => Poll(),
                    child: Padding(
                    padding: EdgeInsets.fromLTRB(25, 30, 30, 20),
                    child: Align(
                      child: RaisedButton(
                        disabledColor: Colors.grey,
                        child: Text("Next",
                            style: TextStyle(fontSize: 18, color: Colors.white)),
                        color: Colors.lightBlue,
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        onPressed: isbuttondisabled
                            ? null
                            : () {
                                setState(() {
                                  isbuttondisabled = true;
                                });
                                on_submit_grp = true;
                                bool res1 = group_name_verifier();
                                on_submit_usr = true;
                                bool res2 = user_name_verifier();
                                on_submit_pwd = true;
                                bool res3 = password_verifier();
                                on_submit_confirm_pwd = true;
                                bool res4 = confirm_password();
                                if (res1 && res2 && res3 && res4) {
                                  print("Everything verified");

                                  _formKey.currentState.save();
                                   var temp = "${group_name}".replaceAll(' ', '-');
                                  Future<Response> group_exists = client.get(
                                      '${server_url}/api/polls/exists/${temp}');
                                  // Future<Response> asf = client
                                  //     .get();
                                  group_exists.timeout(const Duration(seconds: 5),
                                      onTimeout: () {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          'Couldn\'t connect to server, Please try again!'),
                                    ));
                                    print("Time out");
                                    setState(() {
                                      isbuttondisabled = false;
                                    });
                                  });

                                  group_exists.then((value) {
                                    print(value);
                                    Map<String, dynamic> body =
                                        jsonDecode(value.body);
                                    if (body['exists'] == true) {
                                      setState(() {
                                        err_on_grp_name =
                                            "poll name not available! try another name";
                                        isbuttondisabled = false;
                                      });
                                    } else {
                                      print('poll name available...');
                                      var poll_future = create_group(client);
                                      poll_future.then((value) {
                                        Map<String, dynamic> poll_info =
                                            jsonDecode(value.body);
                                        var user_future = create_user(
                                            client,
                                            poll_info['poll_id'],
                                            user_name,
                                            password);
                                        user_future.then((value) {
                                          print("user created...");
                                          Map<String, dynamic> user_info =
                                              jsonDecode(value.body);
                                          var make_admin_future = make_admin(
                                              client,
                                              poll_info['poll_id'],
                                              user_info['user_id'],
                                              poll_info['secret_token']);
                                          make_admin_future.then((value) {
                                            Map<String, dynamic> admin_result =
                                                jsonDecode(value.body);
                                            print(admin_result['msg']);
                                            var login_future = login_user(
                                                client,
                                                user_name,
                                                password,
                                                poll_info["poll_id"]);
                                            login_future.then((value) {
                                              Map<String, dynamic> login_info =
                                                  jsonDecode(value.body);
                                                  
                                                  var prefs = SharedPreferences.getInstance();
                                                  prefs.then((value) {
                                                    value.setString('letspole', login_info['token']);
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  'logged_in_screen',
                                                  (Route route) => false,
                                                  arguments: login_info['token'],
                                                  );
                                                  }
                                                  );
                                            });
                                          });
                                        });
                                      });
                                    }
                                  });
                                } else
                                  setState(() {
                                    isbuttondisabled = false;
                                  });
                              },
                      ),
                      alignment: Alignment(0.9, 0),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }