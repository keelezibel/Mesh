import { Component } from '@angular/core';
import { NavController } from 'ionic-angular';
import { SignupPage } from '../signup/signup';
import { RegisterSuccessPage } from '../register-success/register-success';
import { DashboardPage } from '../dashboard/dashboard';

@Component({
  selector: 'page-main',
  templateUrl: 'main.html'
})
export class MainPage {

  constructor(public navCtrl: NavController) {
  }
  goToSignup(params){
    if (!params) params = {};
    this.navCtrl.push(SignupPage);
  }goToRegisterSuccess(params){
    if (!params) params = {};
    this.navCtrl.push(RegisterSuccessPage);
  }goToMain(params){
    if (!params) params = {};
    this.navCtrl.push(MainPage);
  }goToDashboard(params){
    if (!params) params = {};
    this.navCtrl.push(DashboardPage);
  }
}
