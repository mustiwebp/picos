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

import 'dart:async';

import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:picos/api/backend_objects_api.dart';
import 'package:picos/models/abstract_database_object.dart';
import 'package:picos/models/patient.dart';
import 'package:picos/models/patient_data.dart';
import 'package:picos/models/patients_list_element.dart';
import 'package:picos/models/patient_profile.dart';
import 'package:collection/collection.dart';
import 'package:picos/screens/study_nurse_screen/menu_screen/edit_patient_screen.dart';
import 'package:picos/util/backend.dart';

/// API for calling the corresponding tables for the patient list.
class BackendPatientsListApi extends BackendObjectsApi {
  @override
  Future<void> saveObject(AbstractDatabaseObject object) async {
    try {
      dynamic responsePatientData =
          await Backend.saveObject((object as PatientsListElement).patientData);
      PatientData patientData = object.patientData.copyWith(
        objectId: responsePatientData['objectId'],
        createdAt: DateTime.tryParse(responsePatientData['createdAt'] ?? '') ??
            object.patientData.createdAt,
        updatedAt: DateTime.tryParse(responsePatientData['updatedAt'] ?? '') ??
            object.patientData.updatedAt,
      );

      dynamic responsePatientProfile =
          await Backend.saveObject(object.patientProfile);
      PatientProfile patientProfile = object.patientProfile.copyWith(
        objectId: responsePatientProfile['objectId'],
        createdAt:
            DateTime.tryParse(responsePatientProfile['createdAt'] ?? '') ??
                object.patientProfile.createdAt,
        updatedAt:
            DateTime.tryParse(responsePatientProfile['updatedAt'] ?? '') ??
                object.patientProfile.updatedAt,
      );

      object = object.copyWith(
        patientData: patientData,
        patientProfile: patientProfile,
      );

      int index = getIndex(object);

      if (index >= 0) {
        objectList[index] = object;
        objectList = <AbstractDatabaseObject>[...objectList];
      } else {
        objectList = <AbstractDatabaseObject>[...objectList, object];
      }

      dispatch();
    } catch (e) {
      Stream<List<PatientsListElement>>.error(e);
    }
  }

  /// Gets all Patients from the database.
  static Future<List<dynamic>> getAll() {
    return Backend.getAll(Patient.databaseTable);
  }

  /// Gets an object entry.
  static Future<PatientsListElement?> getObject() async {
    try {
      String? patientObjectId = EditPatientScreen.patientObjectId;

      List<Patient> patientResults = <Patient>[];
      List<PatientProfile> patientProfileResults = <PatientProfile>[];
      List<PatientData> patientDataResults = <PatientData>[];

      ParseResponse responsePatient = await Backend.getEntry(
        Patient.databaseTable,
        'Patient',
        EditPatientScreen.patientObjectId!,
      );
      if (responsePatient.results != null) {
        for (dynamic element in responsePatient.results!) {
          patientResults.add(
            Patient(
              firstName: element['Firstname'] ?? '',
              familyName: element['Lastname'] ?? '',
              email: element['username'] ?? '',
              number: element['PhoneNo'] ?? '',
              address: element['Address'] ?? '',
              formOfAddress: element['Form'] ?? '',
              objectId: element['objectId'],
              createdAt: element['createdAt'],
              updatedAt: element['updatedAt'],
            ),
          );
        }
      }

      ParseResponse responsePatientProfile = await Backend.getEntry(
        PatientProfile.databaseTable,
        'Patient',
        EditPatientScreen.patientObjectId!,
      );

      if (responsePatientProfile.results != null) {
        for (dynamic element in responsePatientProfile.results!) {
          patientProfileResults.add(
            PatientProfile(
              weightBMIEnabled: element['Weight_BMI'],
              heartFrequencyEnabled: element['HeartRate'],
              bloodPressureEnabled: element['BloodPressure'],
              bloodSugarLevelsEnabled: element['BloodSugar'],
              walkDistanceEnabled: element['WalkingDistance'],
              sleepDurationEnabled: element['SleepDuration'],
              sleepQualityEnabled: element['SISQS'],
              painEnabled: element['Pain'],
              phq4Enabled: element['PHQ4'],
              medicationEnabled: element['Medication'],
              therapyEnabled: element['Therapies'],
              doctorsVisitEnabled: element['Stays'],
              patientObjectId: element['Patient']['objectId'],
              doctorObjectId: element['Doctor']['objectId'],
              objectId: element['objectId'],
              createdAt: element['createdAt'],
              updatedAt: element['updatedAt'],
            ),
          );
        }
      }

      ParseResponse responsePatientData = await Backend.getEntry(
        PatientProfile.databaseTable,
        'Patient',
        EditPatientScreen.patientObjectId!,
      );

      if (responsePatientData.results != null) {
        for (dynamic element in responsePatientData.results!) {
          patientDataResults.add(
            PatientData(
              bodyHeight: element['BodyHeight']?.toDouble(),
              patientID: element['ID'],
              caseNumber: element['CaseNumber'],
              instKey: element['inst_key'],
              bodyWeight: element['BodyWeight']?.toDouble(),
              ezpICU: element['EZP_ICU'],
              birthDate: element['Birthdate'],
              gender: element['Gender'],
              bmi: element['BMI']?.toDouble(),
              idealBMI: element['IdealBodyWeight']?.toDouble(),
              azpICU: (element['AZP_ICU']),
              ventilationDays: element['VentilationDays'],
              azpKH: element['AZP_KH'],
              ezpKH: element['EZP_KH'],
              icd10Codes: element['ICD_10_Codes'],
              station: element['Station'],
              lbgt70: element['LBgt70'],
              icuLengthStay: element['ICU_LengthStay'],
              khLengthStay: element['KH_LengthStay'],
              wdaICU: element['WdaICU2'],
              objectId: element['objectId'],
              patientObjectId: element['Patient']['objectId'],
              doctorObjectId: element['Doctor']['objectId'],
              createdAt: element['createdAt'],
              updatedAt: element['updatedAt'],
            ),
          );
        }
      }

      Patient? matchingPatient = patientResults.firstWhereOrNull(
        (Patient patientObject) => patientObject.objectId == patientObjectId,
      );

      PatientProfile? matchingPatientProfile =
          patientProfileResults.firstWhereOrNull(
        (PatientProfile patientProfileObject) =>
            patientProfileObject.patientObjectId == patientObjectId,
      );

      PatientData? matchingPatientData = patientDataResults.firstWhereOrNull(
        (PatientData patientDataObject) =>
            patientDataObject.patientObjectId == patientObjectId,
      );

      PatientsListElement? result;
      /*if (matchingPatient != null ||
          matchingPatientProfile != null ||
          matchingPatientData != null) {
        List<VitalSignsObject>? foundObjectsVitalSigns =
            _findMatchingObjectsVitalSigns(
          matchingPatientData,
          patientDataResults,
        );

        List<BloodGasAnalysisObject>? foundObjectsBloodGasAnalysis =
            _findMatchingObjectsBloodGasAnalysis(
          matchingBloodGasAnalysis,
          bloodGasAnalysisObjectResults,
        );

        List<RespiratoryParametersObject>? foundObjectsRespiratoryParameters =
            _findMatchingObjectsRespiratoryParameters(
          matchingRespiratoryParameters,
          respiratoryParametersObjectResults,
        );*/

      result = PatientsListElement(
        patient: matchingPatient!,
        patientData: matchingPatientData!,
        patientProfile: matchingPatientProfile!,
        objectId: patientObjectId,
      );

      return result;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Stream<List<AbstractDatabaseObject>>> getObjects() async {
    try {
      List<dynamic> responsePatient =
          await Backend.getAll(Patient.databaseTable);
      List<dynamic> responsePatientData =
          await Backend.getAll(PatientData.databaseTable);
      List<dynamic> responsePatientProfile =
          await Backend.getAll(PatientProfile.databaseTable);

      List<Patient> patientResults = <Patient>[];
      List<PatientData> patientDataResults = <PatientData>[];
      List<PatientProfile> patientProfileResults = <PatientProfile>[];

      for (dynamic element in responsePatient) {
        // Excluding own user.
        if (element['Role'] != 'Doctor') {
          patientResults.add(
            Patient(
              firstName: element['Firstname'] ?? '',
              familyName: element['Lastname'] ?? '',
              email: element['username'] ?? '',
              number: element['PhoneNo'] ?? '',
              address: element['Address'] ?? '',
              formOfAddress: element['Form'] ?? '',
              objectId: element['objectId'],
              createdAt: DateTime.parse(element['createdAt']),
              updatedAt: DateTime.parse(element['updatedAt']),
            ),
          );
        }
      }

      for (dynamic element in responsePatientData) {
        patientDataResults.add(
          PatientData(
            bodyHeight: element['BodyHeight'] != null
                ? element['BodyHeight']['estimateNumber'].toDouble()
                : null,
            patientID: element['ID'],
            caseNumber: element['CaseNumber'],
            instKey: element['inst_key'],
            objectId: element['objectId'],
            patientObjectId: element['Patient']['objectId'],
            doctorObjectId: element['Doctor']['objectId'],
            createdAt: DateTime.parse(element['createdAt']),
            updatedAt: DateTime.parse(element['updatedAt']),
          ),
        );
      }

      for (dynamic element in responsePatientProfile) {
        patientProfileResults.add(
          PatientProfile(
            weightBMIEnabled: element['Weight_BMI'],
            heartFrequencyEnabled: element['HeartRate'],
            bloodPressureEnabled: element['BloodPressure'],
            bloodSugarLevelsEnabled: element['BloodSugar'],
            walkDistanceEnabled: element['WalkingDistance'],
            sleepDurationEnabled: element['SleepDuration'],
            sleepQualityEnabled: element['SISQS'],
            painEnabled: element['Pain'],
            phq4Enabled: element['PHQ4'],
            medicationEnabled: element['Medication'],
            therapyEnabled: element['Therapies'],
            doctorsVisitEnabled: element['Stays'],
            patientObjectId: element['Patient']['objectId'],
            doctorObjectId: element['Doctor']['objectId'],
            objectId: element['objectId'],
            createdAt: DateTime.parse(element['createdAt']),
            updatedAt: DateTime.parse(element['updatedAt']),
          ),
        );
      }

      for (Patient patientObject in patientResults) {
        String? patientObjectId = patientObject.objectId;

        PatientData? matchingPatientData = patientDataResults.firstWhereOrNull(
          (PatientData patientDataObject) =>
              patientDataObject.patientObjectId == patientObjectId,
        );

        PatientProfile? matchingPatientProfile =
            patientProfileResults.firstWhereOrNull(
          (PatientProfile patientProfileObject) =>
              patientProfileObject.patientObjectId == patientObjectId,
        );

        if (matchingPatientData != null && matchingPatientProfile != null) {
          objectList.add(
            PatientsListElement(
              patient: patientObject,
              patientData: matchingPatientData,
              patientProfile: matchingPatientProfile,
              objectId: patientObject.objectId,
            ),
          );
        } else if (matchingPatientData == null &&
            matchingPatientProfile != null) {
          PatientData emptyPatientData = PatientData(
            patientObjectId: patientObjectId!,
            doctorObjectId: Backend.user.objectId!,
          );

          objectList.add(
            PatientsListElement(
              patient: patientObject,
              patientData: emptyPatientData,
              patientProfile: matchingPatientProfile,
              objectId: patientObject.objectId,
            ),
          );
        } else if (matchingPatientData != null &&
            matchingPatientProfile == null) {
          PatientProfile emptyPatientProfile = PatientProfile(
            weightBMIEnabled: false,
            heartFrequencyEnabled: false,
            bloodPressureEnabled: false,
            bloodSugarLevelsEnabled: false,
            walkDistanceEnabled: false,
            sleepDurationEnabled: false,
            sleepQualityEnabled: false,
            painEnabled: false,
            phq4Enabled: false,
            medicationEnabled: false,
            therapyEnabled: false,
            doctorsVisitEnabled: false,
            patientObjectId: patientObjectId!,
            doctorObjectId: Backend.user.objectId!,
          );

          objectList.add(
            PatientsListElement(
              patient: patientObject,
              patientData: matchingPatientData,
              patientProfile: emptyPatientProfile,
              objectId: patientObject.objectId,
            ),
          );
        } else if (matchingPatientData == null &&
            matchingPatientProfile == null) {
          PatientData emptyPatientData = PatientData(
            patientObjectId: patientObjectId!,
            doctorObjectId: Backend.user.objectId!,
          );

          PatientProfile emptyPatientProfile = PatientProfile(
            weightBMIEnabled: false,
            heartFrequencyEnabled: false,
            bloodPressureEnabled: false,
            bloodSugarLevelsEnabled: false,
            walkDistanceEnabled: false,
            sleepDurationEnabled: false,
            sleepQualityEnabled: false,
            painEnabled: false,
            phq4Enabled: false,
            medicationEnabled: false,
            therapyEnabled: false,
            doctorsVisitEnabled: false,
            patientObjectId: patientObjectId,
            doctorObjectId: Backend.user.objectId!,
          );

          objectList.add(
            PatientsListElement(
              patient: patientObject,
              patientData: emptyPatientData,
              patientProfile: emptyPatientProfile,
              objectId: patientObject.objectId,
            ),
          );
        }
      }
      return getObjectsStream();
    } catch (e) {
      return Stream<List<PatientsListElement>>.error(e);
    }
  }
}
