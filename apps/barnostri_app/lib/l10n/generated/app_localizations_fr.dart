// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

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
  String get scanQRCodeDescription =>
      'Scannez le QR code de votre table pour commencer à commander';

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
  String get emptyCartDescription =>
      'Ajoutez des articles du menu pour commencer votre commande';

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
  String get orderPlacedDescription =>
      'Votre commande a été passée avec succès et est en cours de préparation';

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
  String get adminTitle => 'Barnostri Admin';

  @override
  String get adminRestricted => 'Accès réservé au personnel';

  @override
  String get login => 'Se connecter';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Mot de passe';

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
  String get demoCredentialsTitle => 'Identifiants de démonstration:';

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
  String get scanQRInstructions =>
      'Positionnez le QR code dans le cadre pour scanner';

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
  String get orderUpdateError =>
      'Échec de la mise à jour du statut de la commande';

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

  @override
  String get demoModeCredentials =>
      'Mode démo - Configurez les identifiants Supabase pour accéder à toutes les fonctionnalités';

  @override
  String get footerTagline => '🏖️ Plage • Saveur • Tradition';

  @override
  String get homeSlogan => 'Saveurs uniques de la plage carioca 🏖️';

  @override
  String get searchMenuPlaceholder => 'Rechercher des plats et boissons...';

  @override
  String emptyCategoryItems(String categoryName) {
    return 'Aucun article disponible\ndans la catégorie $categoryName';
  }

  @override
  String get errorLoadingOrders => 'Erreur lors du chargement des commandes';

  @override
  String get noActiveOrders => 'Aucune commande active';

  @override
  String get newOrdersAppearHere => 'Les nouvelles commandes apparaîtront ici';

  @override
  String get adminPanel => 'Panneau Administratif';

  @override
  String get tableCode => 'Code de la Table';

  @override
  String get tableCodePrompt => 'Entrez le code qui se trouve sur la table:';

  @override
  String get tableCodeHint => 'Ex: table_001_qr';

  @override
  String get qrCameraInstructions => 'Pointez la caméra vers le QR code';

  @override
  String get qrCodeLocation => 'Vous le trouverez sur votre table';

  @override
  String get insertCodeManually => 'Saisir le code manuellement';

  @override
  String get orderItems => 'Articles de la Commande';

  @override
  String get totalItems => 'Total d\'Articles:';

  @override
  String get add => 'Ajouter';

  @override
  String get observationOptional => 'Observations (optionnel)';

  @override
  String get observationExample => 'Ex : Sans oignons, bien cuit...';

  @override
  String get itemUnavailable => 'Article Indisponible';

  @override
  String addedToCartMessage(Object item) {
    return '$item ajouté au panier !';
  }

  @override
  String get adminActions => 'Actions Administrateur';

  @override
  String markAsStatus(Object status) {
    return 'Marquer comme $status';
  }

  @override
  String get statusReceivedDescription => 'Commande reçue par la cuisine';

  @override
  String get statusInPrepDescription => 'Préparation de vos plats';

  @override
  String get statusReadyDescription => 'Commande prête à être récupérée';

  @override
  String get statusDeliveredDescription => 'Commande livrée';

  @override
  String get statusCancelledDescription => 'Commande annulée';

  @override
  String statusUpdated(Object status) {
    return 'Statut mis à jour en $status';
  }

  @override
  String statusUpdateErrorDetailed(Object error) {
    return 'Erreur lors de la mise à jour du statut : $error';
  }

  @override
  String get orderConfirmedKitchen =>
      'Votre commande a été confirmée et envoyée à la cuisine. Vous pouvez suivre son statut ci-dessous.';

  @override
  String get qrToken => 'Jeton QR';

  @override
  String get tableNumberLabel => 'Numéro de Table';

  @override
  String get tableNotFound => 'Table introuvable';

  @override
  String get noTableSelected => 'Aucune table sélectionnée';

  @override
  String get orderField => 'Ordre';
}
