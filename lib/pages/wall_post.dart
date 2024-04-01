// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewall/components/comment.dart';
import 'package:thewall/components/comment_button.dart';
import 'package:thewall/components/like_button.dart';
import 'package:thewall/helper/helper_methods.dart';

class wallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final String time;
  final List<String> likes;
  const wallPost(
      {super.key,
      required this.message,
      required this.user,
      required this.postId,
      required this.likes,
      required this.time

      });

  @override
  State<wallPost> createState() => _wallPostState();
}

class _wallPostState extends State<wallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  //comment text controller
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String commentText) {
    // write the comment o firestore under the comments collection for this post
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentBy": currentUser.email,
      "CommentTime": Timestamp.now()
    });
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(
            hintText: "Write a comment..",
          ),
        ),
        actions: [
          //post button
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              _commentTextController.clear();
            },
            child: Text("Cancel"),
          ),

          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);

              Navigator.pop(context);

              _commentTextController.clear();
            },
            child: Text("Post"),
          ),

          //cancel button
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color:  Theme.of(context).colorScheme.primary,
           borderRadius: BorderRadius.circular(8)
        ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //wallpost
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.message),
              const SizedBox(height: 5),

              // user
              Row(
            children: [
              Text(
                widget.user,
                style: TextStyle( 
                  color: Colors.grey[400]
                ),
                ),
              Text(
                " . ",
               style: TextStyle( 
                  color: Colors.grey[400]
                ),
              ),
              Text(
                widget.time,
                 style: TextStyle( 
                  color: Colors.grey[400]
                ),
              )
          ],
         ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),

          //buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  //like button
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //like count

                  Text(widget.likes.length.toString())
                ],
              ),
              const SizedBox(
                width: 10,
              ),

              //comment button
              Column(
                children: [
                  CommentButon(onTap: showCommentDialog),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '0',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          // comment display

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  // Get the comment data
                  final commentData = doc.data() as Map<String, dynamic>;

                  // Return the comment
                  return Comment(
                    text: commentData["CommentText"],
                    user: commentData["CommentBy"],
                    time: formatDate(commentData["CommentTime"]),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
