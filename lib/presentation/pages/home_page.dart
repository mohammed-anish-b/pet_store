import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openapi/api.dart';
import 'package:pet_store/bloc/pet/pet_bloc.dart';
import 'package:pet_store/presentation/widgets/add_pet_dialog.dart';
import 'package:pet_store/presentation/widgets/pet_card.dart';

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
        return PetCard(pet: pet);
      },
      itemCount: pets.length,
    );
  }
}
