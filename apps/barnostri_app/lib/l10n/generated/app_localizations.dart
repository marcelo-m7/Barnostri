import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('pt'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Barnostri'**
  String get appTitle;

  /// Welcome message on the home screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to Barnostri Beach Kiosk'**
  String get welcomeMessage;

  /// Button to scan QR code
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQRCode;

  /// Description for QR code scanning
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code on your table to start ordering'**
  String get scanQRCodeDescription;

  /// Admin access button
  ///
  /// In en, this message translates to:
  /// **'Admin Access'**
  String get adminAccess;

  /// Description for admin access
  ///
  /// In en, this message translates to:
  /// **'Access administrative functions'**
  String get adminAccessDescription;

  /// Menu label
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// Cart label
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// Orders label
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// Tables label
  ///
  /// In en, this message translates to:
  /// **'Tables'**
  String get tables;

  /// Categories label
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Items label
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// Search label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Search placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search menu items...'**
  String get searchMenuItems;

  /// Add to cart button
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// Quantity label
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// Observations label
  ///
  /// In en, this message translates to:
  /// **'Observations'**
  String get observations;

  /// Observations hint text
  ///
  /// In en, this message translates to:
  /// **'Special requests or notes...'**
  String get observationsHint;

  /// Price label
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Total label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Subtotal label
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// Empty cart message
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get emptyCart;

  /// Empty cart description
  ///
  /// In en, this message translates to:
  /// **'Add items from the menu to start your order'**
  String get emptyCartDescription;

  /// Start ordering button
  ///
  /// In en, this message translates to:
  /// **'Start Ordering'**
  String get startOrdering;

  /// Payment method label
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// Pix payment method
  ///
  /// In en, this message translates to:
  /// **'Pix'**
  String get pix;

  /// Card payment method
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// Cash payment method
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// Checkout button
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// Processing order message
  ///
  /// In en, this message translates to:
  /// **'Processing Order...'**
  String get processingOrder;

  /// Order placed success message
  ///
  /// In en, this message translates to:
  /// **'Order Placed!'**
  String get orderPlaced;

  /// Order placed success description
  ///
  /// In en, this message translates to:
  /// **'Your order has been successfully placed and is being prepared'**
  String get orderPlacedDescription;

  /// Order number label
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderNumber;

  /// Track order button
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get trackOrder;

  /// Order received status
  ///
  /// In en, this message translates to:
  /// **'Order Received'**
  String get orderReceived;

  /// In preparation status
  ///
  /// In en, this message translates to:
  /// **'In Preparation'**
  String get inPreparation;

  /// Ready status
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// Delivered status
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// Cancelled status
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// Table number display
  ///
  /// In en, this message translates to:
  /// **'Table {number}'**
  String tableNumber(String number);

  /// Items count display
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String itemsCount(int count);

  /// Admin label
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// Login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Email input hint
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// Password input hint
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// Invalid email error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// Password required error
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Login error message
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get loginError;

  /// Demo mode label
  ///
  /// In en, this message translates to:
  /// **'Demo Mode'**
  String get demoMode;

  /// Demo credentials text
  ///
  /// In en, this message translates to:
  /// **'Use: admin@barnostri.com / admin123'**
  String get demoCredentials;

  /// Add item button
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// Edit item button
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItem;

  /// Delete item button
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get deleteItem;

  /// Add category button
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// Edit category button
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// Add table button
  ///
  /// In en, this message translates to:
  /// **'Add Table'**
  String get addTable;

  /// Name label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Description label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Category label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Available label
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Unavailable label
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success label
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Warning label
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Remove button
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Update button
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Previous button
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No items found message
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// Try again button
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// QR scan page title
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQRTitle;

  /// QR scan instructions
  ///
  /// In en, this message translates to:
  /// **'Position the QR code within the frame to scan'**
  String get scanQRInstructions;

  /// Manual entry button
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manualEntry;

  /// Manual entry description
  ///
  /// In en, this message translates to:
  /// **'Enter table number manually'**
  String get manualEntryDescription;

  /// Enter table number dialog title
  ///
  /// In en, this message translates to:
  /// **'Enter Table Number'**
  String get enterTableNumber;

  /// Table number input hint
  ///
  /// In en, this message translates to:
  /// **'Enter table number (e.g., 1, 2, 3...)'**
  String get tableNumberHint;

  /// Invalid table number error
  ///
  /// In en, this message translates to:
  /// **'Invalid table number'**
  String get invalidTableNumber;

  /// Order status label
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get orderStatus;

  /// Order details label
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// Order time label
  ///
  /// In en, this message translates to:
  /// **'Order Time'**
  String get orderTime;

  /// Payment status label
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// Paid status
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// Unpaid status
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// Pending status
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Approved status
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// Update status button
  ///
  /// In en, this message translates to:
  /// **'Update Status'**
  String get updateStatus;

  /// Mark as ready button
  ///
  /// In en, this message translates to:
  /// **'Mark as Ready'**
  String get markAsReady;

  /// Mark as delivered button
  ///
  /// In en, this message translates to:
  /// **'Mark as Delivered'**
  String get markAsDelivered;

  /// Order updated success message
  ///
  /// In en, this message translates to:
  /// **'Order status updated successfully'**
  String get orderUpdated;

  /// Order update error message
  ///
  /// In en, this message translates to:
  /// **'Failed to update order status'**
  String get orderUpdateError;

  /// Delete confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get confirmDelete;

  /// Delete confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Confirmation'**
  String get deleteConfirmation;

  /// Item deleted success message
  ///
  /// In en, this message translates to:
  /// **'Item deleted successfully'**
  String get itemDeleted;

  /// Item added success message
  ///
  /// In en, this message translates to:
  /// **'Item added successfully'**
  String get itemAdded;

  /// Item updated success message
  ///
  /// In en, this message translates to:
  /// **'Item updated successfully'**
  String get itemUpdated;

  /// Category added success message
  ///
  /// In en, this message translates to:
  /// **'Category added successfully'**
  String get categoryAdded;

  /// Table added success message
  ///
  /// In en, this message translates to:
  /// **'Table added successfully'**
  String get tableAdded;

  /// Fill all fields error message
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get fillAllFields;

  /// Language label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Settings label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Portuguese language
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// French language
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// Warning shown when Supabase credentials are not configured
  ///
  /// In en, this message translates to:
  /// **'Demo mode - Configure Supabase credentials for full features'**
  String get demoModeCredentials;

  /// Tagline shown in the footer
  ///
  /// In en, this message translates to:
  /// **'🏖️ Beach • Flavor • Tradition'**
  String get footerTagline;

  /// Slogan displayed on the home screen
  ///
  /// In en, this message translates to:
  /// **'Unique flavors of the Carioca beach 🏖️'**
  String get homeSlogan;

  /// Placeholder for menu search field
  ///
  /// In en, this message translates to:
  /// **'Search for food and drinks...'**
  String get searchMenuPlaceholder;

  /// Message shown when a category has no items
  ///
  /// In en, this message translates to:
  /// **'No items available\nin the {categoryName} category'**
  String emptyCategoryItems(String categoryName);

  /// Error message when orders fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading orders'**
  String get errorLoadingOrders;

  /// Displayed when there are no active orders
  ///
  /// In en, this message translates to:
  /// **'No active orders'**
  String get noActiveOrders;

  /// Hint when there are no active orders
  ///
  /// In en, this message translates to:
  /// **'New orders will appear here'**
  String get newOrdersAppearHere;

  /// Title of the admin dashboard
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// Label for table code field
  ///
  /// In en, this message translates to:
  /// **'Table Code'**
  String get tableCode;

  /// Prompt asking for the table code
  ///
  /// In en, this message translates to:
  /// **'Enter the code on the table:'**
  String get tableCodePrompt;

  /// Hint for the table code input
  ///
  /// In en, this message translates to:
  /// **'Ex: table_001_qr'**
  String get tableCodeHint;

  /// Instructions to scan the QR code
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the QR code'**
  String get qrCameraInstructions;

  /// Explains where the QR code is located
  ///
  /// In en, this message translates to:
  /// **'You\'ll find it on your table'**
  String get qrCodeLocation;

  /// Button to manually enter a table code
  ///
  /// In en, this message translates to:
  /// **'Insert code manually'**
  String get insertCodeManually;

  /// Section title for items in the cart
  ///
  /// In en, this message translates to:
  /// **'Order Items'**
  String get orderItems;

  /// Label for total items in cart
  ///
  /// In en, this message translates to:
  /// **'Total Items:'**
  String get totalItems;

  /// Generic add button
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Label for optional observations field
  ///
  /// In en, this message translates to:
  /// **'Observations (optional)'**
  String get observationOptional;

  /// Hint example for observations field
  ///
  /// In en, this message translates to:
  /// **'E.g. No onions, well done...'**
  String get observationExample;

  /// Displayed when an item is unavailable
  ///
  /// In en, this message translates to:
  /// **'Item Unavailable'**
  String get itemUnavailable;

  /// Snack bar message when item is added to cart
  ///
  /// In en, this message translates to:
  /// **'{item} added to cart!'**
  String addedToCartMessage(Object item);

  /// Section title for admin actions
  ///
  /// In en, this message translates to:
  /// **'Admin Actions'**
  String get adminActions;

  /// Button to mark order as a status
  ///
  /// In en, this message translates to:
  /// **'Mark as {status}'**
  String markAsStatus(Object status);

  /// Description for received status
  ///
  /// In en, this message translates to:
  /// **'Order received by the kitchen'**
  String get statusReceivedDescription;

  /// Description for in preparation status
  ///
  /// In en, this message translates to:
  /// **'Preparing your dishes'**
  String get statusInPrepDescription;

  /// Description for ready status
  ///
  /// In en, this message translates to:
  /// **'Order ready for pickup'**
  String get statusReadyDescription;

  /// Description for delivered status
  ///
  /// In en, this message translates to:
  /// **'Order delivered'**
  String get statusDeliveredDescription;

  /// Description for cancelled status
  ///
  /// In en, this message translates to:
  /// **'Order cancelled'**
  String get statusCancelledDescription;

  /// Message when order status is updated
  ///
  /// In en, this message translates to:
  /// **'Status updated to {status}'**
  String statusUpdated(Object status);

  /// Message shown when updating status fails
  ///
  /// In en, this message translates to:
  /// **'Error updating status: {error}'**
  String statusUpdateErrorDetailed(Object error);

  /// Order confirmation dialog description
  ///
  /// In en, this message translates to:
  /// **'Your order has been confirmed and sent to the kitchen. You can track its status below.'**
  String get orderConfirmedKitchen;

  /// Label for QR token field
  ///
  /// In en, this message translates to:
  /// **'QR Token'**
  String get qrToken;

  /// Label for table number field
  ///
  /// In en, this message translates to:
  /// **'Table Number'**
  String get tableNumberLabel;

  /// Error message when table is not found
  ///
  /// In en, this message translates to:
  /// **'Table not found'**
  String get tableNotFound;

  /// Error message when no table is selected
  ///
  /// In en, this message translates to:
  /// **'No table selected'**
  String get noTableSelected;

  /// Label for numeric ordering field
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get orderField;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
