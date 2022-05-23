import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openapi/api.dart';
import 'package:pet_store/bloc/pet/pet_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<PetBloc>(context).add(GetPetsByStatusEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return const AddPetDialog();
              },
            );
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text('PET STORE'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Available'),
              Tab(text: 'Pending'),
              Tab(text: 'Sold'),
            ],
          ),
        ),
        body: BlocBuilder<PetBloc, PetState>(
          builder: (context, state) {
            final availablePets =
                BlocProvider.of<PetBloc>(context).availablePets;
            final pendingPets = BlocProvider.of<PetBloc>(context).pendingPets;
            final soldPets = BlocProvider.of<PetBloc>(context).soldPets;
            if (state is PetsByStatusLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is PetsByStatusErrorState) {
              return const Center(
                child: Text('Pets loading failed'),
              );
            }
            return TabBarView(
              children: [
                _buildPetsListView(availablePets),
                _buildPetsListView(pendingPets),
                _buildPetsListView(soldPets),
              ],
            );
          },
        ),
      ),
    );
  }

  ListView _buildPetsListView(List<Pet> pets) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final pet = pets[index];
        return Padding(
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
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Are you sure?'),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.maybePop(context);
                                          BlocProvider.of<PetBloc>(context)
                                              .add(DeletePetEvent(id: pet.id));
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
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('Are you sure?'),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.maybePop(context);
                                              if (pet.status ==
                                                  PetStatusEnum.available) {
                                                pet.status =
                                                    PetStatusEnum.pending;
                                              } else if (pet.status ==
                                                  PetStatusEnum.pending) {
                                                pet.status = PetStatusEnum.sold;
                                              }
                                              BlocProvider.of<PetBloc>(context)
                                                  .add(
                                                      UpdatePetEvent(pet: pet));
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
        );
      },
      itemCount: pets.length,
    );
  }
}

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
