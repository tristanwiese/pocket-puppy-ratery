import 'package:flutter/material.dart';

navReplace(context, path) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
    return path;
  }));
}

navPush(context, path) {
  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
    return path;
  }));
}

navPop(context) {
  Navigator.pop(context);
}

popUntil({context, required bool Function(Route<dynamic>) callback}) {
  Navigator.popUntil(context, (route) {
    return callback(route);
  });
}
