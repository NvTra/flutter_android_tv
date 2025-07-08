import 'package:flutter/material.dart';
import "package:collection/collection.dart";

class FocusListener {
  static final List<FocusListener> _listeners = <FocusListener>[];

  static void focusChanged(FocusGroup group, int row, int column) {
    for (var listener in _listeners) {
      listener.onFocusChanged(group, row, column);
    }
  }

  static void add(FocusListener listener) => _listeners.add(listener);
  static void remove(FocusListener listener) => _listeners.remove(listener);

  @protected
  void onFocusChanged(FocusGroup group, int row, int column) {}
}

enum FocusGroup {
  root,
  sidebar,
  listRow,
}

class RecentFocusNode extends FocusNode implements Comparable<RecentFocusNode> {
  final FocusGroup group;
  static RecentFocusNode? root;

  int visited = -1;
  int row = -1, column = -1;

  RecentFocusNode({required this.group}) {
    if (group == FocusGroup.root) root = this;
  }

  @override
  int compareTo(RecentFocusNode other) {
    return (row - other.row) * 1000 + (column - other.column);
  }
}

class RecentFocusTraversalPolicy extends FocusTraversalPolicy {
  static int visited = 0;
  static RecentFocusNode? latest;

  final FocusGroup group;

  const RecentFocusTraversalPolicy({required this.group});

  static void setFocus(FocusNode node, bool update) {
    if (node is RecentFocusNode) {
      if (update) node.visited = visited++;

      node.requestFocus();

      Scrollable.ensureVisible(
        node.context!,
        alignment: 0.5,
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
        duration: const Duration(milliseconds: 250),
      );

      latest = node;
      FocusListener.focusChanged(node.group, node.row, node.column);
    }
  }

  static void moveToSidebar() {
    var nodes = RecentFocusNode.root?.descendants
        .where((n) => n is RecentFocusNode && n.group == FocusGroup.sidebar)
        .toList(growable: false);

    if (nodes != null) {
      nodes.sort(_orderByRecentVisit);
      setFocus(nodes.first, false);
    }
  }

  static void moveToListRow() {
    var nodes = RecentFocusNode.root?.descendants
        .where((n) => n is RecentFocusNode && n.group == FocusGroup.listRow)
        .toList(growable: false);

    if (nodes != null) {
      nodes.sort(_orderByRecentVisit);
      setFocus(nodes.first, false);
    }
  }

  @override
  FocusNode findFirstFocusInDirection(
      FocusNode currentNode, TraversalDirection direction) {
    return FocusNode();
  }

  // @override
  // FocusNode findFirstFocus(FocusNode currentNode) {
  //   return FocusNode();
  // }

  bool handleGroupNavigation(
    FocusNode currentNode,
    TraversalDirection direction,
    Iterable<FocusNode> nodes,
  ) {
    if (group == FocusGroup.sidebar) {
      switch (direction) {
        case TraversalDirection.left:
          break;
        case TraversalDirection.right:
          moveToListRow();
          break;
        case TraversalDirection.up:
          if (nodes.first != currentNode) {
            moveFocus(currentNode, direction);
          }
          break;
        case TraversalDirection.down:
          if (nodes.last != currentNode) {
            moveFocus(currentNode, direction);
          }
          break;
      }
    } else {
      // horizontal
      switch (direction) {
        case TraversalDirection.left:
          if (nodes.first == currentNode) {
            moveToSidebar();
          } else {
            moveFocus(currentNode, direction);
          }
          break;

        case TraversalDirection.right:
          if (nodes.last != currentNode) {
            moveFocus(currentNode, direction);
          }
          break;
        case TraversalDirection.up:
          _moveToNextListRow(currentNode, -1);
          break;
        case TraversalDirection.down:
          _moveToNextListRow(currentNode, 1);
          break;
      }
    }

    return true;
  }

  static int _orderByRecentVisit(Object a, Object b) {
    if (a is RecentFocusNode && b is RecentFocusNode) {
      return b.visited - a.visited;
    } else {
      return 0;
    }
  }

  void _moveToNextListRow(FocusNode node, int diff) {
    if (node is RecentFocusNode) {
      var nodes = RecentFocusNode.root?.descendants
          .where((n) => n is RecentFocusNode && n.group == FocusGroup.listRow)
          .cast<RecentFocusNode>()
          .toList(growable: false);

      if (nodes != null) {
        var max = nodes.sorted().last.row;

        var nextRow = node.row + diff;
        nextRow = nextRow > max
            ? max
            : nextRow < 0
                ? 0
                : nextRow;

        var next = nodes
            .where((n) => n.row == nextRow)
            .sorted(_orderByRecentVisit)
            .first;

        setFocus(next, true);
      }
    }
  }

  void moveFocus(FocusNode node, TraversalDirection direction) {
    var candidates = node.parent?.traversalDescendants
        .where((element) => element != node)
        .toList();

    if (candidates != null) {
      _moveFocus(node, direction, candidates);
    }
  }

  int _orderByVertical(FocusNode a, FocusNode b) {
    return (a.rect.top - b.rect.top).toInt();
  }

  int _descendingOrderByVertical(FocusNode a, FocusNode b) {
    return (b.rect.top - a.rect.top).toInt();
  }

  int _orderByHorizontal(FocusNode a, FocusNode b) {
    return (a.rect.left - b.rect.left).toInt();
  }

  int _descendingOrderByHorizontal(FocusNode a, FocusNode b) {
    return (b.rect.left - a.rect.left).toInt();
  }

  FocusNode _selectNode(FocusNode node, TraversalDirection direction,
      List<FocusNode> candidates) {
    switch (direction) {
      case TraversalDirection.up:
        candidates = candidates
            .where((n) => n.rect.bottom < node.rect.top)
            .sorted(_descendingOrderByVertical)
            .toList();
        break;
      case TraversalDirection.down:
        candidates = candidates
            .where((n) => n.rect.top > node.rect.bottom)
            .sorted(_orderByVertical)
            .toList();
        break;
      case TraversalDirection.left:
        candidates = candidates
            .where((n) => n.rect.right < node.rect.left)
            .sorted(_descendingOrderByHorizontal)
            .toList();
        break;
      case TraversalDirection.right:
        candidates = candidates
            .where((n) => n.rect.left > node.rect.right)
            .sorted(_orderByHorizontal)
            .toList();
        break;
    }

    return candidates.isEmpty ? node : candidates.first;
  }

  FocusNode _moveFocus(FocusNode node, TraversalDirection direction,
      List<FocusNode> candidates) {
    final next = _selectNode(node, direction, candidates);
    if (next == node) return node;

    setFocus(next as RecentFocusNode, true);
    return next;
  }

  @override
  bool inDirection(FocusNode currentNode, TraversalDirection direction) {
    final parent = currentNode.parent;
    if (parent != null) {
      var nodes = sortDescendants(parent.children, currentNode);
      handleGroupNavigation(currentNode, direction, nodes);
    }

    return false;
  }

  @override
  Iterable<FocusNode> sortDescendants(
      Iterable<FocusNode> descendants, FocusNode currentNode) {
    int Function(FocusNode, FocusNode) compare;

    if (currentNode is RecentFocusNode &&
        currentNode.group == FocusGroup.sidebar) {
      compare = (a, b) => (a.offset.dy - b.offset.dy).toInt();
    } else {
      compare = (a, b) => (a.offset.dx - b.offset.dx).toInt();
    }

    return descendants.toList()..sort(compare);
  }
}
