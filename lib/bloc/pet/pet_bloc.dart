import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:openapi/api.dart';

part 'pet_event.dart';
part 'pet_state.dart';

class PetBloc extends Bloc<PetEvent, PetState> {
  PetBloc() : super(PetInitial()) {
    on<PetEvent>((event, emit) async {
      if (event is GetPetsByStatusEvent) {
        await _getPetList(event, emit);
      }
      if (event is AddPetEvent) {
        await _addPet(event, emit);
      }
      if (event is UpdatePetEvent) {
        await _updatePet(event, emit);
      }
    });
  }

  final petApi = PetApi(ApiClient());

  List<Pet> availablePets = [];
  List<Pet> pendingPets = [];
  List<Pet> soldPets = [];

  _getPetList(GetPetsByStatusEvent event, Emitter<PetState> emit) async {
    try {
      emit(PetsByStatusLoadingState());
      availablePets =
          (await petApi.findPetsByStatus(['available'])).reversed.toList();
      pendingPets =
          (await petApi.findPetsByStatus(['pending'])).reversed.toList();
      soldPets = (await petApi.findPetsByStatus(['sold'])).toList();
      emit(PetsByStatusSuccessState());
    } catch (e) {
      log(e.toString());
      emit(PetsByStatusErrorState());
    }
  }

  _addPet(AddPetEvent event, Emitter<PetState> emit) async {
    try {
      emit(AddPetLoadingState());
      await petApi.addPet(event.pet);
      emit(AddPetSuccessState());
    } catch (e) {
      log(e.toString());
      emit(AddPetErrorState());
    }
  }

  _updatePet(UpdatePetEvent event, Emitter<PetState> emit) async {
    try {
      emit(AddPetLoadingState());
      await petApi.updatePet(event.pet);
      emit(AddPetSuccessState());
    } catch (e) {
      log(e.toString());
      emit(AddPetErrorState());
    }
  }
}
