import 'dart:io';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:mynotes/constants/languages.dart' as langs;
import 'dart:developer';

class UpdateProfileView extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final user;
  const UpdateProfileView({Key? key, this.user}) : super(key: key);

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  @override
  Widget build(BuildContext context) {
    late final TextEditingController _name =
        TextEditingController(text: widget.user?.email?.split('@')[0] ?? '');
    late final TextEditingController _email =
        TextEditingController(text: widget.user?.email ?? '');
    String _image = widget.user?.photoURL ??
        'https://twinfinite.net/wp-content/uploads/2022/05/Who-created-Anime.jpeg';

    void handleChangeAvatar() async {
      try {
        FilePickerResult? result =
            await FilePicker.platform.pickFiles(type: FileType.image);
        if (result != null) {
          File file = File(result.files.single.path ?? '');
          setState(() {
            _image = file.path;
            // Update image url
          });
        }
      } on PlatformException catch (e) {
        log(e.code);
      } catch (e) {
        log('Something went wrong...');
        log(e.toString());
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, langs.profileTitle)),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 150,
                height: 150,
                child: CircleAvatar(backgroundImage: NetworkImage(_image))),
            ElevatedButton(
                onPressed: () => handleChangeAvatar(),
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 215, 237, 227)),
                child: Text(
                  FlutterI18n.translate(
                      context, langs.profileChangeAvatarButton),
                  style: const TextStyle(color: Colors.green),
                )),
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: _name,
                style: const TextStyle(
                    color: Color.fromARGB(255, 63, 108, 53),
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
                decoration:
                    const InputDecoration(border: UnderlineInputBorder()),
              ),
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: _email,
                style: const TextStyle(
                    color: Color.fromARGB(255, 63, 108, 53),
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
                decoration:
                    const InputDecoration(border: UnderlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      FlutterI18n.translate(context, langs.profileUpdateButton),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
