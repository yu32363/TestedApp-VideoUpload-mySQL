import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import 'const.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File _image;
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  VideoPlayerController _videoPlayerController;

  Future choiceVideo() async {
    var pickedImage = await picker.getVideo(source: ImageSource.camera);

    _image = File(pickedImage.path);

    _videoPlayerController = VideoPlayerController.file(_image)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
  }

  Future uploadVideo() async {
    final uri =
        Uri.parse("http://192.168.1.36/image_upload_php_mysql/upload.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = nameController.text;
    var pic = await http.MultipartFile.fromPath("image", _image.path);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Video Uploaded');
    } else {
      print('Video Not Uploaded');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBGColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text(
          'Video Uploader',
          style: kAppBarText,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: kSecondColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'รหัส: N0002',
                        ),
                        Text(
                          'ผู้ถูกตรวจ: สมชาย รักดี',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircleAvatar(
                      backgroundColor: kMainColor,
                      child: Icon(Icons.person),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  'Video Uploader',
                  style: kMenuText,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 80,
                  width: 80,
                  child: Icon(
                    Icons.cloud_upload,
                    size: 70,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      color: kSecondColor,
                      height: 200,
                      width: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_image != null)
                            _videoPlayerController.value.initialized
                                ? AspectRatio(
                                    aspectRatio: _videoPlayerController
                                        .value.aspectRatio,
                                    child: VideoPlayer(_videoPlayerController),
                                  )
                                : Container()
                          else
                            Text(
                              '',
                            ),
                        ],
                      ),
                    ),
                    Container(
                      height: 200,
                      width: 200,
                      child: IconButton(
                        icon: Icon(
                          Icons.video_call,
                          size: 50,
                        ),
                        onPressed: () {
                          choiceVideo();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 150,
                      child: TextField(
                        decoration: InputDecoration(hintText: 'ระบุการตรวจ'),
                        textAlign: TextAlign.center,
                        controller: nameController,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  color: kMainColor,
                  onPressed: () {
                    uploadVideo();
                  },
                  child: Text(
                    'บันทึก',
                    style: kAppBarText,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
