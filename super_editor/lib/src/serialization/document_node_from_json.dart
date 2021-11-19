import 'package:super_editor/src/core/document.dart';
import 'package:super_editor/src/default_editor/embedded_image.dart';
import 'package:super_editor/src/serialization/node_type.dart';
import 'package:super_editor/super_editor.dart';

DocumentNode documentNodeFromJson(Map<String, dynamic> json) {
  switch (getNodeTypeFromString(json['nodeType'])) {
    case NodeType.image:
      return ImageNode.fromJson(json);
    case NodeType.embeddedImage:
      return EmbeddedImageNode.fromJson(json);
    case NodeType.paragraph:
      return ParagraphNode.fromJson(json);
    case NodeType.horizontalRule:
      return HorizontalRuleNode.fromJson(json);
    case NodeType.listItem:
      return ListItemNode.fromJson(json);
    default:
      throw UnimplementedError();
  }
}
