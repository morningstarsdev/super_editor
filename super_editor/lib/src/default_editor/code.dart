import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:super_editor/src/core/document.dart';
import 'package:super_editor/src/core/document_layout.dart';
import 'package:super_editor/src/core/edit_context.dart';
import 'package:super_editor/src/default_editor/document_interaction.dart';
import 'package:super_editor/src/default_editor/node_type.dart';
import 'package:super_editor/src/default_editor/text.dart';
import 'package:super_editor/src/infrastructure/_logging.dart';
import 'package:super_editor/src/infrastructure/attributed_text.dart';
import 'package:super_editor/src/infrastructure/composable_text.dart';
import 'package:super_editor/src/infrastructure/keyboard.dart';
import 'package:super_editor/src/infrastructure/raw_key_event_extensions.dart';
import 'package:super_editor/super_editor.dart';
import 'package:highlight/highlight.dart' as highlight;

import 'styles.dart';

final _log = Logger(scope: 'paragraph.dart');

class CodeNode extends TextNode {
  CodeNode({
    required String id,
    required AttributedText text,
    required this.language,
    Map<String, dynamic>? metadata,
  }) : super(
          id: id,
          text: text,
          metadata: metadata,
        );

  final nodeType = NodeType.code;

  final String language;

  factory CodeNode.fromJson(Map<String, dynamic> json) => CodeNode(
        id: json['id'] as String,
        text: AttributedText.fromJson(json['text']),
        language: json['language'] as String,
        metadata: json['metadata'] != null
            ? jsonDecode(json['metadata']) as Map<String, dynamic>
            : null,
      );

  @override
  Map<String, dynamic> toJson() => {
        'nodeType': nodeType.toString(),
        'id': id,
        'text': text.toJson(),
        'language': language,
        'metadata': jsonEncode(metadata),
      };
}

ExecutionInstruction enterToInsertNewCodeLine({
  required EditContext editContext,
  required RawKeyEvent keyEvent,
}) {
  if (keyEvent.logicalKey != LogicalKeyboardKey.enter &&
      keyEvent.logicalKey != LogicalKeyboardKey.numpadEnter) {
    return ExecutionInstruction.continueExecution;
  }

  final node = editContext.editor.document
      .getNodeById(editContext.composer.selection!.base.nodeId);

  print(node is CodeNode);
  if (node is! CodeNode ||
      !(editContext.composer.selection?.isCollapsed ?? true)) {
    return ExecutionInstruction.continueExecution;
  }

  final didInsertNewCodeLine = editContext.commonOps.insertPlainText('\n');

  return didInsertNewCodeLine
      ? ExecutionInstruction.haltExecution
      : ExecutionInstruction.continueExecution;
}
