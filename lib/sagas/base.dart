import 'package:redux/redux.dart';
import '../actions/base.dart';
import '../models/provider.dart';

getOfflineObjects(Provider provider, Store store, Action populateObjects(dynamic)) async {
  try {
    await provider.open();
    dynamic newobjects = await provider.getTasks();
    if(newobjects == null) {
      return;
    }
    store.dispatch(populateObjects(newobjects));
  } catch(e) {
    print(e);
  }
}

syncObject(Provider provider, dynamic object) async {
  try {
    await provider.sync(object);
  } catch(e) {
    print(e);
  }
}
