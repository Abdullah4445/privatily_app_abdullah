// lib/widgets/comments_section.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsSection extends StatelessWidget {
  const CommentsSection({super.key, required this.projectId});
  final String projectId;

  static const _left  = Color(0xFFE0E0E0); // customer
  static const _right = Color(0xFFBBDEFB); // LaunchCode.shop

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('project_comments')
          .where('projectId', isEqualTo: projectId)
          // .orderBy('createdAt')
          .snapshots(),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return const Text('No comments yet');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text('Comments',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Divider(),
            ...snap.data!.docs.map((doc) {
              final c = doc.data()! as Map<String, dynamic>;
              return _CommentBox(
                docId: doc.id,
                username: c['username'] ?? 'Anonymous',
                comment: c['comment'] ?? '',
                purchased: c['purchased'] == true,
              );
            }),
          ],
        );
      },
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Root comment + expandable thread
// ────────────────────────────────────────────────────────────────────────────
class _CommentBox extends StatefulWidget {
  const _CommentBox({
    required this.docId,
    required this.username,
    required this.comment,
    required this.purchased,
  });

  final String docId;
  final String username;
  final String comment;
  final bool purchased;

  @override
  State<_CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<_CommentBox>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final threadRef = FirebaseFirestore.instance
        .collection('project_comments')
        .doc(widget.docId)
        .collection('thread');
        // .orderBy('sentAt');

    return StreamBuilder<QuerySnapshot>(
      stream: threadRef.snapshots(),
      builder: (_, snap) {
        final replyCount = snap.data?.docs.length ?? 0;

        return GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 250),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── root comment ───────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      child: Text(widget.username.isNotEmpty
                          ? widget.username[0].toUpperCase()
                          : '?'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: CommentsSection._left,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.username,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(widget.comment),
                            if (widget.purchased)
                              const Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Icon(Icons.verified,
                                    size: 14, color: Colors.green),
                              ),
                          ],
                        ),
                      ),
                    ),
                    // badge / chevron
                    if (replyCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 6, top: 4),
                        child: Row(
                          children: [
                            Text('$replyCount',
                                style: const TextStyle(fontSize: 12)),
                            Icon(
                              _expanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                  ],
                ),

                // ── thread messages (collapsible) ─────────────────────────
                if (_expanded && replyCount > 0)
                  const SizedBox(height: 8),
                if (_expanded)
                  ...snap.data!.docs.map((d) {
                    final m = d.data()! as Map<String, dynamic>;
                    final fromLC = m['sender'] == 'LaunchCode.shop';
                    return Align(
                      alignment: fromLC
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(8),
                        constraints:
                        const BoxConstraints(maxWidth: 350),
                        decoration: BoxDecoration(
                          color: fromLC
                              ? CommentsSection._right
                              : CommentsSection._left,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m['sender'] ?? '',
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(m['text'] ?? ''),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                if (_expanded) const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
