describe "Sessions page", ->
  beforeEach ->
    @signinPage = require './pages/signin_page.coffee'
    @signinPage.signinAs 'bob@mail.com'

    @sessionsPage = require './pages/sessions_page.coffee'
    @sessionsPage.get()
    return

  it "should list all sessions", (done) ->
    expect(@sessionsPage.sessions.count()).toEqual(3)
    done()
    return

  it "should be able to create a new session", (done) ->
    session = 
      title: 'Some Title'
      description: 'A very detailed description'

    @sessionsPage.addNewSessionButton.click()
    @sessionsPage.create session

    expect(@sessionsPage.sessions.count()).toEqual(4)

    @sessionsPage.lastSessionDescription.getText().then (text) ->
      expect(text).toEqual session.description
      return

    done()
    return

  return
