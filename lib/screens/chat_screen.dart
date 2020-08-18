//import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedinuser;

class ChatScreen extends StatefulWidget {

  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  //to clear the messaging area to type next message
  final messagetextingcontroller = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messagetext;

  @override
  void initState() {

    super.initState();
    getcurrentuser();
  }

  //the registered users email and password will be stored in _auth object and hence
  // we are retrieveing it using currentuser function, since it expects future
  // we are using async and await
  void getcurrentuser() async{
    try{
      final user =await _auth.currentUser();
      if(user != null){
        loggedinuser=user;

      }}
    catch(e){
      print(e);
    }
  }

  //to retrieve the messages from cloud (firebase cloud)
//  void getmessages() async  {
//    final messages = await _firestore.collection('messages').getDocuments();
//    for (var message in messages.documents){
//      print(message.data);
//    }
//  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {

                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messagetextingcontroller,
                      onChanged: (value) {
                        messagetext =  value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //messagetext + usermail

                      messagetextingcontroller.clear();
                      _firestore.collection("messages").add({
                        "text": messagetext,
                        "sender" : loggedinuser.email,
                        'time': DateTime.now(),     //for the updated version of flutter we need to add time so that we can retrieve the data in the proper order
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time', descending: false).snapshots(),
      // ignore: missing_return
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),

          );
        }
        final messages = snapshot.data.documents.reversed;
        List<MesssageBubble> messageBubbles =[];
        for( var message in messages){
          final messagetext = message.data['text'];
          final messagesender=message.data['sender'];
          final currentuser=loggedinuser.email;



          final messageBubble = MesssageBubble (
            text: messagetext,
            sender: messagesender,
            isme: currentuser == messagesender,);

          messageBubbles.add(messageBubble);

        }
        //to provide the scrolling of the messages we add ListView
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
            children: messageBubbles,
          ),
        );




      },
    );
  }
}






class MesssageBubble extends StatelessWidget {

  MesssageBubble({this.text,this.sender,this.isme});

  final String text;
  final String sender;
  final bool isme;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment: isme ?  CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(sender,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),),
            Material(
              borderRadius: isme ? BorderRadius.only(topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0) ) :
              BorderRadius.only(topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0) ),
              elevation: 15.0,
              color: isme? Colors.lightBlueAccent: Colors.lightBlue[100],
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                child: Text('$text ',
                  style: TextStyle(
                    color: isme ? Colors.white : Colors.black ,
                    fontSize: 15.0,

                  ),),
              ),
            ),
          ]),
    );
  }
}
