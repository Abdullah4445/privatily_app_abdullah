// lib/modules/project_comments/project_comments_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/project_model.dart';
import '../../projects/projects_controller.dart';
import 'project_comments_logic.dart';
///This is bilal Project Comments View comment
class ProjectCommentsView extends StatelessWidget {
  ProjectCommentsView({super.key});

  //---------------------------------------------------------------------------
  // Controllers
  //---------------------------------------------------------------------------
  final ProjectController projectCtrl = Get.find<ProjectController>();
  final ProjectCommentsLogic commentCtrl = Get.put(ProjectCommentsLogic());

  //---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project Comments')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (projectCtrl.projects.isEmpty) {
            return const Center(child: Text('No projects found'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── project picker ─────────────────────────────────────────────
              DropdownButton<ProjectModel>(
                value: commentCtrl.selectedProject.value ??
                    projectCtrl.projects.first,
                isExpanded: true,
                items: projectCtrl.projects
                    .map((p) => DropdownMenuItem(
                  value: p,
                  child: Text(p.title ?? p.projectId ?? 'Unnamed'),
                ))
                    .toList(),
                onChanged: (p) => commentCtrl.changeProject(p!),
              ),
              const SizedBox(height: 20),

              // ── comment list ───────────────────────────────────────────────
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: commentCtrl.commentStream,
                  builder: (_, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snap.hasData || snap.data!.docs.isEmpty) {
                      return const Center(child: Text('No comments yet'));
                    }

                    final docs = snap.data!.docs;
                    return ListView.separated(
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const Divider(height: 0),
                      itemBuilder: (_, i) {
                        final data =
                            docs[i].data() as Map<String, dynamic>? ?? {};

                        return ListTile(
                          title: Text(data['username'] ?? 'Anonymous'),
                          subtitle: Text(data['comment'] ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (data['purchased'] == true)
                                const Icon(Icons.verified,
                                    color: Colors.green),
                              IconButton(
                                icon: const Icon(Icons.chat_bubble_outline),
                                tooltip: 'Open thread',
                                onPressed: () => _openThreadSheet(
                                  context,
                                  commentDocId: docs[i].id,
                                  commentData: data,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_forever,
                                    color: Colors.red),
                                tooltip: 'Delete comment',
                                onPressed: () async {
                                  final sure = await Get.dialog<bool>(
                                    AlertDialog(
                                      title: const Text('Delete comment?'),
                                      content: const Text(
                                          'This will remove the comment and all replies.'),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Get.back(result: false),
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () =>
                                                Get.back(result: true),
                                            child: const Text('Delete')),
                                      ],
                                    ),
                                  );
                                  if (sure == true) {
                                    await commentCtrl.deleteComment(
                                        docs[i].id);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const Divider(thickness: 1.5),
              const SizedBox(height: 8),

              // ── add-comment form ───────────────────────────────────────────
              _AddCommentForm(commentCtrl: commentCtrl),
            ],
          );
        }),
      ),
    );
  }

  //===========================================================================
  // Bottom-sheet threaded chat  (with sender switcher)
  //===========================================================================
  void _openThreadSheet(
      BuildContext ctx, {
        required String commentDocId,
        required Map<String, dynamic> commentData,
      }) {
    final ProjectCommentsLogic ctrl = Get.find<ProjectCommentsLogic>();
    final txtCtrl = TextEditingController();

    // initial sender list
    final List<String> senders = [
      'LaunchCode.shop',
      commentData['username'] ?? 'Anonymous',
      'Custom…'
    ];
    String currentSender = senders.first; // default

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => SafeArea(
          child: Padding(
            padding: MediaQuery.of(ctx).viewInsets,
            child: SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.75,
              child: Column(
                children: [
                  // ── header ────────────────────────────────────────────────
                  ListTile(
                    leading: const Icon(Icons.comment),
                    title: Text(commentData['username'] ?? 'Anonymous'),
                    subtitle: Text(commentData['comment'] ?? ''),
                  ),
                  const Divider(),

                  // ── thread messages ───────────────────────────────────────
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: ctrl.threadStream(commentDocId),
                      builder: (_, snap) {
                        if (!snap.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final msgs = snap.data!.docs;
                        if (msgs.isEmpty) {
                          return const Center(child: Text('No replies yet'));
                        }
                        return ListView.builder(
                          reverse: true,
                          itemCount: msgs.length,
                          itemBuilder: (_, i) {
                            final m =
                                msgs[i].data() as Map<String, dynamic>? ?? {};
                            final fromLaunchCode =
                                m['sender'] == 'LaunchCode.shop';

                            return Align(
                              alignment: fromLaunchCode
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: fromLaunchCode
                                      ? Colors.blue.shade100
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      m['sender'] ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(m['text'] ?? ''),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // ── sender switch + input row ─────────────────────────────
                  const Divider(),
                  Row(
                    children: [
                      // sender dropdown
                      DropdownButton<String>(
                        value: currentSender,
                        items: senders
                            .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s, style: const TextStyle(fontSize: 12)),
                        ))
                            .toList(),
                        onChanged: (val) async {
                          if (val == null) return;
                          if (val == 'Custom…') {
                            final alias = await _askCustomAlias(ctx);
                            if (alias != null && alias.trim().isNotEmpty) {
                              // insert before 'Custom…'
                              senders.insert(senders.length - 1, alias.trim());
                              setModalState(() {
                                currentSender = alias.trim();
                              });
                            }
                          } else {
                            setModalState(() => currentSender = val);
                          }
                        },
                      ),
                      const SizedBox(width: 4),

                      // text field
                      Expanded(
                        child: TextField(
                          controller: txtCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Message…',
                            border: OutlineInputBorder(),
                          ),
                          minLines: 1,
                          maxLines: 4,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          final txt = txtCtrl.text.trim();
                          if (txt.isEmpty) return;
                          await ctrl.addThreadMessage(
                            commentDocId: commentDocId,
                            sender: currentSender,
                            text: txt,
                          );
                          txtCtrl.clear();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ask once for a custom alias
  Future<String?> _askCustomAlias(BuildContext context) async {
    final TextEditingController aliasCtrl = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Custom sender'),
        content: TextField(
          controller: aliasCtrl,
          decoration:
          const InputDecoration(hintText: 'Enter any name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, aliasCtrl.text.trim()),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

//---------------------------------------------------------------------------
// ADD-COMMENT FORM
//---------------------------------------------------------------------------
class _AddCommentForm extends StatefulWidget {
  const _AddCommentForm({required this.commentCtrl});
  final ProjectCommentsLogic commentCtrl;

  @override
  State<_AddCommentForm> createState() => _AddCommentFormState();
}

class _AddCommentFormState extends State<_AddCommentForm> {
  final formKey = GlobalKey<FormState>();
  final userCtrl = TextEditingController();
  final commentCtrlField = TextEditingController();
  bool purchased = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // username
          TextFormField(
            controller: userCtrl,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 8),

          // comment
          TextFormField(
            controller: commentCtrlField,
            decoration: const InputDecoration(
              labelText: 'Comment',
              border: OutlineInputBorder(),
            ),
            minLines: 2,
            maxLines: 4,
            validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 8),

          // purchased switch
          SwitchListTile(
            title: const Text('Purchased this project?'),
            value: purchased,
            onChanged: (v) => setState(() => purchased = v),
          ),
          const SizedBox(height: 8),

          // submit
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text('Add Comment'),
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                final ok = await widget.commentCtrl.addComment(
                  username: userCtrl.text.trim(),
                  comment: commentCtrlField.text.trim(),
                  purchased: purchased,
                );
                if (ok) {
                  userCtrl.clear();
                  commentCtrlField.clear();
                  setState(() => purchased = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Comment added ✔')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
