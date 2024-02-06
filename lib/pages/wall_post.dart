import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewall/components/like_button.dart';

class wallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  const wallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes

 
  });

  @override
  State<wallPost> createState() => _wallPostState();
}

class _wallPostState extends State<wallPost> {

  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState(){
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike(){
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef = 
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
        });
      }else {
        postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
        });
      
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          Column(
            children: [

              //like button
              LikeButton(
                isLiked: isLiked, 
                onTap: toggleLike,
              ),
              //like count

              const SizedBox(height: 5,),
              Text(widget.likes.length.toString())

            ],
          ),
          const SizedBox(
            width: 20,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user, style: TextStyle(color: Colors.grey[500])),
              const SizedBox(height: 10),
              Text(widget.message)
            ],
          )
        ],
      ),
    );
  }
}
