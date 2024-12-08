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

  List<String>? availableTextures;
  Timer? _textureCheckTimer;

  @override
  void initState() {
    super.initState();
    _getInitialInfo();

    // Listen for when the model is fully loaded
    controller.onModelLoaded.addListener(() async {
      if (controller.onModelLoaded.value == true) {
        // Start a periodic check for textures every 1 second until we find some
        _textureCheckTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _loadTextures();
        });
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

  Future<void> _loadTextures() async {
    final textures = await controller.getAvailableTextures();

    setState(() {
      availableTextures = textures;
    });

    // If we have found any textures, stop checking
    if (availableTextures != null && availableTextures!.isNotEmpty) {
      _textureCheckTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _3DViewer(),

          // Display the available textures in a text box
          _texturesList(),
          const SizedBox(height: 20),

          // Dynamically create buttons for each available texture
          if (availableTextures != null && availableTextures!.isNotEmpty)
            _textureButtons(),
          const SizedBox(height: 20),

          _searchField(),
          const SizedBox(height: 40),
          _categoriesSection(),
          const SizedBox(height: 40),

          

          
        ],
      ),
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

  Padding _textureButtons() {
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Wrap(
              spacing: 10,
              children: availableTextures!
                  .map((textureName) => ElevatedButton(
                        onPressed: () {
                          controller.setTexture(textureName: textureName);
                        },
                        child: Text(textureName),
                      ))
                  .toList(),
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
      title: const Text(
        'Breakfast',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),
      elevation: 0.0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          // Handle back action if needed
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 162, 162, 162),
              borderRadius: BorderRadius.circular(10)),
          child: SvgPicture.asset(
            'assets/icons/left-back-arrow.svg',
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
                color: const Color.fromARGB(255, 162, 162, 162),
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
}
