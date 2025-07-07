import 'app_localizations.dart';

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Barnostri';

  @override
  String get welcomeMessage => 'Bienvenue au Barnostri Beach Kiosk';

  @override
  String get scanQRCode => 'Scanner le QR Code';

  @override
  String get scanQRCodeDescription => 'Scannez le QR code de votre table pour commencer à commander';

  @override
  String get adminAccess => 'Accès Administrateur';

  @override
  String get adminAccessDescription => 'Accéder aux fonctions administratives';

  @override
  String get menu => 'Menu';

  @override
  String get cart => 'Panier';

  @override
  String get orders => 'Commandes';

  @override
  String get tables => 'Tables';

  @override
  String get categories => 'Catégories';

  @override
  String get items => 'Articles';

  @override
  String get search => 'Rechercher';

  @override
  String get searchMenuItems => 'Rechercher des articles du menu...';

  @override
  String get addToCart => 'Ajouter au Panier';

  @override
  String get quantity => 'Quantité';

  @override
  String get observations => 'Observations';

  @override
  String get observationsHint => 'Demandes spéciales ou notes...';

  @override
  String get price => 'Prix';

  @override
  String get total => 'Total';

  @override
  String get subtotal => 'Sous-total';

  @override
  String get emptyCart => 'Votre panier est vide';

  @override
  String get emptyCartDescription => 'Ajoutez des articles du menu pour commencer votre commande';

  @override
  String get startOrdering => 'Commencer la Commande';

  @override
  String get paymentMethod => 'Méthode de Paiement';

  @override
  String get pix => 'Pix';

  @override
  String get card => 'Carte';

  @override
  String get cash => 'Espèces';

  @override
  String get checkout => 'Valider la Commande';

  @override
  String get processingOrder => 'Traitement de la Commande...';

  @override
  String get orderPlaced => 'Commande Passée!';

  @override
  String get orderPlacedDescription => 'Votre commande a été passée avec succès et est en cours de préparation';

  @override
  String get orderNumber => 'Numéro de Commande';

  @override
  String get trackOrder => 'Suivre la Commande';

  @override
  String get orderReceived => 'Commande Reçue';

  @override
  String get inPreparation => 'En Préparation';

  @override
  String get ready => 'Prêt';

  @override
  String get delivered => 'Livré';

  @override
  String get cancelled => 'Annulé';

  @override
  String tableNumber(String number) {
    return 'Table $number';
  }

  @override
  String itemsCount(int count) {
    return '$count articles';
  }

  @override
  String get admin => 'Admin';

  @override
  String get login => 'Se connecter';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get emailHint => 'Entrez votre email';

  @override
  String get passwordHint => 'Entrez votre mot de passe';

  @override
  String get invalidEmail => 'Veuillez entrer un email valide';

  @override
  String get passwordRequired => 'Le mot de passe est requis';

  @override
  String get loginError => 'Échec de la connexion. Vérifiez vos identifiants.';

  @override
  String get demoMode => 'Mode Démo';

  @override
  String get demoCredentials => 'Utilisez: admin@barnostri.com / admin123';

  @override
  String get addItem => 'Ajouter un Article';

  @override
  String get editItem => 'Modifier l\'Article';

  @override
  String get deleteItem => 'Supprimer l\'Article';

  @override
  String get addCategory => 'Ajouter une Catégorie';

  @override
  String get editCategory => 'Modifier la Catégorie';

  @override
  String get addTable => 'Ajouter une Table';

  @override
  String get name => 'Nom';

  @override
  String get description => 'Description';

  @override
  String get category => 'Catégorie';

  @override
  String get available => 'Disponible';

  @override
  String get unavailable => 'Indisponible';

  @override
  String get save => 'Sauvegarder';

  @override
  String get cancel => 'Annuler';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get warning => 'Avertissement';

  @override
  String get close => 'Fermer';

  @override
  String get remove => 'Supprimer';

  @override
  String get update => 'Mettre à jour';

  @override
  String get back => 'Retour';

  @override
  String get next => 'Suivant';

  @override
  String get previous => 'Précédent';

  @override
  String get loading => 'Chargement...';

  @override
  String get noItemsFound => 'Aucun article trouvé';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get scanQRTitle => 'Scanner le QR Code';

  @override
  String get scanQRInstructions => 'Positionnez le QR code dans le cadre pour scanner';

  @override
  String get manualEntry => 'Saisie Manuelle';

  @override
  String get manualEntryDescription => 'Saisir le numéro de table manuellement';

  @override
  String get enterTableNumber => 'Entrez le Numéro de Table';

  @override
  String get tableNumberHint => 'Entrez le numéro de table (ex: 1, 2, 3...)';

  @override
  String get invalidTableNumber => 'Numéro de table invalide';

  @override
  String get orderStatus => 'Statut de la Commande';

  @override
  String get orderDetails => 'Détails de la Commande';

  @override
  String get orderTime => 'Heure de la Commande';

  @override
  String get paymentStatus => 'Statut du Paiement';

  @override
  String get paid => 'Payé';

  @override
  String get unpaid => 'Non Payé';

  @override
  String get pending => 'En Attente';

  @override
  String get approved => 'Approuvé';

  @override
  String get updateStatus => 'Mettre à jour le Statut';

  @override
  String get markAsReady => 'Marquer comme Prêt';

  @override
  String get markAsDelivered => 'Marquer comme Livré';

  @override
  String get orderUpdated => 'Statut de la commande mis à jour avec succès';

  @override
  String get orderUpdateError => 'Échec de la mise à jour du statut de la commande';

  @override
  String get confirmDelete => 'Êtes-vous sûr de vouloir supprimer cet article?';

  @override
  String get deleteConfirmation => 'Confirmation de Suppression';

  @override
  String get itemDeleted => 'Article supprimé avec succès';

  @override
  String get itemAdded => 'Article ajouté avec succès';

  @override
  String get itemUpdated => 'Article mis à jour avec succès';

  @override
  String get categoryAdded => 'Catégorie ajoutée avec succès';

  @override
  String get tableAdded => 'Table ajoutée avec succès';

  @override
  String get fillAllFields => 'Veuillez remplir tous les champs obligatoires';

  @override
  String get language => 'Langue';

  @override
  String get settings => 'Paramètres';

  @override
  String get portuguese => 'Portugais';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';
}