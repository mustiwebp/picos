/*   This file is part of Picos, a health tracking mobile app
*    Copyright (C) 2022 Healthcare IT Solutions GmbH
*
*    This program is free software: you can redistribute it and/or modify
*    it under the terms of the GNU General Public License as published by
*    the Free Software Foundation, either version 3 of the License, or
*    (at your option) any later version.
*
*    This program is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU General Public License for more details.
*
*    You should have received a copy of the GNU General Public License
*    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../widgets/picos_number_field.dart';
import '../catalog_of_items_page.dart';
import '../widgets/catalog_of_items_label.dart';

/// Shows the vital data page.
class LaboratoryValues extends StatelessWidget {
  /// Creates VitalData.
  const LaboratoryValues({
    required this.leukocyteCallback,
    required this.lymphocytesCountCallback,
    required this.lymphocytesPercentageCallback,
    required this.thrombocytesCallback,
    required this.cReactiveProteinLevelCallback,
    required this.pctCallback,
    required this.interleukinCallback,
    required this.bloodUreaNitrogenCallback,
    required this.creatinineCallback,
    required this.hfmBNPCallback,
    required this.hfmNTBNPCallback,
    required this.bilirubinTotalCallback,
    required this.hemoglobinCallback,
    required this.hematocritCallback,
    required this.albuminCallback,
    required this.gotCallback,
    required this.gptCallback,
    required this.troponinCallback,
    required this.creatineKinaseCallback,
    required this.mimCallback,
    required this.lactateDehydrogenaseLevelCallback,
    required this.amylaseLevelCallback,
    required this.lipaseLevelCallback,
    required this.dDimerCallback,
    required this.inrCallback,
    required this.pttCallback,
    Key? key,
    this.initialLeukocyte,
    this.initialLymphocytesCount,
    this.initialLymphocytesPercentage,
    this.initialThrombocytes,
    this.initialcReactiveProteinLevel,
    this.initialPct,
    this.initialInterleukin,
    this.initialBloodUreaNitrogen,
    this.initialCreatinine,
    this.initialHfmBNP,
    this.initialHfmNTBNP,
    this.initialBilirubinTotal,
    this.initialHemoglobin,
    this.initialHematocrit,
    this.initialAlbumin,
    this.initialGot,
    this.initialGpt,
    this.initialTroponin,
    this.initialCreatineKinase,
    this.initialMim,
    this.initialLactateDehydrogenaseLevel,
    this.initialAmylaseLevel,
    this.initialLipaseLevel,
    this.initialDDimer,
    this.initialInr,
    this.initialPtt,
  }) : super(key: key);

  /// Leukocyte or white blood cells count callback.
  final void Function(double? value) leukocyteCallback;

  /// Lymphocytes count callback.
  final void Function(double? value) lymphocytesCountCallback;

  /// Lymphocytes percentage callback.
  final void Function(double? value) lymphocytesPercentageCallback;

  /// Thrombocytes or platelets count callback.
  final void Function(double? value) thrombocytesCallback;

  /// C-reactive protein level callback.
  final void Function(double? value) cReactiveProteinLevelCallback;

  /// Procalcitonin (PCT) level callback.
  final void Function(double? value) pctCallback;

  /// Interleukin (IL-6) callback.
  final void Function(double? value) interleukinCallback;

  /// Blood Urea Nitrogen callback.
  final void Function(double? value) bloodUreaNitrogenCallback;

  /// Creatinine callback.
  final void Function(double? value) creatinineCallback;

  /// Heart failure marker BNP callback.
  final void Function(double? value) hfmBNPCallback;

  /// Heart failure marker NT-proBNP callback.
  final void Function(double? value) hfmNTBNPCallback;

  /// Bilirubin total callback.
  final void Function(double? value) bilirubinTotalCallback;

  /// Hemoglobin callback.
  final void Function(double? value) hemoglobinCallback;

  /// Hematocrit callback.
  final void Function(double? value) hematocritCallback;

  /// Albumin callback.
  final void Function(double? value) albuminCallback;

  /// Glutamat-Oxalacetat-Transaminase (GOT/ASAT) callback.
  final void Function(double? value) gotCallback;

  /// Glutamat-Pyruvat-Transaminase (GPT/ALAT) callback.
  final void Function(double? value) gptCallback;

  /// Troponin callback.
  final void Function(double? value) troponinCallback;

  /// Creatine kinase callback.
  final void Function(double? value) creatineKinaseCallback;

  /// Myocardial infarction marker CK-MB callback.
  final void Function(double? value) mimCallback;

  /// Lactate dehydrogenase level callback.
  final void Function(double? value) lactateDehydrogenaseLevelCallback;

  /// Amylase level callback.
  final void Function(double? value) amylaseLevelCallback;

  /// Lipase level callback.
  final void Function(double? value) lipaseLevelCallback;

  /// D-dimer callback.
  final void Function(double? value) dDimerCallback;

  /// International Normalized Ratio (INR) callback.
  final void Function(double? value) inrCallback;

  /// Partial thromboplastin time callback.
  final void Function(double? value) pttCallback;

  ///
  final double? initialLeukocyte;

  ///
  final double? initialLymphocytesCount;

  ///
  final double? initialLymphocytesPercentage;

  ///
  final double? initialThrombocytes;

  ///
  final double? initialcReactiveProteinLevel;

  ///
  final double? initialPct;

  ///
  final double? initialInterleukin;

  ///
  final double? initialBloodUreaNitrogen;

  ///
  final double? initialCreatinine;

  ///
  final double? initialHfmBNP;

  ///
  final double? initialHfmNTBNP;

  ///
  final double? initialBilirubinTotal;

  ///
  final double? initialHemoglobin;

  ///
  final double? initialHematocrit;

  ///
  final double? initialAlbumin;

  ///
  final double? initialGot;

  ///
  final double? initialGpt;

  ///
  final double? initialTroponin;

  ///
  final double? initialCreatineKinase;

  ///
  final double? initialMim;

  ///
  final double? initialLactateDehydrogenaseLevel;

  ///
  final double? initialAmylaseLevel;

  ///
  final double? initialLipaseLevel;

  ///
  final double? initialDDimer;

  ///
  final double? initialInr;

  ///
  final double? initialPtt;

  @override
  Widget build(BuildContext context) {
    const String uL = '10*3/uL';
    const String nmolL = 'nmol/L';

    return CatalogOfItemsPage(
      title: AppLocalizations.of(context)!.icuDiagnosis,
      padding: EdgeInsets.zero,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              CatalogOfItemsLabel(AppLocalizations.of(context)!.leukocyte),
              PicosNumberField(
                hint: uL,
                initialValue: initialLeukocyte.toString(),
                onChanged: (String value) {
                  leukocyteCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(
                AppLocalizations.of(context)!.lymphocytesCount,
              ),
              PicosNumberField(
                hint: uL,
                initialValue: initialLymphocytesCount.toString(),
                onChanged: (String value) {
                  lymphocytesCountCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(
                AppLocalizations.of(context)!.lymphocytesPercentage,
              ),
              PicosNumberField(
                hint: uL,
                initialValue: initialLymphocytesPercentage.toString(),
                onChanged: (String value) {
                  lymphocytesPercentageCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.thrombocytes),
              PicosNumberField(
                hint: uL,
                initialValue: initialThrombocytes.toString(),
                onChanged: (String value) {
                  thrombocytesCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(
                AppLocalizations.of(context)!.cReactiveProteinLevel,
              ),
              PicosNumberField(
                hint: uL,
                initialValue: initialcReactiveProteinLevel.toString(),
                onChanged: (String value) {
                  cReactiveProteinLevelCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.pct),
              PicosNumberField(
                hint: uL,
                initialValue: initialPct.toString(),
                onChanged: (String value) {
                  pctCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.interleukin),
              PicosNumberField(
                hint: uL,
                initialValue: initialInterleukin.toString(),
                onChanged: (String value) {
                  interleukinCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(
                AppLocalizations.of(context)!.bloodUreaNitrogen,
              ),
              PicosNumberField(
                hint: uL,
                initialValue: initialBloodUreaNitrogen.toString(),
                onChanged: (String value) {
                  bloodUreaNitrogenCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.creatinine),
              PicosNumberField(
                hint: uL,
                initialValue: initialCreatinine.toString(),
                onChanged: (String value) {
                  creatinineCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.hfmBNP),
              PicosNumberField(
                hint: uL,
                initialValue: initialHfmBNP.toString(),
                onChanged: (String value) {
                  hfmBNPCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.hfmNTBNP),
              PicosNumberField(
                hint: uL,
                initialValue: initialHfmNTBNP.toString(),
                onChanged: (String value) {
                  hfmNTBNPCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.bilirubinTotal),
              PicosNumberField(
                hint: uL,
                initialValue: initialBilirubinTotal.toString(),
                onChanged: (String value) {
                  bilirubinTotalCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.hemoglobin),
              PicosNumberField(
                hint: uL,
                initialValue: initialHemoglobin.toString(),
                onChanged: (String value) {
                  hemoglobinCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.hematocrit),
              PicosNumberField(
                hint: uL,
                initialValue: initialHematocrit.toString(),
                onChanged: (String value) {
                  hematocritCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.albumin),
              PicosNumberField(
                hint: uL,
                initialValue: initialAlbumin.toString(),
                onChanged: (String value) {
                  albuminCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.got),
              PicosNumberField(
                hint: uL,
                initialValue: initialGot.toString(),
                onChanged: (String value) {
                  gotCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.gpt),
              PicosNumberField(
                hint: uL,
                initialValue: initialGpt.toString(),
                onChanged: (String value) {
                  gptCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.troponin),
              PicosNumberField(
                hint: uL,
                initialValue: initialTroponin.toString(),
                onChanged: (String value) {
                  troponinCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.creatineKinase),
              PicosNumberField(
                hint: uL,
                initialValue: initialCreatineKinase.toString(),
                onChanged: (String value) {
                  creatineKinaseCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.mim),
              PicosNumberField(
                hint: uL,
                initialValue: initialMim.toString(),
                onChanged: (String value) {
                  mimCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(
                AppLocalizations.of(context)!.lactateDehydrogenaseLevel,
              ),
              PicosNumberField(
                hint: uL,
                initialValue: initialLactateDehydrogenaseLevel.toString(),
                onChanged: (String value) {
                  lactateDehydrogenaseLevelCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.amylaseLevel),
              PicosNumberField(
                hint: uL,
                initialValue: initialAmylaseLevel.toString(),
                onChanged: (String value) {
                  hematocritCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.lipaseLevel),
              PicosNumberField(
                hint: uL,
                initialValue: initialLipaseLevel.toString(),
                onChanged: (String value) {
                  lipaseLevelCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.dDimer),
              PicosNumberField(
                hint: uL,
                initialValue: initialDDimer.toString(),
                onChanged: (String value) {
                  dDimerCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.inr),
              PicosNumberField(
                hint: uL,
                initialValue: initialInr.toString(),
                onChanged: (String value) {
                  inrCallback(double.tryParse(value));
                },
              ),
              CatalogOfItemsLabel(AppLocalizations.of(context)!.ptt),
              PicosNumberField(
                hint: uL,
                initialValue: initialPtt.toString(),
                onChanged: (String value) {
                  pttCallback(double.tryParse(value));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
