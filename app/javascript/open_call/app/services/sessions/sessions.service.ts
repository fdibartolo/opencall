import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import 'rxjs/add/operator/map';

@Injectable()
export class SessionsService {

  constructor(public http:HttpClient) { }

  search(criteria, pageNumber) {
    return this.http.get(`/session_proposals/search?q=${criteria}&page=${pageNumber}`)
      .map(response => response as SearchResponse);
  }
}

interface SearchResponse {
  total:number,
  sessions:Session[],
  matched_tags:MatchTag[]
}

interface Session {
  id:number,
  title:string,
  theme:string,
  track:string,
  author:Author,
  video_link:string,
  tags:string[]
}

interface Author {
  name:string,
  avatar_url:string
}

interface MatchTag {
  key:string,
  doc_count:number
}
