import 'package:flutter/material.dart';

/// Centralized app strings supporting pt-BR and en.
///
/// Usage: `AppStrings.of(context).welcome` or `AppStrings.of(context).trackYourPackage`
class AppStrings {
  final Locale locale;

  const AppStrings(this.locale);

  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings)!;
  }

  static const LocalizationsDelegate<AppStrings> delegate =
      _AppStringsDelegate();

  // ── Getters ──────────────────────────────────────────────────────────

  String get welcome => _map('welcome');
  String get welcomeBack => _map('welcomeBack');
  String get andrewHawkins => _map('andrewHawkins');
  String get trackYourPackage => _map('trackYourPackage');
  String get allPackagesOnePlace => _map('allPackagesOnePlace');
  String get trackingByParcel => _map('trackingByParcel');
  String get pickUp => _map('pickUp');
  String get packageClaim => _map('packageClaim');
  String get allPackages => _map('allPackages');
  String get international => _map('international');
  String get postNordParcel => _map('postNordParcel');
  String get seeAll => _map('seeAll');
  String get buyPostage => _map('buyPostage');
  String get destination => _map('destination');
  String get denmark => _map('denmark');
  String get shippingOptions => _map('shippingOptions');
  String get letter => _map('letter');
  String get parcel => _map('parcel');
  String get postcards => _map('postcards');
  String get fromDkk => _map('fromDkk');
  String get support => _map('support');
  String get chat => _map('chat');
  String get faq => _map('faq');
  String get logInMitId => _map('logInMitId');
  String get accessChat => _map('accessChat');
  String get startedNewChat => _map('startedNewChat');
  String get searchPackages => _map('searchPackages');
  String get profile => _map('profile');
  String get profileComingSoon => _map('profileComingSoon');
  String get myPackages => _map('myPackages');
  String get refresh => _map('refresh');
  String get searchByCode => _map('searchByCode');
  String get addPackage => _map('addPackage');
  String get add => _map('add');
  String get cancel => _map('cancel');
  String get trackingCode => _map('trackingCode');
  String get remove => _map('remove');
  String get noPackages => _map('noPackages');
  String get noResults => _map('noResults');
  String get tryDifferent => _map('tryDifferent');
  String get addFirstCode => _map('addFirstCode');
  String get packageInfo => _map('packageInfo');
  String get description => _map('description');
  String get code => _map('code');
  String get origin => _map('origin');
  String get trackingHistory => _map('trackingHistory');
  String get noEvents => _map('noEvents');
  String get errorPageNotFound => _map('errorPageNotFound');
  String get backToHome => _map('backToHome');
  String get languageSelection => _map('languageSelection');
  String get selectLanguage => _map('selectLanguage');
  String get portuguese => _map('portuguese');
  String get english => _map('english');
  String get loginTitle => _map('loginTitle');
  String get loginSubtitle => _map('loginSubtitle');
  String get nameHint => _map('nameHint');
  String get emailHint => _map('emailHint');
  String get startTracking => _map('startTracking');
  String get nameRequired => _map('nameRequired');
  String get skip => _map('skip');
  String get next => _map('next');
  String get getStarted => _map('getStarted');
  String get welcomePage1Title => _map('welcomePage1Title');
  String get welcomePage1Desc => _map('welcomePage1Desc');
  String get welcomePage2Title => _map('welcomePage2Title');
  String get welcomePage2Desc => _map('welcomePage2Desc');
  String get welcomePage3Title => _map('welcomePage3Title');
  String get welcomePage3Desc => _map('welcomePage3Desc');

  // ── TAREFA 1a: Novas strings ─────────────────────────────────────────

  String get homeWelcomeBack => _map('homeWelcomeBack');
  String get homeTrackYourPackage => _map('homeTrackYourPackage');
  String get homeAllPackagesOnePlace => _map('homeAllPackagesOnePlace');
  String get homeTrackingByParcel => _map('homeTrackingByParcel');
  String get homePostNordParcel => _map('homePostNordParcel');
  String get homeSeeAll => _map('homeSeeAll');
  String get filterPending => _map('filterPending');
  String get filterOutForDelivery => _map('filterOutForDelivery');
  String get filterDelivered => _map('filterDelivered');
  String get filterArchived => _map('filterArchived');
  String get homeNoPackagesYet => _map('homeNoPackagesYet');
  String get homeStartTrackingYourFirst => _map('homeStartTrackingYourFirst');
  String get homeNoNotifications => _map('homeNoNotifications');
  String get trackingTitle => _map('trackingTitle');
  String get trackingRefresh => _map('trackingRefresh');
  String get trackingSearchHint => _map('trackingSearchHint');
  String get trackingAddPackage => _map('trackingAddPackage');
  String get trackingAddPackageName => _map('trackingAddPackageName');
  String get trackingAddPackageNameHint => _map('trackingAddPackageNameHint');
  String get trackingAddTags => _map('trackingAddTags');
  String get trackingAddTagHint => _map('trackingAddTagHint');
  String get trackingCodeRequired => _map('trackingCodeRequired');
  String get trackingTrackingCode => _map('trackingTrackingCode');
  String get trackingAdd => _map('trackingAdd');
  String get trackingCancel => _map('trackingCancel');
  String get trackingRemove => _map('trackingRemove');
  String get trackingLastUpdate => _map('trackingLastUpdate');
  String get trackingNoResults => _map('trackingNoResults');
  String get trackingNoPackagesYet => _map('trackingNoPackagesYet');
  String get trackingTryDifferent => _map('trackingTryDifferent');
  String get trackingAddFirstCode => _map('trackingAddFirstCode');
  String get searchTitle => _map('searchTitle');
  String get searchHint => _map('searchHint');
  String get searchDescription => _map('searchDescription');
  String get supportTitle => _map('supportTitle');
  String get supportLoginForChat => _map('supportLoginForChat');
  String get supportAccessChat => _map('supportAccessChat');
  String get supportStartNewChat => _map('supportStartNewChat');
  String get supportComingSoon => _map('supportComingSoon');
  String get buyPostageTitle => _map('buyPostageTitle');
  String get buyPostageDestination => _map('buyPostageDestination');
  String get buyPostageDenmark => _map('buyPostageDenmark');
  String get buyPostageShippingOptions => _map('buyPostageShippingOptions');
  String get buyPostageLetter => _map('buyPostageLetter');
  String get buyPostageLetterDesc => _map('buyPostageLetterDesc');
  String get buyPostageParcel => _map('buyPostageParcel');
  String get buyPostageParcelDesc => _map('buyPostageParcelDesc');
  String get buyPostagePostcards => _map('buyPostagePostcards');
  String get buyPostagePostcardsDesc => _map('buyPostagePostcardsDesc');
  String get buyPostageFrom => _map('buyPostageFrom');
  String get profileTitle => _map('profileTitle');
  String get profileSettingsSoon => _map('profileSettingsSoon');
  String get profileWorkingOnIt => _map('profileWorkingOnIt');
  String get profileLogout => _map('profileLogout');
  String get profileLogoutConfirm => _map('profileLogoutConfirm');
  String get profileLogoutSuccess => _map('profileLogoutSuccess');
  String get navHome => _map('navHome');
  String get navMarket => _map('navMarket');
  String get navChat => _map('navChat');
  String get navProfile => _map('navProfile');
  String get navSearchAccessibility => _map('navSearchAccessibility');
  String get splashSubtitle => _map('splashSubtitle');
  String get emailLabel => _map('emailLabel');
  String get passwordLabel => _map('passwordLabel');
  String get confirmPasswordLabel => _map('confirmPasswordLabel');
  String get nameLabel => _map('nameLabel');
  String get invalidEmail => _map('invalidEmail');
  String get invalidPassword => _map('invalidPassword');
  String get passwordsDoNotMatch => _map('passwordsDoNotMatch');
  String get fieldRequired => _map('fieldRequired');
  String get createAccount => _map('createAccount');
  String get createAccountSubtitle => _map('createAccountSubtitle');
  String get registerButton => _map('registerButton');
  String get registerSuccess => _map('registerSuccess');
  String get loginButton => _map('loginButton');
  String get loginError => _map('loginError');
  String get noAccount => _map('noAccount');
  String get hasAccount => _map('hasAccount');
  String get errorTitle => _map('errorTitle');
  String get back => _map('back');
  String get menu => _map('menu');

  // ── Theme Mode strings ────────────────────────────────────────────────
  String get themeMode => _map('themeMode');
  String get themeSystem => _map('themeSystem');
  String get themeLight => _map('themeLight');
  String get themeDark => _map('themeDark');

  // ── TAREFA 2: Edit / Archive / Delete strings ─────────────────────────

  String get homeViewDetails => _map('homeViewDetails');
  String get homeEdit => _map('homeEdit');
  String get homeArchive => _map('homeArchive');
  String get homeUnarchive => _map('homeUnarchive');
  String get homeDelete => _map('homeDelete');
  String get homeConfirmDelete => _map('homeConfirmDelete');
  String get homePackageArchived => _map('homePackageArchived');
  String get homePackageUnarchived => _map('homePackageUnarchived');
  String get homePackageDeleted => _map('homePackageDeleted');
  String get trackingEditPackage => _map('trackingEditPackage');
  String get trackingSave => _map('trackingSave');
  String get trackingPackageNotFound => _map('trackingPackageNotFound');
  String get trackingNoEvents => _map('trackingNoEvents');
  String get trackingInfo => _map('trackingInfo');
  String get trackingDescription => _map('trackingDescription');
  String get trackingOrigin => _map('trackingOrigin');
  String get trackingDestination => _map('trackingDestination');
  String get trackingDetailLastUpdate => _map('trackingDetailLastUpdate');
  String get trackingUpdated => _map('trackingUpdated');
  String get registerDuplicateEmail => _map('registerDuplicateEmail');
  String get registerGenericError => _map('registerGenericError');

  // ── Lookup ───────────────────────────────────────────────────────────

  String _map(String key) {
    final isEn = locale.languageCode == 'en';
    return isEn ? _en[key]! : _pt[key]!;
  }

  static const Map<String, String> _pt = {
    'welcome': 'Bem-vindo',
    'welcomeBack': 'Bem-vindo de volta',
    'andrewHawkins': 'Andrew Hawkins',
    'trackYourPackage': 'Rastreie seu pacote',
    'allPackagesOnePlace': 'Todos os seus pacotes em um só lugar.',
    'trackingByParcel': 'Rastrear por código',
    'pickUp': 'Coleta',
    'packageClaim': 'Reclamação',
    'allPackages': 'Todos',
    'international': 'Internacional',
    'postNordParcel': 'Encomendas PostNord',
    'seeAll': 'Ver todos',
    'buyPostage': 'Comprar Postagem',
    'destination': 'Destino',
    'denmark': 'Dinamarca',
    'shippingOptions': 'Opções de envio',
    'letter': 'Carta',
    'parcel': 'Pacote',
    'postcards': 'Cartão Postal',
    'fromDkk': 'A partir de',
    'support': 'Suporte',
    'chat': 'Chat',
    'faq': 'FAQ',
    'logInMitId': 'Faça login com MitID para chat.',
    'accessChat': 'Acesse o chat e recursos fazendo login com MitID.',
    'startedNewChat': 'Iniciar novo chat',
    'searchPackages': 'Buscar pacotes',
    'profile': 'Perfil',
    'profileComingSoon': 'Configurações de perfil em breve.',
    'myPackages': 'Meus Pacotes',
    'refresh': 'Atualizar',
    'searchByCode': 'Buscar por código ou descrição',
    'addPackage': 'Adicionar pacote',
    'add': 'Adicionar',
    'cancel': 'Cancelar',
    'trackingCode': 'Código de rastreio',
    'remove': 'Remover',
    'noPackages': 'Nenhum pacote ainda',
    'noResults': 'Nenhum resultado encontrado',
    'tryDifferent': 'Tente buscar por um código ou descrição diferente.',
    'addFirstCode': 'Adicione seu primeiro código de rastreio para começar.',
    'packageInfo': 'Informações',
    'description': 'Descrição',
    'code': 'Código',
    'origin': 'Origem',
    'trackingHistory': 'Histórico de rastreio',
    'noEvents': 'Nenhum evento registrado.',
    'errorPageNotFound': 'Página não encontrada',
    'backToHome': 'Voltar ao início',
    'languageSelection': 'Selecionar Idioma',
    'selectLanguage': 'Escolha seu idioma preferido',
    'portuguese': 'Português (Brasil)',
    'english': 'English',
    'loginTitle': 'Entre para começar',
    'loginSubtitle': 'Digite seu nome para começar a rastrear suas encomendas.',
    'nameHint': 'Seu nome',
    'emailHint': 'Seu e-mail (opcional)',
    'startTracking': 'Começar a rastrear',
    'nameRequired': 'Por favor, digite seu nome.',
    'skip': 'Pular',
    'next': 'Próximo',
    'getStarted': 'Começar',
    'welcomePage1Title': 'Rastreie seus Pacotes',
    'welcomePage1Desc': 'Adicione códigos de rastreio e acompanhe\nsuas encomendas em cada etapa —\ndo envio até a entrega.',
    'welcomePage2Title': 'Escolha seu Idioma',
    'welcomePage2Desc': 'Use o app em Português (Brasil) ou Inglês.\nAltere a qualquer momento nas configurações.',
    'welcomePage3Title': 'Obtenha Suporte',
    'welcomePage3Desc': 'Precisa de ajuda? Acesse nosso chat de\nsuporte e FAQ para respostas rápidas.',
    'homeWelcomeBack': 'Bem-vindo de volta,',
    'homeTrackYourPackage': 'Rastreie seu Pacote',
    'homeAllPackagesOnePlace': 'Todos os seus pacotes em um só lugar.',
    'homeTrackingByParcel': 'Rastrear por código',
    'homePostNordParcel': 'Encomendas PostNord',
    'homeSeeAll': 'Ver todos',
    'filterPending': 'Pendentes',
    'filterOutForDelivery': 'Pra Entregar',
    'filterDelivered': 'Entregues',
    'filterArchived': 'Arquivados',
    'homeNoPackagesYet': 'Nenhum pacote ainda',
    'homeStartTrackingYourFirst': 'Comece a rastrear seu primeiro pacote!',
    'homeNoNotifications': 'Nenhuma notificação',
    'trackingTitle': 'Meus Pacotes',
    'trackingRefresh': 'Atualizar',
    'trackingSearchHint': 'Buscar por código ou descrição',
    'trackingAddPackage': 'Adicionar pacote',
    'trackingAddPackageName': 'Nome do pacote',
    'trackingAddPackageNameHint': 'Ex: Fones Bluetooth',
    'trackingAddTags': 'Tags',
    'trackingAddTagHint': 'Digite e pressione Enter',
    'trackingCodeRequired': 'Código de rastreio é obrigatório',
    'trackingTrackingCode': 'Código de rastreio',
    'trackingAdd': 'Adicionar',
    'trackingCancel': 'Cancelar',
    'trackingRemove': 'Remover',
    'trackingLastUpdate': 'Última atualização:',
    'trackingNoResults': 'Nenhum resultado encontrado',
    'trackingNoPackagesYet': 'Nenhum pacote ainda',
    'trackingTryDifferent': 'Tente buscar por um código ou descrição diferente.',
    'trackingAddFirstCode': 'Adicione seu primeiro código de rastreio para começar.',
    'searchTitle': 'Buscar',
    'searchHint': 'Buscar pacotes',
    'searchDescription': 'Encontre seus pacotes por código ou descrição.',
    'supportTitle': 'Suporte',
    'supportLoginForChat': 'Faça login com MitID para usar o chat.',
    'supportAccessChat': 'Acesse o chat e recursos fazendo login com MitID.',
    'supportStartNewChat': 'Iniciar novo chat',
    'supportComingSoon': 'Chat em breve!',
    'buyPostageTitle': 'Comprar Postagem',
    'buyPostageDestination': 'Destino',
    'buyPostageDenmark': 'Dinamarca',
    'buyPostageShippingOptions': 'Opções de Envio',
    'buyPostageLetter': 'Carta',
    'buyPostageLetterDesc': 'Documentos e itens pequenos até 2 kg. Entrega em 3-5 dias úteis.',
    'buyPostageParcel': 'Pacote',
    'buyPostageParcelDesc': 'Pacotes até 30 kg. Entrega em 1-3 dias úteis com rastreio.',
    'buyPostagePostcards': 'Cartão Postal',
    'buyPostagePostcardsDesc': 'Cartões postais e pequenos presentes até 0.5 kg. Entrega em 5-7 dias úteis.',
    'buyPostageFrom': 'A partir de',
    'profileTitle': 'Perfil',
    'profileSettingsSoon': 'Configurações de perfil em breve.',
    'profileWorkingOnIt': 'Estamos trabalhando nisso!',
    'profileLogout': 'Sair',
    'profileLogoutConfirm': 'Tem certeza que deseja sair?',
    'profileLogoutSuccess': 'Você saiu da sua conta.',
    'navHome': 'Início',
    'navMarket': 'Promoções',
    'navChat': 'Chat',
    'navProfile': 'Perfil',
    'navSearchAccessibility': 'Buscar',
    'splashSubtitle': 'Rastreador de Pacotes',
    'emailLabel': 'Email',
    'passwordLabel': 'Senha',
    'confirmPasswordLabel': 'Repetir Senha',
    'nameLabel': 'Nome',
    'invalidEmail': 'Email inválido',
    'invalidPassword': 'Mínimo de 6 caracteres',
    'passwordsDoNotMatch': 'Senhas não conferem',
    'fieldRequired': 'Campo obrigatório',
    'createAccount': 'Criar Conta',
    'createAccountSubtitle': 'Preencha os dados para se cadastrar',
    'registerButton': 'Cadastrar',
    'registerSuccess': 'Conta criada com sucesso! Faça login.',
    'loginButton': 'Entrar',
    'loginError': 'Email ou senha inválidos',
    'noAccount': 'Não tem conta? Cadastre-se',
    'hasAccount': 'Já tem conta? Faça login',
    'errorTitle': 'Erro',
    'homeViewDetails': 'Ver Detalhes',
    'homeEdit': 'Editar',
    'homeArchive': 'Arquivar',
    'homeUnarchive': 'Desarquivar',
    'homeDelete': 'Excluir',
    'homeConfirmDelete': 'Tem certeza que deseja excluir este pacote?',
    'homePackageArchived': 'Pacote arquivado',
    'homePackageUnarchived': 'Pacote restaurado',
    'homePackageDeleted': 'Pacote excluído',
    'trackingEditPackage': 'Editar pacote',
    'trackingSave': 'Salvar',
    'trackingPackageNotFound': 'Pacote não encontrado na lista.',
    'trackingNoEvents': 'Nenhum evento registrado.',
    'trackingInfo': 'Informações',
    'trackingDescription': 'Descrição',
    'trackingOrigin': 'Origem',
    'trackingDestination': 'Destino',
    'trackingDetailLastUpdate': 'Última atualização',
    'trackingUpdated': 'Atualizado',
    'registerDuplicateEmail': 'Este email já está cadastrado.',
    'registerGenericError': 'Falha ao criar conta. Tente novamente.',
    'back': 'Voltar',
    'menu': 'Menu',
    'themeMode': 'Modo do Tema',
    'themeSystem': 'Sistema',
    'themeLight': 'Claro',
    'themeDark': 'Escuro',
  };

  static const Map<String, String> _en = {
    'welcome': 'Welcome',
    'welcomeBack': 'Welcome back',
    'andrewHawkins': 'Andrew Hawkins',
    'trackYourPackage': 'Track your Package',
    'allPackagesOnePlace': 'All your packages in one place.',
    'trackingByParcel': 'Tracking by parcel',
    'pickUp': 'Pick Up',
    'packageClaim': 'Package Claim',
    'allPackages': 'All Packages',
    'international': 'International',
    'postNordParcel': 'PostNord Parcels',
    'seeAll': 'See all',
    'buyPostage': 'Buy Postage',
    'destination': 'Destination',
    'denmark': 'Denmark',
    'shippingOptions': 'Shipping Options',
    'letter': 'Letter',
    'parcel': 'Parcel',
    'postcards': 'Postcards',
    'fromDkk': 'From',
    'support': 'Support',
    'chat': 'Chat',
    'faq': 'FAQ',
    'logInMitId': 'Log in with MitID for chat.',
    'accessChat': 'Access chat and features log in with MitID.',
    'startedNewChat': 'Started new chat',
    'searchPackages': 'Search packages',
    'profile': 'Profile',
    'profileComingSoon': 'Profile settings coming soon.',
    'myPackages': 'My Packages',
    'refresh': 'Refresh',
    'searchByCode': 'Search by code or description',
    'addPackage': 'Add package',
    'add': 'Add',
    'cancel': 'Cancel',
    'trackingCode': 'Tracking code',
    'remove': 'Remove',
    'noPackages': 'No packages yet',
    'noResults': 'No results found',
    'tryDifferent': 'Try a different code or description.',
    'addFirstCode': 'Add your first tracking code to get started.',
    'packageInfo': 'Package Info',
    'description': 'Description',
    'code': 'Code',
    'origin': 'Origin',
    'trackingHistory': 'Tracking History',
    'noEvents': 'No events recorded.',
    'errorPageNotFound': 'Page not found',
    'backToHome': 'Back to home',
    'languageSelection': 'Select Language',
    'selectLanguage': 'Choose your preferred language',
    'portuguese': 'Português (Brasil)',
    'english': 'English',
    'loginTitle': 'Sign in to start',
    'loginSubtitle': 'Enter your name to start tracking your packages.',
    'nameHint': 'Your name',
    'emailHint': 'Your email (optional)',
    'startTracking': 'Start Tracking',
    'nameRequired': 'Please enter your name.',
    'skip': 'Skip',
    'next': 'Next',
    'getStarted': 'Get Started',
    'welcomePage1Title': 'Track Your Packages',
    'welcomePage1Desc': 'Add tracking codes and follow your packages\nevery step of the way — from dispatch to delivery.',
    'welcomePage2Title': 'Choose Your Language',
    'welcomePage2Desc': 'Use the app in Portuguese (Brazil) or English.\nChange anytime in settings.',
    'welcomePage3Title': 'Get Support',
    'welcomePage3Desc': 'Need help? Access our support chat and FAQ\nto get answers quickly.',
    'homeWelcomeBack': 'Welcome back,',
    'homeTrackYourPackage': 'Track your Package',
    'homeAllPackagesOnePlace': 'All your packages in one place.',
    'homeTrackingByParcel': 'Tracking by parcel',
    'homePostNordParcel': 'PostNord parcels',
    'homeSeeAll': 'See all',
    'filterPending': 'Pending',
    'filterOutForDelivery': 'Out for Delivery',
    'filterDelivered': 'Delivered',
    'filterArchived': 'Archived',
    'homeNoPackagesYet': 'No packages yet',
    'homeStartTrackingYourFirst': 'Start tracking your first package!',
    'homeNoNotifications': 'No new notifications',
    'trackingTitle': 'My Packages',
    'trackingRefresh': 'Refresh',
    'trackingSearchHint': 'Search by code or description',
    'trackingAddPackage': 'Add package',
    'trackingAddPackageName': 'Package name',
    'trackingAddPackageNameHint': 'E.g. Bluetooth headphones',
    'trackingAddTags': 'Tags',
    'trackingAddTagHint': 'Type and press Enter',
    'trackingCodeRequired': 'Tracking code is required',
    'trackingTrackingCode': 'Tracking code',
    'trackingAdd': 'Add',
    'trackingCancel': 'Cancel',
    'trackingRemove': 'Remove',
    'trackingLastUpdate': 'Last update:',
    'trackingNoResults': 'No results found',
    'trackingNoPackagesYet': 'No packages yet',
    'trackingTryDifferent': 'Try a different code or description.',
    'trackingAddFirstCode': 'Add your first tracking code to get started.',
    'searchTitle': 'Search',
    'searchHint': 'Search packages',
    'searchDescription': 'Find your packages by tracking code or description.',
    'supportTitle': 'Support',
    'supportLoginForChat': 'Log in with MitID for chat.',
    'supportAccessChat': 'Access chat and features by logging in with MitID.',
    'supportStartNewChat': 'Start new chat',
    'supportComingSoon': 'Chat feature coming soon!',
    'buyPostageTitle': 'Buy Postage',
    'buyPostageDestination': 'Destination',
    'buyPostageDenmark': 'Denmark',
    'buyPostageShippingOptions': 'Shipping Options',
    'buyPostageLetter': 'Letter',
    'buyPostageLetterDesc': 'Documents and small items up to 2 kg. Delivery in 3-5 business days.',
    'buyPostageParcel': 'Parcel',
    'buyPostageParcelDesc': 'Packages up to 30 kg. Delivery in 1-3 business days with tracking.',
    'buyPostagePostcards': 'Postcards',
    'buyPostagePostcardsDesc': 'Postcards and small gifts up to 0.5 kg. Delivery in 5-7 business days.',
    'buyPostageFrom': 'From',
    'profileTitle': 'Profile',
    'profileSettingsSoon': 'Profile settings coming soon.',
    'profileWorkingOnIt': "We're working on it!",
    'profileLogout': 'Log out',
    'profileLogoutConfirm': 'Are you sure you want to log out?',
    'profileLogoutSuccess': 'You have been logged out.',
    'navHome': 'Home',
    'navMarket': 'Promotions',
    'navChat': 'Chat',
    'navProfile': 'Profile',
    'navSearchAccessibility': 'Search',
    'splashSubtitle': 'Package Tracker',
    'emailLabel': 'Email',
    'passwordLabel': 'Password',
    'confirmPasswordLabel': 'Confirm Password',
    'nameLabel': 'Name',
    'invalidEmail': 'Invalid email',
    'invalidPassword': 'Minimum 6 characters',
    'passwordsDoNotMatch': 'Passwords do not match',
    'fieldRequired': 'This field is required',
    'createAccount': 'Create Account',
    'createAccountSubtitle': 'Fill in your details to register',
    'registerButton': 'Register',
    'registerSuccess': 'Account created successfully! Please log in.',
    'loginButton': 'Log in',
    'loginError': 'Invalid email or password',
    'noAccount': "Don't have an account? Sign up",
    'hasAccount': 'Already have an account? Log in',
    'errorTitle': 'Error',
    'homeViewDetails': 'View Details',
    'homeEdit': 'Edit',
    'homeArchive': 'Archive',
    'homeUnarchive': 'Unarchive',
    'homeDelete': 'Delete',
    'homeConfirmDelete': 'Are you sure you want to delete this package?',
    'homePackageArchived': 'Package archived',
    'homePackageUnarchived': 'Package restored',
    'homePackageDeleted': 'Package deleted',
    'trackingEditPackage': 'Edit package',
    'trackingSave': 'Save',
    'trackingPackageNotFound': 'Package not found in list.',
    'trackingNoEvents': 'No events recorded.',
    'trackingInfo': 'Information',
    'trackingDescription': 'Description',
    'trackingOrigin': 'Origin',
    'trackingDestination': 'Destination',
    'trackingDetailLastUpdate': 'Last update',
    'trackingUpdated': 'Updated',
    'registerDuplicateEmail': 'This email is already registered.',
    'registerGenericError': 'Failed to create account. Try again.',
    'back': 'Back',
    'menu': 'Menu',
    'themeMode': 'Theme Mode',
    'themeSystem': 'System',
    'themeLight': 'Light',
    'themeDark': 'Dark',
  };
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'pt' || locale.languageCode == 'en';

  @override
  Future<AppStrings> load(Locale locale) async => AppStrings(locale);

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}
