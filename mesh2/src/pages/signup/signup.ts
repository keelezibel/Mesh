import { Component } from '@angular/core';
import { NavController } from 'ionic-angular';
import { RegisterSuccessPage } from '../register-success/register-success';
import { MainPage } from '../main/main';
import { DashboardPage } from '../dashboard/dashboard';

@Component({
  selector: 'page-signup',
  templateUrl: 'signup.html'
})
export class SignupPage {

  constructor(public navCtrl: NavController) {
  }
  goToRegisterSuccess(params){
    if (!params) params = {};
    this.navCtrl.push(RegisterSuccessPage);
  }goToMain(params){
    if (!params) params = {};
    this.navCtrl.push(MainPage);
  }goToSignup(params){
    if (!params) params = {};
    this.navCtrl.push(SignupPage);
  }goToDashboard(params){
    if (!params) params = {};
    this.navCtrl.push(DashboardPage);
  }
}
