import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/status/controller/status_controller.dart';
import 'package:whatsapp_clone/features/status/screens/view_status.dart';
import 'package:whatsapp_clone/models/status_model.dart';

class StatusScreen extends ConsumerWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.read(statusRepoProvider).getStatus(context);
    return FutureBuilder<List<Status>>(
      future: ref.read(statusControllerProvider).getStatus(context),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        // print(snapshot.data);
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            var statusData = snapshot.data![index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ViewStory.routeName,
                      arguments: statusData,
                    );
                  },
                  child: ListTile(
                    leading: DottedBorder(
                      borderType: BorderType.Circle,
                      radius: const Radius.circular(5),
                      color: tabColor,
                      strokeWidth: 2,
                      strokeCap: StrokeCap.round,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          statusData.photoUrl[statusData.photoUrl.length - 1]
                              ['image'],
                        ),
                      ),
                    ),
                    title: Text(
                      statusData.uid == FirebaseAuth.instance.currentUser!.uid
                          ? 'My status'
                          : statusData.userName,
                    ),
                  ),
                ),
                Divider(
                  color: dividerColor,
                  indent: 85,
                  // height: 1,
                ),
              ],
            );
          },
          itemCount: snapshot.data!.length,
        );
      }),
    );
    // return Container();
  }
}
