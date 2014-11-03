describe "Sessions page", ->
  beforeEach ->
    @sessionsPage = require './pages/sessions_page.coffee'
    @sessionsPage.get()
    return

  it "should list all sessions", (done) ->
    expect(@sessionsPage.sessions.count()).toEqual(3)
    done()
    return

  it "should be able to create a new session", (done) ->
    session = 
      author: 'Some Author'
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
