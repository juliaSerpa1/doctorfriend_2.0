import 'package:doctorfriend/components/carrosel_image.dart';
import 'package:doctorfriend/components/modal.dart';
import 'package:doctorfriend/components/row_text.dart';
import 'package:doctorfriend/screens/premium/premium_screen.dart';
import 'package:doctorfriend/screens/user/components/common_question_card.dart';
import 'package:doctorfriend/screens/user/components/evalueations_rate.dart';
import 'package:doctorfriend/screens/user/components/update_about_me.dart';
import 'package:doctorfriend/screens/user/components/update_common_questions.dart';
import 'package:doctorfriend/screens/user/components/update_contact.dart';
import 'package:doctorfriend/screens/user/components/update_diseases_treated.dart';
import 'package:doctorfriend/screens/user/components/update_experience.dart';
import 'package:doctorfriend/screens/user/components/update_health_insurance.dart';
import 'package:doctorfriend/screens/user/components/update_languages.dart';
import 'package:doctorfriend/screens/user/components/update_links.dart';
import 'package:doctorfriend/screens/user/components/update_services.dart';
import 'package:doctorfriend/screens/user/components/update_time_zone.dart';
import 'package:doctorfriend/screens/user/components/update_training.dart';
import 'package:doctorfriend/screens/user/update_address_screen.dart';
import 'package:doctorfriend/screens/user/update_images_screen.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctorfriend/components/app_image.dart';
import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final traslation = Translations.of(context).translate('user_screen');
    logout() async {
      final res = await Callback.confirm(
        context: context,
        content: "",
        title: traslation["logout_confirm"],
      );
      if (!res) return;

      await AuthService().logout();
    }

    edit(Widget screen) async {
      final bool? res = await Modal.asyncModal<bool?>(context, child: screen);
      if (res == null) return;
      if (res) {
        Callback.snackBar(context, error: false);
      } else {
        Callback.snackBar(
          context,
          title: traslation["edit_error"],
        );
      }
    }

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(traslation["title"]),
        leading: IconButton(
          onPressed: () => context.go(AppRoutesUtil.appType),
          icon: const Icon(
            Icons.home,
          ),
        ),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: StreamBuilder<AppUser?>(
        stream: AuthService().userChanges,
        builder: (context, snapshot) {
          final AppUser? user = snapshot.data;
          bool loading = snapshot.connectionState == ConnectionState.waiting;

          final error = snapshot.error;

          final String imageUrl = user?.imageUrl ?? "";

          const double size = 80.0;
          const height = 5.0;

          if (user == null) {
            return LoadingIndicator(
                loading: user == null, child: const Scaffold());
          }

          var icon = Icon(
            Icons.edit,
            color: theme.colorScheme.primary,
          );
          return LoadingIndicator(
            loading: loading,
            error: error != null,
            errorMessage: error.toString(),
            child: ListView(
              padding: const EdgeInsets.all(10.0),
              children: [
                Card(
                  color: theme.colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0),
                    child: Row(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(size / 2),
                            color: theme.colorScheme.secondary,
                          ),
                          height: size,
                          width: size,
                          child: AppImage(imageUrl: imageUrl, isCircular: true),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${user.getProfession?.name ?? ""} - ${user.getProfession != null && user.getProfession!.fieldsOfPractice.isNotEmpty ? user.getProfession?.fieldsOfPractice.first.name : ""}",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              context.push(AppRoutesUtil.updateUser),
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (user.userVerified)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(traslation["verified_profile"]),
                      ),
                      Icon(
                        Icons.verified,
                        color: theme.colorScheme.secondary,
                      ),
                    ],
                  )
                else
                  TextButton(
                    onPressed: () =>
                        context.push(AppRoutesUtil.userVerification),
                    child: Text(traslation["no_verified_profile"]),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //CONTATO
                      const Divider(height: 40),
                      Row(
                        children: [
                          Text(
                            traslation["contact"],
                            style: theme.textTheme.titleMedium,
                          ),
                          IconButton(
                              onPressed: () => edit(UpdateContact(
                                    phone: user.phone,
                                    phoneComercial: user.commercialPhone,
                                    registerNumber: user.registerNumber,
                                    pix: user.pix,
                                    registerClassOrder: user.registerClassOrder,
                                  )),
                              icon: icon),
                        ],
                      ),
                      const SizedBox(height: height),
                      RowText(
                        title: "  ${traslation["email"]} ",
                        content: user.email,
                      ),
                      const SizedBox(height: height),
                      RowText(
                        title: "  ${traslation["phone"]} ",
                        content: user.phone,
                      ),
                      const SizedBox(height: height),
                      RowText(
                        title: "  ${traslation["commercial_phone"]} ",
                        content: user.commercialPhone,
                      ),
                      const SizedBox(height: height),
                      RowText(
                        title:
                            "  ${user.registerClassOrder ?? traslation["crm"]}: ",
                        content: user.registerNumber ?? "",
                      ),
                      const SizedBox(height: height),
                      RowText(
                        title: "  ${traslation["pix"]} ",
                        content: user.pix ?? "",
                      ),

                      const Divider(height: 40), //SERVIÇOS

                      Row(
                        children: [
                          Text(
                            traslation["links"],
                            style: theme.textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: () => edit(UpdateLinks(
                              site: user.links.site ?? "",
                              facebook: user.links.facebook ?? "",
                              instagram: user.links.instagram ?? "",
                              twitter: user.links.twitter ?? "",
                            )),
                            icon: icon,
                          ),
                        ],
                      ),
                      const SizedBox(height: height),
                      RowText(
                        title: "  ${traslation["site"]} ",
                        content: user.links.site ?? "",
                      ),
                      const SizedBox(height: height),
                      RowText(
                        title: "  ${traslation["facebook"]} ",
                        content: user.links.facebook ?? "",
                      ),
                      const SizedBox(height: height),
                      RowText(
                        title: "  ${traslation["instagram"]} ",
                        content: user.links.instagram ?? "",
                      ),
                      const SizedBox(height: height),
                      RowText(
                        title: "  ${traslation["twitter"]} ",
                        content: user.links.twitter ?? "",
                      ),

                      const Divider(height: 40), //SERVIÇOS

                      Row(
                        children: [
                          Text(
                            traslation["services"],
                            style: theme.textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: () => edit(
                              UpdateServices(
                                services: user.services,
                              ),
                            ),
                            icon: icon,
                          ),
                        ],
                      ),
                      const SizedBox(height: height),
                      Column(
                        children: user.services
                            .map(
                              (val) => val.string.trim() != ""
                                  ? RowText(
                                      title: "  ",
                                      content: "* ${val.string}",
                                    )
                                  : const SizedBox(),
                            )
                            .toList(),
                      ),
                      const Divider(height: 40), //EXPERIENCIA

                      Row(
                        children: [
                          Text(
                            traslation["experience"],
                            style: theme.textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: () => edit(
                              UpdateExperience(
                                services: user.experiences,
                              ),
                            ),
                            icon: icon,
                          ),
                        ],
                      ),
                      const SizedBox(height: height),
                      Column(
                        children: user.experiences
                            .map(
                              (val) => RowText(
                                title: "  ",
                                content: "* $val",
                              ),
                            )
                            .toList(),
                      ),

                      const Divider(height: 40), // DOENCAS TRATADAS
                      Row(
                        children: [
                          Text(
                            traslation["diseases_treated"],
                            style: theme.textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: () => edit(
                              UpdateDiseasesTreated(
                                services: user.diseasesTreated,
                              ),
                            ),
                            icon: icon,
                          ),
                        ],
                      ),
                      const SizedBox(height: height),
                      Column(
                        children: user.diseasesTreated
                            .map(
                              (val) => RowText(
                                title: "  ",
                                content: "* $val",
                              ),
                            )
                            .toList(),
                      ),

                      const Divider(height: 40), //PLANOS DE SAÚDE
                      Row(
                        children: [
                          Text(
                            traslation["health_insurance"],
                            style: theme.textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: () => edit(
                              UpdateHealthInsurance(
                                services: user.healthInsurance,
                              ),
                            ),
                            icon: icon,
                          ),
                        ],
                      ),
                      const SizedBox(height: height),
                      Column(
                        children: user.healthInsurance
                            .map(
                              (val) => RowText(
                                title: "  ",
                                content: "* $val",
                              ),
                            )
                            .toList(),
                      ),

                      const Divider(height: 40), // Idiomas
                      Row(
                        children: [
                          Text(
                            traslation["languages"],
                            style: theme.textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: () => edit(
                              UpdateLanguages(
                                services: user.languages,
                              ),
                            ),
                            icon: icon,
                          ),
                        ],
                      ),
                      const SizedBox(height: height),
                      Column(
                        children: user.languages
                            .map(
                              (val) => RowText(
                                title: "  ",
                                content: "* $val",
                              ),
                            )
                            .toList(),
                      ),

                      const Divider(height: 40), //SOBRE MIM
                      Row(
                        children: [
                          Text(
                            traslation["about_me"],
                            style: theme.textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: () => edit(
                              UpdateAboutMe(text: user.aboutMe ?? ""),
                            ),
                            icon: icon,
                          ),
                        ],
                      ),
                      const SizedBox(height: height),
                      RowText(
                        title: "  ",
                        content: user.aboutMe ?? "",
                      ),
                      const Divider(height: 40), //FORMAÇÂO
                      Row(
                        children: [
                          Text(
                            traslation["training"],
                            style: theme.textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: () => edit(
                              UpdateTraining(
                                services: user.trainings,
                              ),
                            ),
                            icon: icon,
                          ),
                        ],
                      ),
                      const SizedBox(height: height),
                      Column(
                        children: user.trainings
                            .map(
                              (val) => RowText(
                                title: "  ",
                                content: "* $val",
                              ),
                            )
                            .toList(),
                      ),
                      const Divider(height: 40), //TIMEZONE
                      Row(
                        children: [
                          Text(
                            traslation["time_zone"],
                            style: theme.textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: () => edit(
                              UpdateTimeZone(
                                timeZone: user.timeZone,
                              ),
                            ),
                            icon: icon,
                          ),
                        ],
                      ),
                      const SizedBox(height: height),
                      Column(
                        children: [
                          RowText(
                            title: "  ",
                            content: "* ${user.timeZone}",
                          ),
                        ],
                      ),

                      // const Divider(height: 40), //Cidade de Atuação
                      // Row(
                      //   children: [
                      //     Text(
                      //       traslation["city"],
                      //       style: theme.textTheme.titleMedium,
                      //     ),
                      //     IconButton(
                      //       onPressed: () => Navigator.of(context).push(
                      //         MaterialPageRoute(
                      //           builder: (context) =>
                      //               const UpdateCityOfOperation(),
                      //         ),
                      //       ),
                      //       icon: icon,
                      //     ),
                      //   ],
                      // ),

                      const Divider(height: 40), //ENDEREÇO
                      Row(
                        children: [
                          Text(
                            traslation["address"],
                            style: theme.textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UpdateAddressScreen(
                                  address: user.addresses[0],
                                ),
                              ),
                            ),
                            icon: icon,
                          ),
                        ],
                      ),

                      Column(
                        children: user.addresses
                            .map(
                              (address) => RowText(
                                title: "     ",
                                content: address.addressString,
                              ),
                            )
                            .toList(),
                      ),

                      // const SizedBox(height: 20.0),
                      // LocationInput(
                      //   (LatLng latLange) {},
                      //   latLngSelected: user.address.latitude == null
                      //       ? null
                      //       : LatLng(
                      //           double.tryParse(
                      //                   user.address.latitude.toString()) ??
                      //               0,
                      //           double.tryParse(
                      //                   user.address.longitude.toString()) ??
                      //               0,
                      //         ),
                      //   viewOnly: true,
                      // ),

                      const Divider(height: 40), //ENDEREÇO
                      Row(
                        children: [
                          Text(
                            "${traslation["galery"]} (${user.galery.length})",
                            style: theme.textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => user.isGold
                                    ? UpdateUserImagesScreen(
                                        images: user.galery,
                                      )
                                    : const PremiumScreen(),
                              ),
                            ),
                            icon: icon,
                          ),
                        ],
                      ),
                      if (user.galery.isNotEmpty)
                        CarroselImage(images: user.galery),
                      const Divider(height: 40),

                      const EvaluetionsRate(), //AVALIAÇÕES

                      const Divider(height: 40), //PERGUNTAS FREGUENTES
                      Row(
                        children: [
                          Text(
                            traslation["common_questions"],
                            style: theme.textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: () => edit(
                              UpdateCommonQuestions(
                                commonQuestions: user.commonQuestion,
                              ),
                            ),
                            icon: icon,
                          ),
                        ],
                      ),

                      Column(
                        children: user.commonQuestion
                            .map((val) => CommonQuestionCard(val))
                            .toList(),
                      ),
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
