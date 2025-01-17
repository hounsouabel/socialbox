class InscriptionData {
  
  // Étape 1
  String firstname;
  String lastname;
  String pseudo;
  
  // Étape 2
  DateTime? birthDate;

  // Etape 3
  String? gender;

  //Etape 4
  String email;

  //Etape 5
  String password;
  

  InscriptionData({
    this.email = '',
    this.password = '',
    this.firstname = '',
    this.lastname = '',
    this.pseudo='',  
    
    //this.phoneNumber = '',
    //this.address = '',
  });
}

// Instance globale
InscriptionData inscriptionData = InscriptionData();
