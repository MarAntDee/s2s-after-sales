import 'package:flutter/material.dart';
import 'package:surf2sawa/blocs/shopkeeper.dart';

import '../models/announcement.dart';

class AnnouncementBoard extends StatelessWidget {
  final ShopKeeper _shopkeeper;
  const AnnouncementBoard(this._shopkeeper, {super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);

    return FutureBuilder<List<Announcement>>(
        future: _shopkeeper.getAnnouncementBoard,
        builder: (context, announcements) {
          if (!announcements.hasData) return const Center(
            child: SizedBox.square(
              dimension: 60,
              child: CircularProgressIndicator(),
            ),
          );
          if (announcements.data!.isEmpty) return const Center(
            child: Text("No notifications"),
          );
          return ListView(
            children: [
              const SizedBox(height: 32),
              ...announcements.data!.map((announcement) => Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black12,
                    width: 1,
                  ),
                ),
              ),
              child: ListTile(
                leading: const Icon(Icons.mail_outline_rounded),
                title: Text(
                  announcement.title,
                  style: _theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  announcement.message,
                  style: _theme.textTheme.labelMedium,
                ),
                // trailing: Text(
                //   activity.createdText,
                //   textAlign: TextAlign.end,
                //   style: _theme.textTheme.labelSmall,
                // ),
              ),
            ),).toList(),
              const SizedBox(height: 40),
            ],
          );
        }
    );
  }
}
