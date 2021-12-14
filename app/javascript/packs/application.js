// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "jquery"
import "bootstrap"
import "./carts"
import "./google_map"
import "bootstrap-input-spinner"
// import React, { Component } from 'react';
// import ReactDOM, { render } from 'react-dom';
// import { Provider} from 'react-redux';

Rails.start()
Turbolinks.start()
ActiveStorage.start()

global.$ = require('jquery')
global.Rails = Rails;

$("input[type='number']").inputSpinner();
// import "controllers"
// // Support component names relative to this directory:
// var componentRequireContext = require.context("components", true);
// var ReactRailsUJS = require("react_ujs");
// ReactRailsUJS.useContext(componentRequireContext);
