
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewall/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> editField(String field) async{

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser.email)
        .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return  ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          //profile pic
          Icon(
            Icons.person,
            size: 72,
          ),
          const SizedBox(
            height: 10,
          ),

          // user email
          Text(
            currentUser.email!,
            textAlign: TextAlign.center,
          ),

          const SizedBox(
            height: 50,
          ),

          // user details
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              "My Details",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),

          // username

          MyTextBox(
            text: userData['username'], 
            sectionName: 'Username',
            onPressed: () => editField('username'),
            ),

          //bio
           MyTextBox(
            text: userData['bio'], 
            sectionName: 'Bio',
            onPressed: () => editField('bio'),
            ),

            
          const SizedBox(
            height: 50,
          ),

          // user details
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              "My Posts",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),

          // user posts
        ],
      );
    
    } else if (snapshot.hasError){
      return Center(
        child: Text(
          'Error${snapshot.error}'
          ),
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
      },
      )
      
      );
  }
}














//  ListView(
//         children: [
//           const SizedBox(
//             height: 50,
//           ),
//           //profile pic
//           Icon(
//             Icons.person,
//             size: 72,
//           ),
//           const SizedBox(
//             height: 10,
//           ),

//           // user email
//           Text(
//             currentUser.email!,
//             textAlign: TextAlign.center,
//           ),

//           const SizedBox(
//             height: 50,
//           ),

//           // user details
//           Padding(
//             padding: const EdgeInsets.only(left: 25.0),
//             child: Text(
//               "My Details",
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//           ),

//           // username

//           MyTextBox(
//             text: 'Teste', 
//             sectionName: 'Username',
//             onPressed: () => editField('username'),
//             ),

//           //bio
//            MyTextBox(
//             text: 'Empty bio', 
//             sectionName: 'Bio',
//             onPressed: () => editField('bio'),
//             ),

            
//           const SizedBox(
//             height: 50,
//           ),

//           // user details
//           Padding(
//             padding: const EdgeInsets.only(left: 25.0),
//             child: Text(
//               "My Posts",
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//           ),

//           // user posts
//         ],
//       ),
    