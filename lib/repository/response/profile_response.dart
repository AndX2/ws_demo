import 'package:ws_demo/domain/profile.dart';
import 'package:ws_demo/util/transformable.dart';

class ProfileResponse extends Transformable<Profile> {
  String _name;
  String _id;

  ProfileResponse.fromJson(dynamic json) {
    _name = json['name'];
    _id = json['publicId'];
  }
  @override
  Profile transform() {
    return Profile(_id, _name);
  }
}

// {
//     "name": "AndX",
//     "publicId": "2fac7e44-7e62-4310-a544-4ad3cc9ba6c6",
//     "created": "2021-03-30T05:56:37.588772Z",
//     "updated": "2021-03-30T05:56:37.588780Z"
// }
