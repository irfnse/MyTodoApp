import 'auth.dart';
import 'package:flutter/material.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  // validasi form sebelum save
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // melakukan login atau signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        // melakukan cek login form atau signup form
        if (_isLoginForm) {
          // melakukan login
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          // melakukan sign up
          userId = await widget.auth.signUp(_email, _password);
          // menampilkan email verifiksi email
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        // menangkap error
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    // melakukan reset from
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          // menampilkan title TodoApp Login
          title: new Text('TodoApp Login'),
        ),
        body: Stack(
          children: <Widget>[
            // menampilkan from
            _showForm(),
            // menampilkan progres
            _showCircularProgress(),
          ],
        ));
  }

  // widget progres
  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  // menampilkan verifikasi email
  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
          new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                toggleFormMode();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // widget from
  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  // error message
  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  // menambahkan logo
  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        // mengatur padding
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          // mengatur background color
          backgroundColor: Colors.transparent,
          // membuat radius agar bulat
          radius: 48.0,
          // mengunakan image
          child: Image.asset('assets/clipboard.png'),
        ),
      ),
    );
  }

  // membuat email input
  Widget showEmailInput() {
    return Padding(
      // membuat padding dengan Edge inset
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      // mengguanakn Text Form Field
      child: new TextFormField(
        maxLines: 1,
        // membuat type validasi hanya tipe email
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        // membuat dekorasi dengan hint text, icon dan color
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        // menambahkan validasi jika value kosong
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        // jika save value akan ditrim whiteepace
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  bool _secureText = true;
  // menambahkan untuk melihat password
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  // menambahkan input password
  Widget showPasswordInput() {
    return Padding(
      // mengatur padding
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: _secureText,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            // menambahkan icon button untuk menampilkan password
            suffixIcon: IconButton(
              onPressed: showHide,
              icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility),
            ),
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        // menambahkan validasi agar tidak kosong
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  // menambahkan button untuk sign in atau sign up
  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
          // ketika _isLoginForm akan muncul create an account, selain itu
          // have an account? Sign in
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }
  // membuat tombol login atau sign up
  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text(_isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }
}
