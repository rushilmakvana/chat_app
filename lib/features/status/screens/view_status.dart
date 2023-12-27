import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/models/status_model.dart';

class ViewStory extends StatefulWidget {
  static const routeName = 'view-story';
  final Status status;
  ViewStory({required this.status});

  @override
  State<ViewStory> createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {
  DateTime? time = DateTime.now();
  // time= widget.status.photoUrl[0]['createdAt'];
  StoryController storyController = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    time = DateTime.fromMillisecondsSinceEpoch(
        widget.status.photoUrl[0]['createdAt']);
    initStoryPageItems();
    // time = DateTime.fromMillisecondsSinceEpoch(
    //     widget.status.photoUrl[0]['createdAt']);
  }

  initStoryPageItems() {
    for (int i = 0; i < widget.status.photoUrl.length; i++) {
      storyItems.add(
        StoryItem.pageImage(
          // caption: widget.status.userName,
          // requestHeaders: {'name': 'hello'},
          url: widget.status.photoUrl[i]['image'],
          controller: storyController,
        ),
        // StoryItem.inlineImage(url: url, controller: controller)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration.zero, () {});
    // print('date = ' + widget.status.photoUrl[0]['createdAt'].toString());
    return Scaffold(
      body: storyItems.isEmpty
          ? const Loader()
          : Stack(
              children: [
                StoryView(
                  onStoryShow: (value) {
                    int pos = storyItems.indexOf(value);
                    Future.delayed(Duration.zero, () {
                      setState(() {
                        time = DateTime.fromMillisecondsSinceEpoch(
                            widget.status.photoUrl[pos]['createdAt']);
                      });
                    });
                    // }
                    // print("time = " + time.toString());
                    // print('valeu  = ' + value.view.toString());
                    // print('positino = ' + storyItems.indexOf(value).toString());
                    // print('story = ' + storyItems[0]. toString());
                  },
                  inline: true,
                  storyItems: storyItems,
                  controller: storyController,
                  // progressPosition: ProgressPosition.bottom,
                  onComplete: () => Navigator.pop(context),
                  onVerticalSwipeComplete: (direction) {
                    if (direction == Direction.down) {
                      Navigator.pop(context);
                    }
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50, left: 15),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 28,
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading: CircleAvatar(
                            // radius: 30,
                            backgroundImage:
                                NetworkImage(widget.status.profilePic),
                          ),
                          title: Text(
                            widget.status.uid ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? 'You'
                                : widget.status.userName,
                          ),
                          subtitle: Text(
                            DateFormat.MEd().add_jm().format(time!),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
