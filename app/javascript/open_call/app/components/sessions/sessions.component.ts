import { Component, OnInit } from '@angular/core';
import { SessionsService } from '../../services/sessions/sessions.service';
import { UsersService } from '../../services/users/users.service';
import { ShareButtonsModule, ShareButtonsService } from 'ngx-sharebuttons';

declare var MAX_SESSION_PROPOSAL_VOTES: any
declare var CURRENT_USER_EMAIL: any
declare var BASE_URL: any
declare var TWITTER_ACCOUNT: any

@Component({
  selector: 'app-sessions',
  templateUrl: '/templates/sessions/index.html'
  // styleUrls: ['./sessions.component.css']
})
export class SessionsComponent implements OnInit {
  baseUrl:string
  sessionVotedIds:string[]
  sessionFavedIds:string[]
  availableVotes:number
  loading:boolean
  searchCriteria:string
  searchPageNumber:number
  totalSessions:number
  matchedTags
  sessions

  constructor(private sessionsService:SessionsService, private usersService:UsersService, private sbService:ShareButtonsService) {  }

  ngOnInit() {
    this.baseUrl = BASE_URL
    this.sessionVotedIds = []
    this.sessionFavedIds = []
    this.availableVotes = MAX_SESSION_PROPOSAL_VOTES

    this.loading = false
    this.searchCriteria = ''
    this.matchedTags = []
    this.sessions = []

    this.sbService.twitterAccount = TWITTER_ACCOUNT

    this.getSessionVotedAndFavedIds()
    this.initSearch()
  }

  getSessionVotedAndFavedIds() {
    if (CURRENT_USER_EMAIL != '') {
      this.usersService.userSessionVotedIds().subscribe((ids) => {
        this.sessionVotedIds = ids
        this.availableVotes -= this.sessionVotedIds.length
        sessionStorage.setItem('availableVotes', `${this.availableVotes}`);
      });
      this.usersService.userSessionFavedIds().subscribe((ids) => {
        this.sessionFavedIds = ids;
      });
    }
  }

  initSearch() {
    this.searchCriteria = sessionStorage.getItem('searchFor') || ''
    this.search()
  }
  
  searchInput(event: any) {
    const ignoredKeys = [16, 17, 18, 27, 37, 38, 39, 40]
    if (ignoredKeys.indexOf(event.keyCode) == -1) 
      this.search()
  }

  searchTag(criteria) {
    this.searchCriteria = `${this.searchCriteria} ${criteria}`
    this.search()
  }

  search() {
    this.loading = true
    this.searchPageNumber = 1 // reset page number

    this.sessionsService.search(this.searchCriteria, this.searchPageNumber).subscribe((response) => {
      this.sessions = (CURRENT_USER_EMAIL != '') ? this.addVotedAndFavedStatusFor(response.sessions) : response.sessions
      this.matchedTags = (this.searchCriteria == '') ? [] : response.matched_tags
      this.totalSessions = response.total
      this.loading = false
      sessionStorage.setItem('searchFor', this.searchCriteria)
    })
  }

  addVotedAndFavedStatusFor(sessions) {
    for (let session of sessions) {
      session.voted = (this.sessionVotedIds.indexOf(session.id) != -1)
      session.faved = (this.sessionFavedIds.indexOf(session.id) != -1)
      session.tagsVisible = false
      session.shareVisible = false
    }
    return sessions
  }

  fav(sessionId) {
    // TODO: review this when implementing the _show session_ view
    // if (this.session != null) {
    //   session = this.session
    // } else {
    //   sessionId = parseInt(sessionId)
    //   var session = this.sessions.find(s => s.id == sessionId)
    // }
    sessionId = parseInt(sessionId)
    var session = this.sessions.find(s => s.id == sessionId)
    if (session != null) {
      this.usersService.toggleFavSession(sessionId).subscribe((success) => {
        if (success) {
          let i = this.sessionFavedIds.indexOf(session.id)
          if (i == -1)
            this.sessionFavedIds.push(session.id)
          else
            this.sessionFavedIds.splice(i, 1)
          session.faved = session.faved || false // just in case 'faved' is undefined
          session.faved = !session.faved
        }
      })
    }
  }
}
