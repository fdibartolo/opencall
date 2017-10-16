import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { APP_BASE_HREF } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { HttpModule } from '@angular/http';

import { ShareButtonsModule } from 'ngx-sharebuttons';
import { StickyModule } from 'ng2-sticky-kit';

import { AppComponent } from './app.component';
import { HomeComponent } from './components/home/home.component';
import { SessionsComponent } from './components/sessions/sessions.component';

import { SessionsService } from './services/sessions/sessions.service';
import { UsersService } from './services/users/users.service';

import { FavActionDirective } from './directives/fav-action/fav-action.directive';

import { TokenInterceptor } from './interceptors/token.interceptor';

const appRoutes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'sessions', component: SessionsComponent }
];

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    SessionsComponent,
    FavActionDirective
  ],
  imports: [
    BrowserModule,
    RouterModule.forRoot(appRoutes, { useHash: true }),
    HttpClientModule,
    FormsModule,
    HttpModule,
    ShareButtonsModule.forRoot(),
    StickyModule
  ],
  providers: [
    { provide: APP_BASE_HREF, useValue: '/'},
    { provide: HTTP_INTERCEPTORS, useClass: TokenInterceptor, multi: true },
    SessionsService,
    UsersService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
