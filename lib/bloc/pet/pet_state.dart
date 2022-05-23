part of 'pet_bloc.dart';

abstract class PetState {}

class PetInitial extends PetState {}

class PetsByStatusSuccessState extends PetState {}

class PetsByStatusLoadingState extends PetState {}

class PetsByStatusErrorState extends PetState {}

class AddPetSuccessState extends PetState {}

class AddPetLoadingState extends PetState {}

class AddPetErrorState extends PetState {}

class UpdatePetSuccessState extends PetState {}

class UpdatePetLoadingState extends PetState {}

class UpdatePetErrorState extends PetState {}
