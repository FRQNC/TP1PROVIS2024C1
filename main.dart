import 'dart:async';
import 'dart:io';

class Chat {
  String _msg = "";
  String _msgType = "";
  String _time = "";
  int _size = 0;
  bool _isAttachment = false;

  Chat(this._msg, this._msgType, this._time, this._size, this._isAttachment);

  void setMsg(String msg) {
    _msg = msg;
  }

  void setMsgType(String msgType) {
    _msgType = msgType;
  }

  void setTime(String time) {
    _time = time;
  }

  void setSize(int size) {
    _size = size;
  }

  void setIsAttachment(bool isAttachment) {
    _isAttachment = isAttachment;
  }

  String get msg => _msg;

  String get msgType => _msgType;

  String get time => _time;

  int get size => _size;

  bool get isAttachment => _isAttachment;
}

class Attachment extends Chat {
  String _fileName = "";
  int _fileSize = 0;

  Attachment(String msg, String msgType, String time, int size, bool isAttachment, String fileName, int fileSize)
      : super(msg, msgType, time, size, isAttachment) {
    _fileName = fileName;
    _fileSize = fileSize;
    if (_fileSize > this.size) {
      setSize(_fileSize);
    }
  }

  String get fileName => _fileName;

  int get fileSize => _fileSize;

  void setFileName(String fileName) {
    _fileName = fileName;
  }

  void setFileSize(int fileSize) {
    _fileSize = fileSize;
  }
}

class User {
  String? _name;
  String? _phoneNumber;

  User(name, phoneNumber) {
    _name = name;
    _phoneNumber = phoneNumber;
  }

  void setName(String name) {
    _name = name;
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
  }

  String? get name => _name;

  String? get phoneNumber => _phoneNumber;

  Future<void> sendChat(Chat c) {
    if (c.isAttachment) {
      return _sendAttachment(c as Attachment);
    } else {
      return Future.delayed(Duration(seconds : c.size),() {
        stdout.write("$_name($_phoneNumber) : ");
        print("${c.msg} (sent by sender at ${c.time})");
      });
    }
  }

  Future<void> _sendAttachment(Attachment attachment) {
    return Future.delayed(Duration(seconds: attachment.size), () {
      stdout.write("$_name($_phoneNumber) : ");
      stdout.write("[${attachment.fileName}]");
      if (attachment.msg.isNotEmpty) {
        stdout.write(" ");
      }
      print("${attachment.msg} (sent by sender at ${attachment.time})");
    });
  }
}

void main() async{
  User user1 = User("User 1", "0987654321");
  User user2 = User("User 2", "1234567890");
  await user1.sendChat(Chat("Hello", "text", "12:00:00", 1, false));
  await user2.sendChat(Chat("Hi", "text", "12:00:15", 1, false));
  await user1.sendChat(Chat("Take a look at this image of a cat", "text", "12:00:45", 1, false));
  user1.sendChat(Attachment("Here", "image", "12:00:50", 0, true, "CatPic.jpg",4));
  await user2.sendChat(Chat("Where", "text", "12:01:00", 1, false));
}