import 'package:flutter/material.dart';
import 'package:openapi/api.dart';

class PetDetailDialog extends StatelessWidget {
  const PetDetailDialog({
    Key? key,
    required this.pet,
  }) : super(key: key);

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            child: PageView.builder(
              itemCount: pet.photoUrls.length,
              itemBuilder: (context, index) {
                final imageUrl = pet.photoUrls[index];
                return Image.network(
                  imageUrl,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Text('Invalid image')),
                  loadingBuilder: (context, child, loadingProgress) =>
                      const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
          Text(pet.name ?? '')
        ],
      ),
    );
  }
}
