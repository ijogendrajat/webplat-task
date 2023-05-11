import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:pune_task/model/dummyDataFile.dart';

class TreeFromJson extends StatefulWidget {
  const TreeFromJson({super.key});

  @override
  _TreeFromJsonState createState() => _TreeFromJsonState();
}

class _TreeFromJsonState extends State<TreeFromJson> {
  final TreeController _treeController =
      TreeController(allNodesExpanded: false);

  @override
  Widget build(BuildContext context) {
    return buildTree();
  }

  /// Builds tree or error message out of the entered content.
  Widget buildTree() {
    try {
      var parsedJson = json.decode(dummyDataJson);
      return TreeView(
        iconSize: 30,
        nodes: toTreeNodes(parsedJson),
        treeController: _treeController,
      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }

  List<TreeNode> toTreeNodes(dynamic parsedJson) {
    if (parsedJson is Map<String, dynamic>) {
      return parsedJson.keys
          .map((k) => TreeNode(
              content: Container(
                  color: Colors.amber,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('$k:'),
                  )),
              children: toTreeNodes(parsedJson[k])))
          .toList();
    }
    if (parsedJson is List<dynamic>) {
      return parsedJson
          .asMap()
          .map((i, element) => MapEntry(
              i,
              TreeNode(
                  content: Container(
                      color: correctColor(
                          (parsedJson[i]["PackageAmount"] ?? 0).toInt(),
                          (parsedJson[i]["TotalAchievedIncome"] ?? 0).toInt(),
                          (parsedJson[i]["TotalExpectedIncome"] ?? 0).toInt()),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(parsedJson[i]["Name"].toString()),
                      )),
                  children: toTreeNodes(element))))
          .values
          .toList();
    }
    return [TreeNode(content: Text(parsedJson.toString()))];
  }
}

// condition for color of box
correctColor(
    int PackageAmount, int TotalAchievedIncome, int TotalExpectedIncome) {
  if (PackageAmount > 0 && TotalAchievedIncome < TotalExpectedIncome) {
    return Colors.green;
  } else if (PackageAmount > 0 && TotalAchievedIncome > TotalExpectedIncome) {
    return Colors.pink;
  } else {
    return Colors.red;
  }
}
