library ez_charge.globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

User user = null;

const ANIMATION_DURATION = Duration(milliseconds: 200);
const SELECTED_DOT = Colors.yellow;
const UNSELECTED_DOT = Colors.grey;
const COLLECTION_ONBOARDING = "deviceIdOnboarding";
const String TITLE = "EzCharge";

var chargingStation = "";

bool enabledBiometric = false;
bool askForPermissionForFirstTime = true;