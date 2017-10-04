import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import 'rxjs/add/operator/map';

@Injectable()
export class UsersService {

  constructor(public http:HttpClient) { }

  userSessionVotedIds() {
    return this.http.get("/users/session_voted_ids")
      .map(response => response as string[]);
  }

  userSessionFavedIds() {
    return this.http.get("/users/session_faved_ids")
      .map(response => response as string[]);
  }

  toggleFavSession(id) {
    return this.http.post("/users/fav_session", { id: id })
      .map(response => response as boolean);
  }
}
