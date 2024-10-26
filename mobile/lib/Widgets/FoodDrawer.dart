import 'package:flutter/material.dart';

class FoodDrawer extends StatelessWidget {
  String search = '';

  // FoodDrawer(this.search);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      // width: MediaQuery.of(context).size.width * 2 / 3,
      child: Drawer(
        child: Column(
          children: [
            AppBar(title: Text('Welcome')),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Filters',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'Filter');
                // Navigator.pushNamed(context, 'Filter',
                //     arguments: {'search': search});
              },
            )
          ],
        ),
      ),
    );
  }
}
