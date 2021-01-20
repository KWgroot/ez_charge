library ez_charge.globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

User user = null;

const ANIMATION_DURATION = Duration(milliseconds: 200);
const SELECTED_DOT = Color.fromRGBO(93, 199, 204, 1);
const UNSELECTED_DOT = Colors.grey;
const COLLECTION_ONBOARDING = "deviceIdOnboarding";
const String TITLE = "EzCharge";

var chargingStation = "";

bool enabledBiometric = false;
bool askForPermissionForFirstTime = true;