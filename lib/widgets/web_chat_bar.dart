import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:whatsapp_clone/colors.dart';

class WebChatBar extends StatelessWidget {
  const WebChatBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      color: webAppBarColor,
      height: MediaQuery.of(context).size.height * 0.077,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Expanded(
          //   child: ListTile(
          //     leading: CircleAvatar(
          //       radius: 30,
          //       backgroundImage: NetworkImage(
          //         'https://pbs.twimg.com/profile_images/1419974913260232732/Cy_CUavB.jpg',
          //       ),
          //     ),
          //     title: Text('Person'),
          //     subtitle: Text(
          //       'online',
          //     ),
          //   ),
          // ),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://pbs.twimg.com/profile_images/1419974913260232732/Cy_CUavB.jpg',
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              Text(
                'Rushil',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
