import 'dart:async';

import 'package:uni_links/uni_links.dart';
import 'package:voicetruth/state/app.dart';
import 'package:voicetruth/utils/logger.dart';

Future<void> initUniLinks()async{
  try{
    final initialUri = await getInitialUri();
    logger.i("Initial Uri: $initialUri");
    setUri(initialUri);
    linkStream.listen((event) {
      try{
        if(event!=null) {
          final linkUri = Uri.parse(event);
          logger.i("LinkStream Uri: $linkUri");
          setUri(linkUri);
        }
      }
      catch(e){

      }
    });
  }
  catch(e){

  }
}

void setUri(Uri? uri){
  if(uri!=null){
    app.setInitialUri(uri);
  }
}