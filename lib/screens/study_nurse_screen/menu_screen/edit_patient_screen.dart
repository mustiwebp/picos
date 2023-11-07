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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:picos/api/backend_patients_list_api.dart';
import 'package:picos/models/patient_profile.dart';
import 'package:picos/models/patients_list_element.dart';
import 'package:picos/state/objects_list_bloc.dart';
import 'package:picos/widgets/picos_add_button_bar.dart';
import 'package:picos/widgets/picos_body.dart';
import 'package:picos/widgets/picos_ink_well_button.dart';
import 'package:picos/widgets/picos_label.dart';
import 'package:picos/widgets/picos_screen_frame.dart';
import 'package:picos/widgets/picos_switch.dart';

/// A screen for adding new patient.
class EditPatientScreen extends StatefulWidget {
  /// Creates the AddPatientScreen.
  const EditPatientScreen({Key? key}) : super(key: key);

  /// global patientObjectId.
  static String? patientObjectId;

  /// global body height.
  static double? bodyHeight;

  /// global patient ID.
  static String? patientID;

  /// global case number.
  static String? caseNumber;

  /// global institute key.
  static String? instituteKey;

  /// Local variable for weight and BMI.
  static bool weightBMI = false;

  /// Local variable for heart frequency.
  static bool heartFrequency = false;

  /// Local variable for blood pressure.
  static bool bloodPressure = false;

  /// Local variable for blood sugar levels.
  static bool bloodSugarLevels = false;

  /// Local variable for walk distance.
  static bool walkDistance = false;

  /// Local variable for sleep duration.
  static bool sleepDuration = false;

  /// Local variable for sleep quality.
  static bool sleepQuality = false;

  /// Local variable for pain.
  static bool pain = false;

  /// Local variable for blood PHQ4.
  static bool phq4 = false;

  /// Local variable for medication.
  static bool medication = false;

  /// Local variable for therapy.
  static bool therapy = false;

  /// Local variable for doctor visits.
  static bool doctorsVisit = false;

  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  /// Determines if you are able to add the patient.
  bool _addDisabled = true;

  String? _title;

  PatientsListElement? _patientsListElement;

  Column _picosSwitchAndSizedBox(
    bool valueProfile,
    Function(bool value)? function,
    String title,
    ShapeBorder shape,
  ) {
    return Column(
      children: <Widget>[
        PicosSwitch(
          initialValue: valueProfile,
          onChanged: function,
          title: title,
          shape: shape,
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_patientsListElement == null) {
      PatientsListElement? patientsListElement =
          ModalRoute.of(context)!.settings.arguments as PatientsListElement;

      _patientsListElement = patientsListElement;

      _title = '${_patientsListElement!.patient.firstName} '
          '${_patientsListElement!.patient.familyName}';

      EditPatientScreen.weightBMI =
          _patientsListElement!.patientProfile.weightBMIEnabled;
      EditPatientScreen.heartFrequency =
          _patientsListElement!.patientProfile.heartFrequencyEnabled;
      EditPatientScreen.bloodPressure =
          _patientsListElement!.patientProfile.bloodPressureEnabled;
      EditPatientScreen.bloodSugarLevels =
          _patientsListElement!.patientProfile.bloodSugarLevelsEnabled;
      EditPatientScreen.walkDistance =
          _patientsListElement!.patientProfile.walkDistanceEnabled;
      EditPatientScreen.sleepDuration =
          _patientsListElement!.patientProfile.sleepDurationEnabled;
      EditPatientScreen.sleepQuality =
          _patientsListElement!.patientProfile.sleepQualityEnabled;
      EditPatientScreen.pain = _patientsListElement!.patientProfile.painEnabled;
      EditPatientScreen.phq4 = _patientsListElement!.patientProfile.phq4Enabled;
      EditPatientScreen.medication =
          _patientsListElement!.patientProfile.medicationEnabled;
      EditPatientScreen.therapy =
          _patientsListElement!.patientProfile.therapyEnabled;
      EditPatientScreen.doctorsVisit =
          _patientsListElement!.patientProfile.doctorsVisitEnabled;

      EditPatientScreen.patientObjectId =
          _patientsListElement!.patient.objectId;
      EditPatientScreen.bodyHeight =
          _patientsListElement!.patientData.bodyHeight;
      EditPatientScreen.patientID = _patientsListElement!.patientData.patientID;
      EditPatientScreen.caseNumber =
          _patientsListElement!.patientData.caseNumber;
      EditPatientScreen.instituteKey =
          _patientsListElement!.patientData.instKey;
    }

    return BlocBuilder<ObjectsListBloc<BackendPatientsListApi>,
        ObjectsListState>(
      builder: (BuildContext context, ObjectsListState state) {
        if (state.status == ObjectsListStatus.initial ||
            state.status == ObjectsListStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.status == ObjectsListStatus.failure) {
          return const Center(
            child: Text('Error'),
          );
        }

        return PicosScreenFrame(
          body: PicosBody(
            child: Column(
              children: <Widget>[
                PicosLabel(AppLocalizations.of(context)!.vitalValues),
                _picosSwitchAndSizedBox(
                  EditPatientScreen.weightBMI,
                  EditPatientScreen.weightBMI
                      ? null
                      : (bool value) {
                          setState(() {
                            _addDisabled = false;
                            EditPatientScreen.weightBMI = value;
                          });
                        },
                  AppLocalizations.of(context)!.weightBMI,
                  const Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                _picosSwitchAndSizedBox(
                  EditPatientScreen.heartFrequency,
                  (bool value) {
                    setState(() {
                      _addDisabled = false;
                      EditPatientScreen.heartFrequency = value;
                    });
                  },
                  AppLocalizations.of(context)!.heartFrequency,
                  const Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                _picosSwitchAndSizedBox(
                  EditPatientScreen.bloodPressure,
                  (bool value) {
                    setState(() {
                      _addDisabled = false;
                      EditPatientScreen.bloodPressure = value;
                    });
                  },
                  AppLocalizations.of(context)!.bloodPressure,
                  const Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                _picosSwitchAndSizedBox(
                  EditPatientScreen.bloodSugarLevels,
                  (bool value) {
                    setState(() {
                      _addDisabled = false;
                      EditPatientScreen.bloodSugarLevels = value;
                    });
                  },
                  AppLocalizations.of(context)!.bloodSugar,
                  const Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                PicosLabel(AppLocalizations.of(context)!.activityAndRest),
                const SizedBox(
                  height: 10,
                ),
                _picosSwitchAndSizedBox(
                  EditPatientScreen.walkDistance,
                  (bool value) {
                    setState(() {
                      _addDisabled = false;
                      EditPatientScreen.walkDistance = value;
                    });
                  },
                  AppLocalizations.of(context)!.walkDistance,
                  const Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                _picosSwitchAndSizedBox(
                  EditPatientScreen.sleepDuration,
                  EditPatientScreen.sleepDuration
                      ? null
                      : (bool value) {
                          setState(() {
                            _addDisabled = false;
                            EditPatientScreen.sleepDuration = value;
                          });
                        },
                  AppLocalizations.of(context)!.sleepDuration,
                  const Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                _picosSwitchAndSizedBox(
                  EditPatientScreen.sleepQuality,
                  EditPatientScreen.sleepQuality
                      ? null
                      : (bool value) {
                          setState(() {
                            _addDisabled = false;
                            EditPatientScreen.sleepQuality = value;
                          });
                        },
                  AppLocalizations.of(context)!.sleepQuality,
                  const Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                PicosLabel(AppLocalizations.of(context)!.bodyAndMind),
                const SizedBox(
                  height: 10,
                ),
                _picosSwitchAndSizedBox(
                  EditPatientScreen.pain,
                  EditPatientScreen.pain
                      ? null
                      : (bool value) {
                          setState(() {
                            _addDisabled = false;
                            EditPatientScreen.pain = value;
                          });
                        },
                  AppLocalizations.of(context)!.pain,
                  const Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                _picosSwitchAndSizedBox(
                  EditPatientScreen.phq4,
                  EditPatientScreen.phq4
                      ? null
                      : (bool value) {
                          setState(() {
                            _addDisabled = false;
                            EditPatientScreen.phq4 = value;
                          });
                        },
                  'PHQ-4',
                  const Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                PicosLabel(
                  AppLocalizations.of(context)!.medicationAndTherapy,
                ),
                const SizedBox(
                  height: 10,
                ),
                _picosSwitchAndSizedBox(
                  EditPatientScreen.medication,
                  EditPatientScreen.medication
                      ? null
                      : (bool value) {
                          setState(() {
                            _addDisabled = false;
                            EditPatientScreen.medication = value;
                          });
                        },
                  AppLocalizations.of(context)!.medication,
                  const Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                _picosSwitchAndSizedBox(
                  EditPatientScreen.therapy,
                  EditPatientScreen.therapy
                      ? null
                      : (bool value) {
                          setState(() {
                            _addDisabled = false;
                            EditPatientScreen.therapy = value;
                          });
                        },
                  AppLocalizations.of(context)!.therapy,
                  const Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                _picosSwitchAndSizedBox(
                  EditPatientScreen.doctorsVisit,
                  EditPatientScreen.doctorsVisit
                      ? null
                      : (bool value) {
                          setState(() {
                            _addDisabled = false;
                            EditPatientScreen.doctorsVisit = value;
                          });
                        },
                  AppLocalizations.of(context)!.doctorsVisit,
                  const Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                PicosInkWellButton(
                  text: 'Zum Catalog of Items',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/study-nurse-screen/catalog-of-items',
                    );
                  },
                ),
              ],
            ),
          ),
          title: _title,
          bottomNavigationBar: PicosAddButtonBar(
            disabled: _addDisabled,
            onTap: () {
              if (_patientsListElement != null) {
                PatientProfile newPatientProfile;
                newPatientProfile =
                    _patientsListElement!.patientProfile.copyWith(
                  weightBMIEnabled: EditPatientScreen.weightBMI,
                  heartFrequencyEnabled: EditPatientScreen.heartFrequency,
                  bloodPressureEnabled: EditPatientScreen.bloodPressure,
                  bloodSugarLevelsEnabled: EditPatientScreen.bloodSugarLevels,
                  walkDistanceEnabled: EditPatientScreen.walkDistance,
                  sleepDurationEnabled: EditPatientScreen.sleepDuration,
                  sleepQualityEnabled: EditPatientScreen.sleepQuality,
                  painEnabled: EditPatientScreen.pain,
                  phq4Enabled: EditPatientScreen.phq4,
                  medicationEnabled: EditPatientScreen.medication,
                  therapyEnabled: EditPatientScreen.therapy,
                  doctorsVisitEnabled: EditPatientScreen.doctorsVisit,
                );

                PatientsListElement newPatientListElement;

                newPatientListElement = _patientsListElement!.copyWith(
                  patientProfile: newPatientProfile,
                );

                context
                    .read<ObjectsListBloc<BackendPatientsListApi>>()
                    .add(SaveObject(newPatientListElement));
                Navigator.of(context).pop();
              }
            },
          ),
        );
      },
    );
  }
}
