import 'dart:convert';

import 'package:equatable/equatable.dart';

class Help extends Equatable {
  final String? privacyUrl;
  final String? termsUrl;
  final String? websiteUrl;
  final String? faqUrl;
  final String? email;
  final String? phoneNumber;
  final String? formId;
  final dynamic form;
  final String? descrption;
  final String? whatsApp;
  final String? linkGHCard;

  const Help({
    this.privacyUrl,
    this.termsUrl,
    this.websiteUrl,
    this.faqUrl,
    this.email,
    this.phoneNumber,
    this.formId,
    this.form,
    this.descrption,
    this.whatsApp,
    this.linkGHCard,
  });

  factory Help.fromMap(Map<String, dynamic> data) => Help(
        privacyUrl: data['privacyUrl'] as String?,
        termsUrl: data['termsUrl'] as String?,
        websiteUrl: data['websiteUrl'] as String?,
        faqUrl: data['faqUrl'] as String?,
        email: data['email'] as String?,
        phoneNumber: data['phoneNumber'] as String?,
        formId: data['formId'] as String?,
        form: data['form'] as dynamic,
        descrption: data['descrption'] as String?,
        whatsApp: data['whatsApp'] as String?,
        linkGHCard: data['linkGHCard'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'privacyUrl': privacyUrl,
        'termsUrl': termsUrl,
        'websiteUrl': websiteUrl,
        'faqUrl': faqUrl,
        'email': email,
        'phoneNumber': phoneNumber,
        'formId': formId,
        'form': form,
        'descrption': descrption,
        'whatsApp': whatsApp,
        'linkGHCard': linkGHCard,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Help].
  factory Help.fromJson(String data) {
    return Help.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Help] to a JSON string.
  String toJson() => json.encode(toMap());

  Help copyWith({
    String? privacyUrl,
    String? termsUrl,
    String? websiteUrl,
    String? faqUrl,
    String? email,
    String? phoneNumber,
    String? formId,
    dynamic form,
    String? descrption,
    String? whatsApp,
    String? linkGHCard,
  }) {
    return Help(
      privacyUrl: privacyUrl ?? this.privacyUrl,
      termsUrl: termsUrl ?? this.termsUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      faqUrl: faqUrl ?? this.faqUrl,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      formId: formId ?? this.formId,
      form: form ?? this.form,
      descrption: descrption ?? this.descrption,
      whatsApp: whatsApp ?? this.whatsApp,
      linkGHCard: linkGHCard ?? this.linkGHCard,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      privacyUrl,
      termsUrl,
      websiteUrl,
      faqUrl,
      email,
      phoneNumber,
      formId,
      form,
      descrption,
      whatsApp,
      linkGHCard,
    ];
  }
}