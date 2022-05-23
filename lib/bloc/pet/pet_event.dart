part of 'pet_bloc.dart';

abstract class PetEvent {}

class GetPetsByStatusEvent extends PetEvent {}

class AddPetEvent extends PetEvent {
  Pet? pet;
  AddPetEvent({this.pet});
}

class UpdatePetEvent extends PetEvent {
  Pet? pet;
  UpdatePetEvent({this.pet});
}

class DeletePetEvent extends PetEvent {
  int? id;
  DeletePetEvent({this.id});
}

class UploadPetImage extends PetEvent {
  int? id;
  File? file;
  UploadPetImage({this.id, this.file});
}
