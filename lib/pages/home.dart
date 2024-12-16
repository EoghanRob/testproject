import 'dart:async'; // for Timer
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testproject/models/category_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];
  Flutter3DController controller = Flutter3DController();
  Flutter3DController controller2 = Flutter3DController();

  List<String>? availableTextures;
  Timer? _textureCheckTimer;

  String _selectedHud = 'assets/icons/HUD1.png';


  @override
void initState() {
  super.initState();
  _getInitialInfo();

  // Listen for when the first model is fully loaded
  controller.onModelLoaded.addListener(() async {
    if (controller.onModelLoaded.value == true) {
      // Set the initial camera orbit and target for the first model
      controller.setCameraOrbit(30, 45, 3);
      controller.setCameraTarget(-2, 0, 5);

      // Load textures for the first model
      await _loadTextures(controller);
    }
  });

  // Listen for when the second model is fully loaded
  controller2.onModelLoaded.addListener(() async {
    if (controller2.onModelLoaded.value == true) {
      // Set the initial camera orbit and target for the second model
      controller2.setCameraOrbit(30, 45, 3);
      controller2.setCameraTarget(-2, 0, 5);

      // Load textures for the second model
      await _loadTextures(controller2);
    }
  });
}


  @override
  void dispose() {
    _textureCheckTimer?.cancel();
    super.dispose();
  }

  void _getInitialInfo() {
    categories = CategoryModel.getCategories();
  }

  Future<void> _loadTextures(Flutter3DController targetController) async {
  try {
    final textures = await targetController.getAvailableTextures();

    setState(() {
      availableTextures = textures;
    });
  } catch (e) {
    debugPrint('Failed to load textures: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _3DViewer(),

          // Display the available textures in a text box
          //_texturesList(),
          //const SizedBox(height: 20),
          const SizedBox(height: 20),
          // Dynamically create buttons for each available texture
          // Centered Text Element
        const Center(
          child: Text(
            'Turn Indicator',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),

        const SizedBox(height: 10),
          if (availableTextures != null && availableTextures!.isNotEmpty)
            _textureButtons(),
          const SizedBox(height: 20),

          // Horizontal separator line
        const Divider(
          color: Colors.grey, // Customize the color
          thickness: 1.0,     // Adjust the thickness
          indent: 20.0,       // Optional: Indent from the left
          endIndent: 20.0,    // Optional: Indent from the right
        ),

          _3DViewer2(),
          const SizedBox(height: 20),
          const Center(
          child: Text(
            'Pedestrian Crossing',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
          const SizedBox(height: 10),
          if (availableTextures != null && availableTextures!.isNotEmpty)
            _textureButtons2(),
          const SizedBox(height: 20),

          const Divider(
          color: Colors.grey, // Customize the color
          thickness: 1.0,     // Adjust the thickness
          indent: 20.0,       // Optional: Indent from the left
          endIndent: 20.0,    // Optional: Indent from the right
        ),

// Image that changes based on the selected HUD
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(
            _selectedHud,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const Center(
          child: Text(
            'HUD Type',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Buttons to switch between HUD images
        _hudButtons(),
        const SizedBox(height: 20),
         const Divider(
          color: Colors.grey, // Customize the color
          thickness: 1.0,     // Adjust the thickness
          indent: 20.0,       // Optional: Indent from the left
          endIndent: 20.0,    // Optional: Indent from the right
        ),

          const SizedBox(height: 60),
          _setViewButton(),
        ],

        
      ),
      bottomNavigationBar: bottomBar(context),
    );
  }

  SizedBox _3DViewer() {
    return SizedBox(
          height: 400,
          child: Flutter3DViewer(
            src: 'assets/models/scene.glb',
            controller: controller,
            onError: (String error) {
              debugPrint('Model failed to load: $error');
            },
          ),
        );
  }

  SizedBox _3DViewer2() {
    return SizedBox(
          height: 400,
          child: Flutter3DViewer(
            src: 'assets/models/crossing.glb',
            controller: controller2,
            onError: (String error) {
              debugPrint('Model 2 failed to load: $error');
            },
          ),
        );
  }

  Padding _textureButtons() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Color :',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10), // Space between the text and buttons
        ElevatedButton(
          onPressed: () {
            controller.setTexture(textureName: 'Red');
          },
          child: const Text('Red'),
        ),
        const SizedBox(width: 10), // Space between buttons
        ElevatedButton(
          onPressed: () {
            controller.setTexture(textureName: 'Blue');
          },
          child: const Text('Blue'),
        ),
        const SizedBox(width: 10), // Space between buttons
        ElevatedButton(
          onPressed: () {
            controller.setTexture(textureName: 'Green');
          },
          child: const Text('Green'),
        ),
      ],
    ),
  );
}


  Padding _textureButtons2() {
    return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Color :',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10), // Space between the text and buttons
        ElevatedButton(
          onPressed: () {
            controller2.setTexture(textureName: 'Red2');
          },
          child: const Text('Red'),
        ),
        const SizedBox(width: 10), // Space between buttons
        ElevatedButton(
          onPressed: () {
            controller2.setTexture(textureName: 'Blue2');
          },
          child: const Text('Blue'),
        ),
        const SizedBox(width: 10), // Space between buttons
        ElevatedButton(
          onPressed: () {
            controller2.setTexture(textureName: 'Green2');
          },
          child: const Text('Green'),
        ),
      ],
    ),
  );
  }

  Padding _setViewButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Wrap(
        spacing: 10,
        children: [
          ElevatedButton(
            onPressed: () {
              controller2.setCameraOrbit(30, 45, 0.5);
              controller2.setCameraTarget(-2, 0, 5);

              controller.setCameraOrbit(30, 45, 3);
              controller.setCameraTarget(-2, 0, 5);
            },
            child: const Text('Reset View'),
          ),
        ],
      ),
    );
  }

  Padding _texturesList() {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[200],
            child: Text(
              availableTextures == null || availableTextures!.isEmpty
                  ? 'No textures available yet... Checking...'
                  : 'Textures: ${availableTextures!.join(", ")}',
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        );
  }

  Column _categoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Category',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 120,
          child: ListView.separated(
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 20),
            separatorBuilder: (context, index) => const SizedBox(width: 25),
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: categories[index].boxColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(categories[index].iconPath),
                        )),
                    Text(
                      categories[index].name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 14),
                    )
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Container _searchField() {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: const Color.fromARGB(255, 42, 42, 42).withOpacity(0.1),
              blurRadius: 40,
              spreadRadius: 0.0)
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(15),
            hintText: 'Search',
            hintStyle: const TextStyle(
                color: Color.fromARGB(255, 159, 159, 159), fontSize: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SvgPicture.asset('assets/icons/search.svg'),
            ),
            suffixIcon: SizedBox(
              width: 100,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const VerticalDivider(
                      color: Colors.black,
                      indent: 10,
                      endIndent: 10,
                      thickness: 0.1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset('assets/icons/filter.svg'),
                    ),
                  ],
                ),
              ),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none)),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      /*title: const Text(
        'Breakfast',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),*/
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      elevation: 0.0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          // Handle back action if needed
        },
        child: Container(
          margin: const EdgeInsets.all(0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10)),
          child: SvgPicture.asset(
            'assets/icons/AegisRiderLogo.svg',
            height: 20,
            width: 20,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // Handle action if needed
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 37,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10)),
            child: SvgPicture.asset(
              'assets/icons/three-dots.svg',
              height: 20,
              width: 20,
            ),
          ),
        )
      ],
    );
  }

  Widget bottomBar(BuildContext context) {
  return BottomAppBar(
    shape: const CircularNotchedRectangle(),
    notchMargin: 6.0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            // Navigate to the Home page
            Navigator.pushNamed(context, '/map');
          },
          icon: SvgPicture.asset('assets/icons/motorbike.svg', height: 34, width: 34),
          tooltip: 'Home',
        ),
        _circleButton(
          context,
          'assets/icons/helmet.svg',
          'Settings',
          Colors.green,
          () => Navigator.pushNamed(context, '/home'),
        ),
        IconButton(
          onPressed: () {
            // Navigate to the Profile page
            Navigator.pushNamed(context, '/settings');
          },
          icon: const Icon(Icons.person),
          tooltip: 'Profile',
        ),
      ],
    ),
  );
}

Widget _circleButton(
    BuildContext context, String iconPath, String tooltip, Color color, VoidCallback onPressed) {
  return IconButton(
    onPressed: () {
              controller2.setCameraOrbit(30, 45, 0.5);
              controller2.setCameraTarget(-2, 0, 5);

              controller.setCameraOrbit(30, 45, 3);
              controller.setCameraTarget(-2, 0, 5);
            },
    icon: Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(iconPath),
      ),
    ),
    tooltip: tooltip,
  );
  }

  Padding _hudButtons() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Type :',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10), // Space between the text and buttons
        ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedHud = 'assets/icons/HUD1.png';
            });
          },
          child: const Text('HUD 1'),
        ),
        const SizedBox(width: 10), // Space between buttons
        ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedHud = 'assets/icons/HUD2.png';
            });
          },
          child: const Text('HUD 2'),
        ),
        const SizedBox(width: 10), // Space between buttons
        ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedHud = 'assets/icons/HUD3.png';
            });
          },
          child: const Text('HUD 3'),
        ),
      ],
    ),
  );
}


}
