import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openapi/api.dart';
import 'package:pet_store/bloc/pet/pet_bloc.dart';

class UpdateStatusDialog extends StatelessWidget {
  const UpdateStatusDialog({
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
          const Text('Are you sure?'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.maybePop(context);
                    if (pet.status == PetStatusEnum.available) {
                      pet.status = PetStatusEnum.pending;
                    } else if (pet.status == PetStatusEnum.pending) {
                      pet.status = PetStatusEnum.sold;
                    }
                    BlocProvider.of<PetBloc>(context)
                        .add(UpdatePetEvent(pet: pet));
                    BlocProvider.of<PetBloc>(context)
                        .add(GetPetsByStatusEvent());
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                  child: const Text('No'))
            ],
          )
        ],
      ),
    );
  }
}
