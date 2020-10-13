// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppDirectoryModel _$AppDirectoryModelFromJson(Map<String, dynamic> json) {
  return AppDirectoryModel(
    items: (json['items'] as List)
        .map((e) => AppDirectoryItemModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$AppDirectoryModelToJson(AppDirectoryModel instance) =>
    <String, dynamic>{
      'items': instance.items,
    };

AppDirectoryItemModel _$AppDirectoryItemModelFromJson(
    Map<String, dynamic> json) {
  return AppDirectoryItemModel(
    url: json['url'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    logo_url: json['logo_url'] as String,
  );
}

Map<String, dynamic> _$AppDirectoryItemModelToJson(
        AppDirectoryItemModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'name': instance.name,
      'description': instance.description,
      'logo_url': instance.logo_url,
    };

BitmioTheme _$BitmioThemeFromJson(Map<String, dynamic> json) {
  return BitmioTheme(
    id: json['id'] as String,
    state_url: json['state_url'] as String,
    name: json['name'] as String,
    domain: json['domain'] as String,
    primary_color: json['primary_color'] as String,
    has_app_switcher: json['has_app_switcher'] as bool,
    logo_url: json['logo_url'] as String,
    app_directory_url: json['app_directory_url'] as String,
    sidebar: (json['sidebar'] as List)
        .map((e) => NavigationSection.fromJson(e as Map<String, dynamic>))
        .toList(),
    tabs: (json['tabs'] as List)
        .map((e) => PageModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    onboarding:
        OnboardingTheme.fromJson(json['onboarding'] as Map<String, dynamic>),
    welcome: WelcomeTheme.fromJson(json['welcome'] as Map<String, dynamic>),
    login: LoginTheme.fromJson(json['login'] as Map<String, dynamic>),
    signup: SignupTheme.fromJson(json['signup'] as Map<String, dynamic>),
    contacts: ContactsTheme.fromJson(json['contacts'] as Map<String, dynamic>),
    documents:
        DocumentsTheme.fromJson(json['documents'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BitmioThemeToJson(BitmioTheme instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state_url': instance.state_url,
      'name': instance.name,
      'domain': instance.domain,
      'primary_color': instance.primary_color,
      'logo_url': instance.logo_url,
      'has_app_switcher': instance.has_app_switcher,
      'app_directory_url': instance.app_directory_url,
      'sidebar': instance.sidebar,
      'tabs': instance.tabs,
      'onboarding': instance.onboarding,
      'welcome': instance.welcome,
      'login': instance.login,
      'signup': instance.signup,
      'contacts': instance.contacts,
      'documents': instance.documents,
    };

NavigationSection _$NavigationSectionFromJson(Map<String, dynamic> json) {
  return NavigationSection(
    title: json['title'] as String,
    items: (json['items'] as List)
        .map((e) => PageModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$NavigationSectionToJson(NavigationSection instance) =>
    <String, dynamic>{
      'title': instance.title,
      'items': instance.items,
    };

PageModel _$PageModelFromJson(Map<String, dynamic> json) {
  return PageModel(
    url: json['url'] as String,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    icon: json['icon'] as String,
    widget: json['widget'] as String,
    data: json['data'] as String,
  );
}

Map<String, dynamic> _$PageModelToJson(PageModel instance) => <String, dynamic>{
      'url': instance.url,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'icon': instance.icon,
      'widget': instance.widget,
      'data': instance.data,
    };

OnboardingTheme _$OnboardingThemeFromJson(Map<String, dynamic> json) {
  return OnboardingTheme(
    continue_label: json['continue_label'] as String,
    skip_label: json['skip_label'] as String,
    start_label: json['start_label'] as String,
    items: (json['items'] as List)
        .map((e) => OnboardingItemTheme.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$OnboardingThemeToJson(OnboardingTheme instance) =>
    <String, dynamic>{
      'continue_label': instance.continue_label,
      'skip_label': instance.skip_label,
      'start_label': instance.start_label,
      'items': instance.items,
    };

OnboardingItemTheme _$OnboardingItemThemeFromJson(Map<String, dynamic> json) {
  return OnboardingItemTheme(
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    background_image_url: json['background_image_url'] as String,
    background_color: json['background_color'] as String,
  );
}

Map<String, dynamic> _$OnboardingItemThemeToJson(
        OnboardingItemTheme instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subtitle': instance.subtitle,
      'background_image_url': instance.background_image_url,
      'background_color': instance.background_color,
    };

WelcomeTheme _$WelcomeThemeFromJson(Map<String, dynamic> json) {
  return WelcomeTheme(
    hero_title: json['hero_title'] as String,
    login_button_title: json['login_button_title'] as String,
    signup_button_title: json['signup_button_title'] as String,
    discover_button_title: json['discover_button_title'] as String,
    background_image_url: json['background_image_url'] as String,
  );
}

Map<String, dynamic> _$WelcomeThemeToJson(WelcomeTheme instance) =>
    <String, dynamic>{
      'hero_title': instance.hero_title,
      'login_button_title': instance.login_button_title,
      'signup_button_title': instance.signup_button_title,
      'discover_button_title': instance.discover_button_title,
      'background_image_url': instance.background_image_url,
    };

LoginTheme _$LoginThemeFromJson(Map<String, dynamic> json) {
  return LoginTheme(
    login_button_title: json['login_button_title'] as String,
    forgot_login_button_title: json['forgot_login_button_title'] as String,
  );
}

Map<String, dynamic> _$LoginThemeToJson(LoginTheme instance) =>
    <String, dynamic>{
      'login_button_title': instance.login_button_title,
      'forgot_login_button_title': instance.forgot_login_button_title,
    };

SignupTheme _$SignupThemeFromJson(Map<String, dynamic> json) {
  return SignupTheme(
    signup_button_title: json['signup_button_title'] as String,
    privacy_link_title: json['privacy_link_title'] as String,
    privacy_link: json['privacy_link'] as String,
  );
}

Map<String, dynamic> _$SignupThemeToJson(SignupTheme instance) =>
    <String, dynamic>{
      'signup_button_title': instance.signup_button_title,
      'privacy_link_title': instance.privacy_link_title,
      'privacy_link': instance.privacy_link,
    };

ContactsTheme _$ContactsThemeFromJson(Map<String, dynamic> json) {
  return ContactsTheme(
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$ContactsThemeToJson(ContactsTheme instance) =>
    <String, dynamic>{
      'title': instance.title,
    };

DocumentsTheme _$DocumentsThemeFromJson(Map<String, dynamic> json) {
  return DocumentsTheme(
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$DocumentsThemeToJson(DocumentsTheme instance) =>
    <String, dynamic>{
      'title': instance.title,
    };
