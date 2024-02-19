import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/src/features/home/presentation/great_place_controller.dart';
import 'package:great_places/src/features/home/presentation/widgets/image_input.dart';
import 'package:great_places/src/features/home/presentation/widgets/location_input.dart';

class PlaceFormPage extends ConsumerStatefulWidget {
  const PlaceFormPage({super.key});

  @override
  ConsumerState<PlaceFormPage> createState() => _PlaceFormPageState();
}

class _PlaceFormPageState extends ConsumerState<PlaceFormPage> {
  final _titleController = TextEditingController();
  File? _pickedImage;
  LatLng? _position;

  void _setImage(File? pickedImage) {
    setState(() {
      _pickedImage = pickedImage;
    });
  }

  void _setLocation(LatLng position) {
    setState(() {
      _position = position;
    });
  }

  void _submitForm() {
    if (_titleController.text.isEmpty ||
        _pickedImage == null ||
        _position == null) {
      return;
    }

    ref.read(greatPlaceControllerProvider.notifier).addPlace(
      _titleController.text,
      _pickedImage!,
      _position!,
    );

    Navigator.of(context).pop();
  }

  bool canSubmit() {
    return _pickedImage != null &&
        _position != null &&
        _titleController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('New place'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 20),
                      ImageInput(onSelectImage: _setImage),
                      const SizedBox(height: 20),
                      LocationInput(
                        onSelectPosition: _setLocation,
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: canSubmit() ? _submitForm : null,
                icon: const Icon(Icons.add),
                label: const Text('Add place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
