import 'package:flutter/material.dart';
import 'package:openapi/api.dart';
import 'package:pet_store/presentation/widgets/add_pet_dialog.dart';
import 'package:pet_store/presentation/widgets/delete_pet_dialog.dart';
import 'package:pet_store/presentation/widgets/pet_detail_dialog.dart';
import 'package:pet_store/presentation/widgets/update_status_dialog.dart';

class PetCard extends StatelessWidget {
  const PetCard({
    Key? key,
    required this.pet,
  }) : super(key: key);

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return PetDetailDialog(pet: pet);
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(child: Text(pet.name ?? '')),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AddPetDialog(pet: pet);
                      },
                    );
                  },
                  padding: const EdgeInsets.all(8),
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.grey,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DeletePetDialog(pet: pet);
                      },
                    );
                  },
                  padding: const EdgeInsets.all(8),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                if (pet.status != PetStatusEnum.sold)
                  TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return UpdateStatusDialog(pet: pet);
                          },
                        );
                      },
                      child: Text(pet.status == PetStatusEnum.available
                          ? 'ORDER NOW'
                          : 'MARK AS SOLD'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
