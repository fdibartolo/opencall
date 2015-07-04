describe 'Sessions page', ->
  beforeEach ->
    @signinPage = require './pages/signin_page.coffee'
    @signinPage.signinAs 'bob@mail.com'

    @sessionsPage = require './pages/sessions_page.coffee'
    return

  it 'should list all sessions', (done) ->
    @sessionsPage.index()
    expect(@sessionsPage.sessions.count()).toEqual(3)
    done()
    return

  it 'should be able to create a new session', (done) ->
    session = 
      title: 'Some Title'
      summary: 'Some summary'
      description: 'A very detailed description'
      videoLink: 'http://youtube.com/video_link'

    @sessionsPage.new()
    @sessionsPage.create session

    expect(browser.getCurrentUrl()).toMatch '/sessions\/show/'
    @sessionsPage.showSessionTitle.getText().then (text) ->
      expect(text).toMatch session.title
      return

    done()
    return

  it 'should be able to vote', (done) ->
    @sessionsPage.index()

    currentAvailableVotes = 0
    @sessionsPage.availableVotes.getText().then (text) ->
      currentAvailableVotes = text

    sessionIndex = 1
    @sessionsPage.vote sessionIndex

    @sessionsPage.availableVotes.getText().then (text) ->
      expect(parseInt(text)).toEqual currentAvailableVotes - 1
      return

    done()
    return

  return
