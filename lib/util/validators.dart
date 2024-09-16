mixin Validators {
  String? validatePassword(String? value){
    if (value == null || value.trim().length < 8) {
      return 'Ingrese una contraseña válida';
    }
    return null;
  }

  String? validateEmail(String? value){
    if (value == null || !value.contains("@")) {
      return 'Ingrese un correo válido';
    }
    return null;
  }

  String? validateDni(String? value){
    if (value == null ||
        value.trim().length != 8 ||
        !value.contains(RegExp(r'[0-9]'))) {
      return 'Ingrese un DNI válido';
    }
    return null;
  }
  
  String? validateName(String? value){
    if (value == null || !value.contains(RegExp(r'[a-zA-Z]'))){
      return "Ingrese un nombre válido";
    }
    return null;
  }
}