import 'package:super_editor/src/default_editor/list_items.dart';

ListItemType getListItemTypeFromString(String listItemTypeString) {
  for (ListItemType type in ListItemType.values) {
    if (type.toString() == listItemTypeString) {
      return type;
    }
  }
  return ListItemType.unordered;
}
