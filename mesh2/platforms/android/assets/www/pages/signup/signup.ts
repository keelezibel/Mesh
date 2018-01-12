import { Component } from '@angular/core';
import { NavController } from 'ionic-angular';
import { RegisterSuccessPage } from '../register-success/register-success';

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
  }
}
