describe "Sessions page", ->
  beforeEach ->
    @signinPage = require './pages/signin_page.coffee'
    @signinPage.signinAs 'bob@mail.com'

    @sessionsPage = require './pages/sessions_page.coffee'
    return

  it "should list all sessions", (done) ->
    @sessionsPage.index()
    expect(@sessionsPage.sessions.count()).toEqual(3)
    done()
    return

  it "should be able to create a new session", (done) ->
    session = 
      title: 'Some Title'
      description: 'A very detailed description'

    @sessionsPage.new()
    @sessionsPage.create session

    @sessionsPage.index()
    expect(@sessionsPage.sessions.count()).toEqual(4)

    @sessionsPage.lastSessionTitle.getText().then (text) ->
      expect(text).toEqual session.title
      return

    done()
    return

  return
