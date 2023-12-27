import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/groups/controllers/group_controller.dart';
import 'package:whatsapp_clone/features/groups/widgets/group_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const routeName = '/create-group';
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final nameController = TextEditingController();
  File? file;
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void pickGroupImage() async {
    file = await pickImageFromGallary(context);
    setState(() {});
  }

  void createGroup() {
    if (nameController.text.trim().isNotEmpty && file != null) {
      ref.read(GroupControllerProvider).createGroup(
            context,
            nameController.text.trim(),
            file!,
            ref.read(selectedGroupContacts),
          );
      ref.read(selectedGroupContacts.state).update((state) => []);
      Navigator.pop(context);
    } else {
      showSnackBar(context: context, content: 'fill all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Create Group',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child:
                  //  Container(
                  // width: double.infinity,
                  // child:
                  Stack(
                clipBehavior: Clip.none,
                // alignment: Alignment.center,
                children: [
                  file != null
                      ? CircleAvatar(
                          radius: 65,
                          backgroundImage: FileImage(file!),
                        )
                      : const CircleAvatar(
                          radius: 65,
                          backgroundImage: NetworkImage(
                            'https://www.portmelbournefc.com.au/wp-content/uploads/2022/03/avatar-1.jpeg',
                          ),
                        ),
                  Positioned(
                    // right: -10,
                    left: 85,
                    top: 90,
                    child: IconButton(
                      onPressed: () {
                        pickGroupImage();
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              // ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Enter Group Name',
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'Select Contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const GroupContacts(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
        onPressed: createGroup,
      ),
    );
  }
}
