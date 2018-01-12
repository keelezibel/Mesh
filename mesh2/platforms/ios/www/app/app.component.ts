import { Component, ViewChild } from '@angular/core';
import { Platform, Nav } from 'ionic-angular';
import { StatusBar } from '@ionic-native/status-bar';
import { SplashScreen } from '@ionic-native/splash-screen';

import { DashboardPage } from '../pages/dashboard/dashboard';
import { SignupPage } from '../pages/signup/signup';
import { RegisterSuccessPage } from '../pages/register-success/register-success';
import { MapPage } from '../pages/map/map';
import { ChatPage } from '../pages/chat/chat';


import { MainPage } from '../pages/main/main';



@Component({
  templateUrl: 'app.html'
})
export class MyApp {
  @ViewChild(Nav) navCtrl: Nav;
    rootPage:any = MainPage;

  constructor(platform: Platform, statusBar: StatusBar, splashScreen: SplashScreen) {
    platform.ready().then(() => {
      // Okay, so the platform is ready and our plugins are available.
      // Here you can do any higher level native things you might need.
      statusBar.styleDefault();
      splashScreen.hide();
    });
  }
  goToDashboard(params){
    if (!params) params = {};
    this.navCtrl.setRoot(DashboardPage);
  }goToMain(params){
    if (!params) params = {};
    this.navCtrl.setRoot(MainPage);
  }goToSignup(params){
    if (!params) params = {};
    this.navCtrl.setRoot(SignupPage);
  }goToRegisterSuccess(params){
    if (!params) params = {};
    this.navCtrl.setRoot(RegisterSuccessPage);
  }goToMap(params){
    if (!params) params = {};
    this.navCtrl.setRoot(MapPage);
  }goToChat(params){
    if (!params) params = {};
    this.navCtrl.setRoot(ChatPage);
  }
}
