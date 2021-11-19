enum NodeType {
  image,
  horizontalRule,
  embeddedImage,
  blockquoute,
  paragraph,
  text,
  listItem,
  unknown,
}

NodeType getNodeTypeFromString(String nodeTypeString) {
  for (NodeType type in NodeType.values) {
    if (type.toString() == nodeTypeString) {
      return type;
    }
  }
  return NodeType.unknown;
}
