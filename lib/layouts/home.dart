import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';

TextEditingController _inventoryEditingController = TextEditingController();
TextEditingController _favouritesEditingController = TextEditingController();
PageController _pageController = PageController(initialPage: 0);

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int pageindex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                children: const [
                  Icon(
                    Icons.support_agent,
                    color: Colors.black,
                  ),
                  Text("  Information"),
                ],
              ),
              content: const Text(
                  "Slide an item from left to right to delete and from right to left to add to the favorites."),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Got it!")),
              ],
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available items in the inventory.")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _inventoryEditingController.clear();
          _favouritesEditingController.clear();
          showDialog(
              context: context,
              builder: (context) {
                bool isInventoryValid = true;
                bool isFavouriteValid = true;
                return StatefulBuilder(builder: (context, setNewstate) {
                  return AlertDialog(
                    title: pageindex == 0
                        ? const Text("Add new item in inventory!")
                        : const Text("Add new item in Favourites!"),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        pageindex == 0
                            ? TextField(
                                controller: _inventoryEditingController,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    errorText: !isInventoryValid
                                        ? "Please input an item"
                                        : null,
                                    hintText:
                                        "Input an item to add to the inventory"))
                            : TextField(
                                controller: _favouritesEditingController,
                                decoration: InputDecoration(
                                    errorText: !isFavouriteValid
                                        ? "Please input an item"
                                        : null,
                                    border: const OutlineInputBorder(),
                                    hintText:
                                        "Input an item to add to the favourites"),
                              ),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            if (pageindex == 0 &&
                                _inventoryEditingController.value.text != "") {
                              Provider.of<AppData>(context, listen: false)
                                  .addData(
                                      _inventoryEditingController.value.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Added an item to the inventory")));
                              isInventoryValid = true;
                              Navigator.pop(context);
                            } else if (pageindex == 1 &&
                                _favouritesEditingController.value.text != "") {
                              Provider.of<AppData>(context, listen: false)
                                  .insertToFavorites(
                                      _favouritesEditingController.value.text);

                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Added an item to the Favourites")));

                              Navigator.pop(context);
                            } else {
                              if (pageindex == 0) {
                                setNewstate(() {
                                  isInventoryValid = false;
                                });
                              } else {
                                setNewstate(() {
                                  isFavouriteValid = false;
                                });
                              }
                            }
                          },
                          child: const Text("Add"))
                    ],
                  );
                });
              });
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: pageindex,
          onTap: (value) {
            _pageController.jumpToPage(value);
            setState(() {
              pageindex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.event_available),
                label: "Available items in the inventory"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "Favorites in the inventory"),
          ]),
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            pageindex = value;
          });
        },
        children: const [
          Available(),
          Favourites(),
        ],
      ),
    );
  }
}

class Available extends StatefulWidget {
  const Available({super.key});

  @override
  State<Available> createState() => _AvailableState();
}

class _AvailableState extends State<Available> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Column(children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount:
                Provider.of<AppData>(context).getlength(isFavourite: false),
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      Provider.of<AppData>(context, listen: false)
                          .deleteData(index);

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Item removed from inventory")));
                    } else {
                      Provider.of<AppData>(context, listen: false)
                          .addTofavourites(index);

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Added an item to the Facourites")));
                    }
                  },
                  key: Key(Provider.of<AppData>(context).data[index]),
                  background: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.centerLeft,
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  secondaryBackground: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.centerRight,
                    color: Colors.blue,
                    child: const Icon(Icons.favorite, color: Colors.white),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: ListTile(
                      title: Text(Provider.of<AppData>(context).data[index]),
                    ),
                  ));
            },
          ),
        ),
      ]),
    );
  }
}

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Column(children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount:
                Provider.of<AppData>(context).getlength(isFavourite: true),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: ListTile(
                  title:
                      Text(Provider.of<AppData>(context).getFavourite()[index]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
