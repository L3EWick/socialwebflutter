import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewall/components/comment_button.dart';
import 'package:thewall/components/like_button.dart';

class wallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  const wallPost(
      {super.key,
      required this.message,
      required this.user,
      required this.postId,
      required this.likes});

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
            onPressed: () => addComment(_commentTextController.text),
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
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user, style: TextStyle(color: Colors.grey[500])),
              const SizedBox(height: 10),
              Text(widget.message)
            ],
          ),
          const SizedBox(
            width: 20,
          ),

          //buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  // comment button

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

              const SizedBox(width: 10,),

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
        ],
      ),
    );
  }
}
