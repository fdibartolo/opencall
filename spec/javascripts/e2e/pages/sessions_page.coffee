SessionsPage = ->
  @sessions = element.all(By.repeater('session in sessions'))

  @newSessionTitle = element(By.model('newSession.title'))
  @newSessionSummary = element(By.model('newSession.summary'))
  @newSessionDescription = element(By.model('newSession.description'))
  @newSessionLastTrack = element.all(By.tagName('option')).last()
  @createButton = element(By.id('create-button'))

  @showSessionTitle = element(By.binding('session.title'))

  @index = ->
    browser.get "#/sessions"
    return

  @new = ->
    browser.get "#/sessions/new"
    return

  @create = (session) ->
    @newSessionLastTrack.click()
    @newSessionTitle.sendKeys session.title
    @newSessionSummary.sendKeys session.summary
    @newSessionDescription.sendKeys session.description
    @createButton.click()
    return

  return

module.exports = new SessionsPage()