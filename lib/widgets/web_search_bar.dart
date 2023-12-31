import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.height * 0.06,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: dividerColor,
          ),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
            hintText: 'Seach or type new chat',
            hintStyle: TextStyle(
              fontSize: 14,
            ),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            fillColor: searchBarColor,
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Icon(
                Icons.search,
              ),
            ),
            contentPadding: EdgeInsets.all(10)),
      ),
    );
  }
}
