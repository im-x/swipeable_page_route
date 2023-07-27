import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '🔙 swipeable_page_route example',
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: const Text('🔙 swipeable_page_route example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async => context.navigator
              .push<void>(SwipeablePageRoute(builder: (_) => SecondPage())),
          child: const Text('Open page 2'),
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    // Gets the `SwipeablePageRoute` wrapping the current page.
    final pageRoute = context.getSwipeablePageRoute<void>()!;

    return Scaffold(
      appBar: MorphingAppBar(
        title: const Text('Page 2'),
        actions: [
          IconButton(
            key: const ValueKey('check'),
            icon: const Icon(Icons.check),
            onPressed: () {},
          ),
          IconButton(
            key: const ValueKey('star'),
            icon: const Icon(Icons.star),
            onPressed: () {},
          ),
          IconButton(
            key: const ValueKey('play_arrow'),
            icon: const Icon(Icons.play_arrow),
            onPressed: () {},
          ),
          PopupMenuButton<void>(
            itemBuilder: (context) => [
              const PopupMenuItem(child: Text('One')),
              const PopupMenuItem(child: Text('Two')),
            ],
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Can swipe: ${pageRoute.canSwipe}'),
            TextButton(
              onPressed: () {
                // You can disable swiping completely using `canSwipe`:
                setState(() => pageRoute.canSwipe = !pageRoute.canSwipe);
              },
              child: const Text('Toggle'),
            ),
            Text('Can only swipe from edge: ${pageRoute.canOnlySwipeFromEdge}'),
            TextButton(
              onPressed: () => setState(
                () => pageRoute.canOnlySwipeFromEdge =
                    !pageRoute.canOnlySwipeFromEdge,
              ),
              child: const Text('Toggle'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await context.navigator.push<void>(SwipeablePageRoute(
                  // You can customize the width of the detection area with
                  // `backGestureDetectionWidth`.
                  builder: (_) => ThirdPage(),
                ));
              },
              child: const Text('Open page 3'),
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdPage extends StatefulWidget {
  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage>
    with SingleTickerProviderStateMixin {
  static const _tabCount = 3;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
    _tabController.addListener(() {
      if (!mounted) return;

      final canSwipe = _tabController.index == 0;
      context.getSwipeablePageRoute<void>()!.canSwipe = canSwipe;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        backgroundColor: Colors.green,
        title: const Text('Page 3'),
        actions: [
          IconButton(
            key: const ValueKey('star'),
            icon: const Icon(Icons.star),
            onPressed: () {},
          ),
          IconButton(
            key: const ValueKey('play_arrow'),
            icon: const Icon(Icons.play_arrow),
            onPressed: () {},
          ),
          IconButton(
            key: const ValueKey('favorite'),
            icon: const Icon(Icons.favorite),
            onPressed: () {},
          ),
          PopupMenuButton<void>(
            itemBuilder: (context) => [
              const PopupMenuItem(child: Text('One')),
              const PopupMenuItem(child: Text('Two')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          isScrollable: true,
          tabs: [
            for (var i = 0; i < _tabCount; i++) Tab(text: 'Tab ${i + 1}'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          for (var i = 0; i < _tabCount; i++)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('This is tab ${i + 1}'),
                ElevatedButton(
                  onPressed: () async {
                    await context.navigator.push<void>(
                      SwipeablePageRoute(builder: (_) => SecondPage()),
                    );
                  },
                  child: const Text('Open page 2'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
