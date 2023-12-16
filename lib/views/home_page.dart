import 'package:flutter/material.dart';

import 'package:luna_mhealth_mobile/utils/navigation.dart';
import 'package:luna_mhealth_mobile/widgets/custom_app_bar.dart';
import 'package:luna_mhealth_mobile/widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Maya',
        showDrawer: true,
        showSettings: true,
        showSoundToggle: true,
        isSoundOn: false,
        onSoundToggle: () {
          // Handle sound toggle
        },
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            flex: 1, // Adjust flex as needed
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  5,
                  (index) => Container(
                    width: 160.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    child: Text('Item $index',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2, // Adjust flex as needed
            child: GridView.builder(
              itemCount: 10, // Number of modules
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 2,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      NavigationUtil.navigateToDynamicTemplate(context);
                    }
                    // Additional logic for other modules
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('Module $index'),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
