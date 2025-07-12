import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Barnostri';

  @override
  String get welcomeMessage => 'Welcome to Barnostri Beach Kiosk';

  @override
  String get scanQRCode => 'Scan QR Code';

  @override
  String get scanQRCodeDescription => 'Scan the QR code on your table to start ordering';

  @override
  String get adminAccess => 'Admin Access';

  @override
  String get adminAccessDescription => 'Access administrative functions';

  @override
  String get menu => 'Menu';

  @override
  String get cart => 'Cart';

  @override
  String get orders => 'Orders';

  @override
  String get tables => 'Tables';

  @override
  String get categories => 'Categories';

  @override
  String get items => 'Items';

  @override
  String get search => 'Search';

  @override
  String get searchMenuItems => 'Search menu items...';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get quantity => 'Quantity';

  @override
  String get observations => 'Observations';

  @override
  String get observationsHint => 'Special requests or notes...';

  @override
  String get price => 'Price';

  @override
  String get total => 'Total';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get emptyCart => 'Your cart is empty';

  @override
  String get emptyCartDescription => 'Add items from the menu to start your order';

  @override
  String get startOrdering => 'Start Ordering';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get pix => 'Pix';

  @override
  String get card => 'Card';

  @override
  String get cash => 'Cash';

  @override
  String get checkout => 'Checkout';

  @override
  String get processingOrder => 'Processing Order...';

  @override
  String get paymentFailureRetry => 'Payment failed. Please try again.';

  @override
  String get orderPlaced => 'Order Placed!';

  @override
  String get orderPlacedDescription => 'Your order has been successfully placed and is being prepared';

  @override
  String get orderNumber => 'Order Number';

  @override
  String get trackOrder => 'Track Order';

  @override
  String get orderReceived => 'Order Received';

  @override
  String get inPreparation => 'In Preparation';

  @override
  String get ready => 'Ready';

  @override
  String get delivered => 'Delivered';

  @override
  String get cancelled => 'Cancelled';

  @override
  String tableNumber(String number) {
    return 'Table $number';
  }

  @override
  String itemsCount(int count) {
    return '$count items';
  }

  @override
  String get admin => 'Admin';

  @override
  String get adminTitle => 'Barnostri Admin';

  @override
  String get adminRestricted => 'Restricted access for staff';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get loginError => 'Login failed. Please check your credentials.';

  @override
  String get demoMode => 'Demo Mode';

  @override
  String get demoCredentials => 'Use: admin@barnostri.com / admin123';

  @override
  String get demoCredentialsTitle => 'Demo credentials:';

  @override
  String get addItem => 'Add Item';

  @override
  String get editItem => 'Edit Item';

  @override
  String get deleteItem => 'Delete Item';

  @override
  String get addCategory => 'Add Category';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get addTable => 'Add Table';

  @override
  String get name => 'Name';

  @override
  String get description => 'Description';

  @override
  String get category => 'Category';

  @override
  String get available => 'Available';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get close => 'Close';

  @override
  String get remove => 'Remove';

  @override
  String get update => 'Update';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get loading => 'Loading...';

  @override
  String get noItemsFound => 'No items found';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get scanQRTitle => 'Scan QR Code';

  @override
  String get scanQRInstructions => 'Position the QR code within the frame to scan';

  @override
  String get manualEntry => 'Manual Entry';

  @override
  String get manualEntryDescription => 'Enter table number manually';

  @override
  String get enterTableNumber => 'Enter Table Number';

  @override
  String get tableNumberHint => 'Enter table number (e.g., 1, 2, 3...)';

  @override
  String get invalidTableNumber => 'Invalid table number';

  @override
  String get orderStatus => 'Order Status';

  @override
  String get orderDetails => 'Order Details';

  @override
  String get orderTime => 'Order Time';

  @override
  String get paymentStatus => 'Payment Status';

  @override
  String get paid => 'Paid';

  @override
  String get unpaid => 'Unpaid';

  @override
  String get pending => 'Pending';

  @override
  String get approved => 'Approved';

  @override
  String get updateStatus => 'Update Status';

  @override
  String get markAsReady => 'Mark as Ready';

  @override
  String get markAsDelivered => 'Mark as Delivered';

  @override
  String get orderUpdated => 'Order status updated successfully';

  @override
  String get orderUpdateError => 'Failed to update order status';

  @override
  String get orderCreationFailure => 'Failed to create order';

  @override
  String orderProcessingFailure(Object error) {
    return 'Failed to process order: $error';
  }

  @override
  String get confirmDelete => 'Are you sure you want to delete this item?';

  @override
  String get deleteConfirmation => 'Delete Confirmation';

  @override
  String get itemDeleted => 'Item deleted successfully';

  @override
  String get itemAdded => 'Item added successfully';

  @override
  String get itemUpdated => 'Item updated successfully';

  @override
  String get categoryAdded => 'Category added successfully';

  @override
  String get tableAdded => 'Table added successfully';

  @override
  String get fillAllFields => 'Please fill all required fields';

  @override
  String get language => 'Language';

  @override
  String get settings => 'Settings';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get demoModeCredentials => 'Demo mode - Configure Supabase credentials for full features';

  @override
  String get footerTagline => '🏖️ Beach • Flavor • Tradition';

  @override
  String get homeSlogan => 'Unique flavors of the Carioca beach 🏖️';

  @override
  String get searchMenuPlaceholder => 'Search for food and drinks...';

  @override
  String emptyCategoryItems(String categoryName) {
    return 'No items available\nin the $categoryName category';
  }

  @override
  String get errorLoadingOrders => 'Error loading orders';

  @override
  String get noActiveOrders => 'No active orders';

  @override
  String get newOrdersAppearHere => 'New orders will appear here';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get tableCode => 'Table Code';

  @override
  String get tableCodePrompt => 'Enter the code on the table:';

  @override
  String get tableCodeHint => 'Ex: table_001_qr';

  @override
  String get qrCameraInstructions => 'Point the camera at the QR code';

  @override
  String get qrCodeLocation => 'You\'ll find it on your table';

  @override
  String get insertCodeManually => 'Insert code manually';

  @override
  String get orderItems => 'Order Items';

  @override
  String get totalItems => 'Total Items:';

  @override
  String get add => 'Add';

  @override
  String get observationOptional => 'Observations (optional)';

  @override
  String get observationExample => 'E.g. No onions, well done...';

  @override
  String get itemUnavailable => 'Item Unavailable';

  @override
  String addedToCartMessage(Object item) {
    return '$item added to cart!';
  }

  @override
  String get adminActions => 'Admin Actions';

  @override
  String markAsStatus(Object status) {
    return 'Mark as $status';
  }

  @override
  String get statusReceivedDescription => 'Order received by the kitchen';

  @override
  String get statusInPrepDescription => 'Preparing your dishes';

  @override
  String get statusReadyDescription => 'Order ready for pickup';

  @override
  String get statusDeliveredDescription => 'Order delivered';

  @override
  String get statusCancelledDescription => 'Order cancelled';

  @override
  String statusUpdated(Object status) {
    return 'Status updated to $status';
  }

  @override
  String statusUpdateErrorDetailed(Object error) {
    return 'Error updating status: $error';
  }

  @override
  String get orderConfirmedKitchen => 'Your order has been confirmed and sent to the kitchen. You can track its status below.';

  @override
  String get qrToken => 'QR Token';

  @override
  String get tableNumberLabel => 'Table Number';

  @override
  String get tableNotFound => 'Table not found';

  @override
  String tableLookupError(Object error) {
    return 'Error fetching table: $error';
  }

  @override
  String get noTableSelected => 'No table selected';

  @override
  String get orderField => 'Order';

  @override
  String get orderHeader => 'Order #';

  @override
  String get currentStatus => 'Current';

  @override
  String loginErrorDetailed(Object error) {
    return 'Login error: $error';
  }

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get qrScanningNotSupportedOnWeb => 'QR scanning not supported on web';
}
