describe "Sessions page", ->
  beforeEach ->
    @sessionsPage = require './pages/sessions_page.coffee'
    @sessionsPage.get()
    return

  it "should list all sessions", (done) ->
    expect(@sessionsPage.sessions.count()).toEqual(3)
    done()
    return

  return
