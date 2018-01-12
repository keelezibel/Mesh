import { NgModule, ErrorHandler } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { IonicApp, IonicModule, IonicErrorHandler } from 'ionic-angular';
import { MyApp } from './app.component';
import { MainPage } from '../pages/main/main';
import { SignupPage } from '../pages/signup/signup';
import { RegisterSuccessPage } from '../pages/register-success/register-success';
import { DashboardPage } from '../pages/dashboard/dashboard';
import { ChatPage } from '../pages/chat/chat';
import { MapPage } from '../pages/map/map';


import { StatusBar } from '@ionic-native/status-bar';
import { SplashScreen } from '@ionic-native/splash-screen';

@NgModule({
  declarations: [
    MyApp,
    MainPage,
    SignupPage,
    RegisterSuccessPage,
    DashboardPage,
    ChatPage,
    MapPage
  ],
  imports: [
    BrowserModule,
    IonicModule.forRoot(MyApp)
  ],
  bootstrap: [IonicApp],
  entryComponents: [
    MyApp,
    MainPage,
    SignupPage,
    RegisterSuccessPage,
    DashboardPage,
    ChatPage,
    MapPage
  ],
  providers: [
    StatusBar,
    SplashScreen,
    {provide: ErrorHandler, useClass: IonicErrorHandler}
  ]
})
export class AppModule {}