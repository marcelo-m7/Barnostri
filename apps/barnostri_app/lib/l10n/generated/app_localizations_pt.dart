import 'app_localizations.dart';

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Barnostri';

  @override
  String get welcomeMessage => 'Bem-vindo ao Barnostri Beach Kiosk';

  @override
  String get scanQRCode => 'Escanear QR Code';

  @override
  String get scanQRCodeDescription => 'Escaneie o QR code da sua mesa para começar a fazer o pedido';

  @override
  String get adminAccess => 'Acesso Administrativo';

  @override
  String get adminAccessDescription => 'Acessar funções administrativas';

  @override
  String get menu => 'Cardápio';

  @override
  String get cart => 'Carrinho';

  @override
  String get orders => 'Pedidos';

  @override
  String get tables => 'Mesas';

  @override
  String get categories => 'Categorias';

  @override
  String get items => 'Itens';

  @override
  String get search => 'Pesquisar';

  @override
  String get searchMenuItems => 'Pesquisar itens do cardápio...';

  @override
  String get addToCart => 'Adicionar ao Carrinho';

  @override
  String get quantity => 'Quantidade';

  @override
  String get observations => 'Observações';

  @override
  String get observationsHint => 'Pedidos especiais ou observações...';

  @override
  String get price => 'Preço';

  @override
  String get total => 'Total';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get emptyCart => 'Seu carrinho está vazio';

  @override
  String get emptyCartDescription => 'Adicione itens do cardápio para começar seu pedido';

  @override
  String get startOrdering => 'Começar Pedido';

  @override
  String get paymentMethod => 'Forma de Pagamento';

  @override
  String get pix => 'Pix';

  @override
  String get card => 'Cartão';

  @override
  String get cash => 'Dinheiro';

  @override
  String get checkout => 'Finalizar Pedido';

  @override
  String get processingOrder => 'Processando Pedido...';

  @override
  String get paymentFailureRetry => 'Falha no pagamento. Tente novamente.';

  @override
  String get orderPlaced => 'Pedido Realizado!';

  @override
  String get orderPlacedDescription => 'Seu pedido foi realizado com sucesso e está sendo preparado';

  @override
  String get orderNumber => 'Número do Pedido';

  @override
  String get trackOrder => 'Acompanhar Pedido';

  @override
  String get orderReceived => 'Pedido Recebido';

  @override
  String get inPreparation => 'Em Preparo';

  @override
  String get ready => 'Pronto';

  @override
  String get delivered => 'Entregue';

  @override
  String get cancelled => 'Cancelado';

  @override
  String tableNumber(String number) {
    return 'Mesa $number';
  }

  @override
  String itemsCount(int count) {
    return '$count itens';
  }

  @override
  String get admin => 'Admin';

  @override
  String get adminTitle => 'Barnostri Admin';

  @override
  String get adminRestricted => 'Acesso restrito para funcionários';

  @override
  String get login => 'Entrar';

  @override
  String get logout => 'Sair';

  @override
  String get email => 'Email';

  @override
  String get password => 'Senha';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Senha';

  @override
  String get emailHint => 'Digite seu email';

  @override
  String get passwordHint => 'Digite sua senha';

  @override
  String get invalidEmail => 'Por favor, digite um email válido';

  @override
  String get passwordRequired => 'Senha é obrigatória';

  @override
  String get loginError => 'Falha no login. Verifique suas credenciais.';

  @override
  String get demoMode => 'Modo Demo';

  @override
  String get demoCredentials => 'Use: admin@barnostri.com / admin123';

  @override
  String get demoCredentialsTitle => 'Credenciais de demonstração:';

  @override
  String get addItem => 'Adicionar Item';

  @override
  String get editItem => 'Editar Item';

  @override
  String get deleteItem => 'Excluir Item';

  @override
  String get addCategory => 'Adicionar Categoria';

  @override
  String get editCategory => 'Editar Categoria';

  @override
  String get addTable => 'Adicionar Mesa';

  @override
  String get name => 'Nome';

  @override
  String get description => 'Descrição';

  @override
  String get category => 'Categoria';

  @override
  String get available => 'Disponível';

  @override
  String get unavailable => 'Indisponível';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Erro';

  @override
  String get success => 'Sucesso';

  @override
  String get warning => 'Aviso';

  @override
  String get close => 'Fechar';

  @override
  String get remove => 'Remover';

  @override
  String get update => 'Atualizar';

  @override
  String get back => 'Voltar';

  @override
  String get next => 'Próximo';

  @override
  String get previous => 'Anterior';

  @override
  String get loading => 'Carregando...';

  @override
  String get noItemsFound => 'Nenhum item encontrado';

  @override
  String get tryAgain => 'Tentar Novamente';

  @override
  String get scanQRTitle => 'Escanear QR Code';

  @override
  String get scanQRInstructions => 'Posicione o QR code dentro do quadro para escanear';

  @override
  String get manualEntry => 'Entrada Manual';

  @override
  String get manualEntryDescription => 'Digitar número da mesa manualmente';

  @override
  String get enterTableNumber => 'Digite o Número da Mesa';

  @override
  String get tableNumberHint => 'Digite o número da mesa (ex: 1, 2, 3...)';

  @override
  String get invalidTableNumber => 'Número da mesa inválido';

  @override
  String get orderStatus => 'Status do Pedido';

  @override
  String get orderDetails => 'Detalhes do Pedido';

  @override
  String get orderTime => 'Hora do Pedido';

  @override
  String get paymentStatus => 'Status do Pagamento';

  @override
  String get paid => 'Pago';

  @override
  String get unpaid => 'Não Pago';

  @override
  String get pending => 'Pendente';

  @override
  String get approved => 'Aprovado';

  @override
  String get updateStatus => 'Atualizar Status';

  @override
  String get markAsReady => 'Marcar como Pronto';

  @override
  String get markAsDelivered => 'Marcar como Entregue';

  @override
  String get orderUpdated => 'Status do pedido atualizado com sucesso';

  @override
  String get orderUpdateError => 'Falha ao atualizar status do pedido';

  @override
  String get orderCreationFailure => 'Falha ao criar pedido';

  @override
  String orderProcessingFailure(Object error) {
    return 'Falha ao processar pedido: $error';
  }

  @override
  String get confirmDelete => 'Tem certeza que deseja excluir este item?';

  @override
  String get deleteConfirmation => 'Confirmação de Exclusão';

  @override
  String get itemDeleted => 'Item excluído com sucesso';

  @override
  String get itemAdded => 'Item adicionado com sucesso';

  @override
  String get itemUpdated => 'Item atualizado com sucesso';

  @override
  String get categoryAdded => 'Categoria adicionada com sucesso';

  @override
  String get tableAdded => 'Mesa adicionada com sucesso';

  @override
  String get fillAllFields => 'Por favor, preencha todos os campos obrigatórios';

  @override
  String get language => 'Idioma';

  @override
  String get settings => 'Configurações';

  @override
  String get portuguese => 'Português';

  @override
  String get english => 'Inglês';

  @override
  String get french => 'Francês';

  @override
  String get demoModeCredentials => 'Modo demonstração - Configure as credenciais do Supabase para usar recursos completos';

  @override
  String get footerTagline => '🏖️ Praia • Sabor • Tradição';

  @override
  String get homeSlogan => 'Sabores únicos da praia carioca 🏖️';

  @override
  String get searchMenuPlaceholder => 'Buscar pratos e bebidas...';

  @override
  String emptyCategoryItems(String categoryName) {
    return 'Nenhum item disponível\nna categoria $categoryName';
  }

  @override
  String get errorLoadingOrders => 'Erro ao carregar pedidos';

  @override
  String get noActiveOrders => 'Nenhum pedido ativo';

  @override
  String get newOrdersAppearHere => 'Novos pedidos aparecerão aqui';

  @override
  String get adminPanel => 'Painel Administrativo';

  @override
  String get tableCode => 'Código da Mesa';

  @override
  String get tableCodePrompt => 'Digite o código que está na mesa:';

  @override
  String get tableCodeHint => 'Ex: mesa_001_qr';

  @override
  String get qrCameraInstructions => 'Aponte a câmera para o QR code';

  @override
  String get qrCodeLocation => 'Ele está localizado na sua mesa';

  @override
  String get insertCodeManually => 'Inserir código manualmente';

  @override
  String get orderItems => 'Itens do Pedido';

  @override
  String get totalItems => 'Total de Itens:';

  @override
  String get add => 'Adicionar';

  @override
  String get observationOptional => 'Observações (opcional)';

  @override
  String get observationExample => 'Ex: Sem cebola, bem passado...';

  @override
  String get itemUnavailable => 'Item Indisponível';

  @override
  String addedToCartMessage(Object item) {
    return '$item adicionado ao carrinho!';
  }

  @override
  String get adminActions => 'Ações do Administrador';

  @override
  String markAsStatus(Object status) {
    return 'Marcar como $status';
  }

  @override
  String get statusReceivedDescription => 'Pedido recebido pela cozinha';

  @override
  String get statusInPrepDescription => 'Preparando seus pratos';

  @override
  String get statusReadyDescription => 'Pedido pronto para retirada';

  @override
  String get statusDeliveredDescription => 'Pedido entregue';

  @override
  String get statusCancelledDescription => 'Pedido cancelado';

  @override
  String statusUpdated(Object status) {
    return 'Status atualizado para $status';
  }

  @override
  String statusUpdateErrorDetailed(Object error) {
    return 'Erro ao atualizar status: $error';
  }

  @override
  String get orderConfirmedKitchen => 'Seu pedido foi confirmado e enviado para a cozinha. Você pode acompanhar o status abaixo.';

  @override
  String get qrToken => 'Token QR';

  @override
  String get tableNumberLabel => 'Número da Mesa';

  @override
  String get tableNotFound => 'Mesa não encontrada';

  @override
  String tableLookupError(Object error) {
    return 'Erro ao buscar mesa: $error';
  }

  @override
  String get noTableSelected => 'Nenhuma mesa selecionada';

  @override
  String get orderField => 'Ordem';

  @override
  String get orderHeader => 'Pedido #';

  @override
  String get currentStatus => 'Atual';

  @override
  String loginErrorDetailed(Object error) {
    return 'Erro no login: $error';
  }

  @override
  String get pageNotFound => 'Página não encontrada';

  @override
  String get qrScanningNotSupportedOnWeb => 'Leitura de QR não suportada na web';

  @override
  String get loginRequired => 'É necessário fazer login para continuar';
}
