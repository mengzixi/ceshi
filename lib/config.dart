import 'package:flutter/material.dart';

class Config {
  //copy your api key from php admin dashboard & paste below
  static final String baseUrl = "https://meetce.hacksafe.cc/";

  static final String apiKey = "seanydvkx5ahg9wiosyl2npq";

  static final bool enableFacebookAuth = false;
  static final bool enableGoogleAuth = false;
  static final bool enablePhoneAuth = false;
  static final bool enableAppleAuthForIOS = false;
  static final String defaultLanguage = "zh";

  //supported language list
  static var supportedLanguageList = [
    Locale("en", "US"),
    Locale("ar", "SA"),
    Locale("zh", "CN"),
    Locale("bn", "BD")
  ]; //supported language list
}

/// the welcome screen data
List introContent = [
  {
    "title": "Welcome To",
    "image": "assets/images/introImage/intro_slide_one.png",
    "desc": "Start or join a video meeting on the go"
  },
  {
    "title": "Message Your Team",
    "image": "assets/images/introImage/intro_slide_one.png",
    "desc": "Send text, voice message and share file"
  },
  {
    "title": "Get MeetAiring",
    "image": "assets/images/introImage/intro_slide_one.png",
    "desc": "Work anywhere, with anyone, one any device"
  }
];
List introContentZh = [
  {
    "title": "欢迎",
    "image": "assets/images/introImage/intro_slide_one.png",
    "desc": "随时随地加入视频会议"
  },
  {
    "title": "团队",
    "image": "assets/images/introImage/intro_slide_one.png",
    "desc": "发送文本、语音信息和共享文件"
  },
  {
    "title": "会议",
    "image": "assets/images/introImage/intro_slide_one.png",
    "desc": "随时随地与任何人、任何设备一起工作"
  }
];
List introContentBn = [
  {
    "title": "স্বাগতম",
    "image": "assets/images/introImage/intro_slide_one.png",
    "desc": "যেতে যেতে ভিডিও মিটিং শুরু করুন বা যোগ দিন"
  },
  {
    "title": "আপনার টিম বার্তা",
    "image": "assets/images/introImage/intro_slide_one.png",
    "desc": "পাঠ্য, ভয়েস বার্তা পাঠান এবং ফাইল শেয়ার করুন"
  },
  {
    "title": "মিট এয়ারিং পান",
    "image": "assets/images/introImage/intro_slide_one.png",
    "desc": "যেকোন জায়গায়, যে কারো সাথে, যেকোন ডিভাইসে কাজ করুন"
  }
];
List introContentAr = [
  {
    "title": "مرحبا بك في",
    "image": "assets/images/introImage/intro_slide_one.png",
    "desc": "ابدأ أو انضم إلى اجتماع فيديو أثناء التنقل"
  },
  {
    "title": "أرسل رسالة إلى فريقك",
    "image": "assets/images/introImage/intro_slide_one.png",
    "desc": "إرسال رسالة نصية وصوتية ومشاركة الملف"
  },
  {
    "title": "احصل على يجتمع بث",
    "image": "assets/images/introImage/intro_slide_one.png",
    "desc": "العمل في أي مكان ، مع أي شخص ، مع جهاز واحد وأي جهاز"
  }
];
