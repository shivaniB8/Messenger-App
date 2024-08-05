const String kAppName = "Bharat Messenger";
const bool _isDemo = true;
const String kDefaultAvatarUrl =
    "https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png";
const String kDefaultGroupAvatarUrl =
    'https://he.cecollaboratory.com/public/layouts/images/unit-default-logo.png';
const String kUsersCollectionId = "${_isDemo ? "demo_" : ""}users";

/// Sub collection unders users `i.e users/{userId}/chats`
const String kUsersBharatIDsCollectionName = "bharat_ids";
const String kChatsSubCollectionId = "${_isDemo ? "demo_" : ""}chats";
const String kMessagesSubCollectionId = "messages";
const String kStatusCollectionId = "status";
const String kGroupsCollectionId = "groups";
const String kPhoneNumberField = "phoneNumber";
const String kIsOnlineField = "isOnline";
const String kCallsCollection = "calls";
const double kDefaultSplashRadius = 18.0;
const kChatRoomBackgroundDarkPath = "assets/img/chat_room_bg_dark.png";
const kChatRoomBackgroundLightPath = "assets/img/chat_room_bg_light.jpg";
