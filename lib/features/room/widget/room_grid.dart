import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/features/room/model/room_dto.dart';
import 'package:openmeter/features/room/provider/room_list_provider.dart';
import 'package:openmeter/features/room/widget/room_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RoomGrid extends ConsumerStatefulWidget {
  const RoomGrid({super.key});

  @override
  ConsumerState createState() => _RoomGridState();
}

class _RoomGridState extends ConsumerState<RoomGrid> {
  int _pageIndex = 0;
  final _pageController = PageController(initialPage: 0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    final roomsProvider = ref.watch(roomListProvider);

    return roomsProvider.when(
      data: (data) {
        if (data.$1.isEmpty) {
          return Center(
            child: Text(
              'Es wurden noch keine Zimmer erstellt. \n Drücke jetzt auf das Plus um ein Zimmer zu erstellen.',
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
          );
        }

        final first = data.$1;
        final second = data.$2;

        double height = 180;

        if (first.length == 1 && second.isEmpty) {
          height = 170;
        } else {
          height = 350;
        }

        return Column(
          children: [
            SizedBox(
              height: height,
              child: PageView.builder(
                controller: _pageController,
                physics: const AlwaysScrollableScrollPhysics(),
                onPageChanged: (value) {
                  setState(() {
                    _pageIndex = value;
                  });
                },
                itemCount: first.length,
                itemBuilder: (context, index) {
                  RoomDto room1 = first.elementAt(index);
                  RoomDto? room2;

                  if (index < second.length) {
                    room2 = second.elementAt(index);
                  }

                  return Column(
                    children: [
                      RoomCard(room1),
                      if (room2 != null) RoomCard(room2),
                    ],
                  );
                },
              ),
            ),
            AnimatedSmoothIndicator(
              activeIndex: _pageIndex,
              count: first.length,
              effect: WormEffect(
                activeDotColor: Theme.of(context).primaryColor,
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),
          ],
        );
      },
      error: (error, stackTrace) => throw error,
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
