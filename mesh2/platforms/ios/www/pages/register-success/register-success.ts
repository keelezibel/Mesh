import { Component } from '@angular/core';
import { NavController } from 'ionic-angular';
import { MainPage } from '../main/main';
import { SignupPage } from '../signup/signup';
import { RegisterSuccessPage } from '../register-success/register-success';
import { DashboardPage } from '../dashboard/dashboard';

@Component({
  selector: 'page-register-success',
  templateUrl: 'register-success.html'
})
export class RegisterSuccessPage {

  constructor(public navCtrl: NavController) {
  }
  goToMain(params){
    if (!params) params = {};
    this.navCtrl.push(MainPage);
  }goToSignup(params){
    if (!params) params = {};
    this.navCtrl.push(SignupPage);
  }goToRegisterSuccess(params){
    if (!params) params = {};
    this.navCtrl.push(RegisterSuccessPage);
  }goToDashboard(params){
    if (!params) params = {};
    this.navCtrl.push(DashboardPage);
  }
}
