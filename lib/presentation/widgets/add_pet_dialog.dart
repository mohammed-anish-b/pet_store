import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openapi/api.dart';
import 'package:pet_store/bloc/pet/pet_bloc.dart';

class AddPetDialog extends StatefulWidget {
  final Pet? pet;
  const AddPetDialog({Key? key, this.pet}) : super(key: key);

  @override
  State<AddPetDialog> createState() => _AddPetDialogState();
}

class _AddPetDialogState extends State<AddPetDialog> {
  TextEditingController? nameTextController;

  @override
  void initState() {
    nameTextController = widget.pet == null
        ? TextEditingController()
        : TextEditingController(text: widget.pet?.name);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameTextController,
            decoration: const InputDecoration(
              labelText: 'Name',
              alignLabelWithHint: true,
            ),
          ),
          TextButton(
              onPressed: () {
                if (widget.pet == null) {
                  Pet pet = Pet(name: nameTextController?.text);
                  pet.category = Category();
                  pet.status = PetStatusEnum.available;
                  BlocProvider.of<PetBloc>(context).add(AddPetEvent(pet: pet));
                } else {
                  widget.pet?.name = nameTextController?.text;
                  BlocProvider.of<PetBloc>(context)
                      .add(UpdatePetEvent(pet: widget.pet));
                }
                Navigator.maybePop(context);
                BlocProvider.of<PetBloc>(context).add(GetPetsByStatusEvent());
              },
              child: Text(widget.pet == null ? 'ADD' : 'UPDATE'))
        ],
      ),
    );
  }
}
