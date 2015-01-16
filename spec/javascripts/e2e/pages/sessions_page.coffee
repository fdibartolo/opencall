SessionsPage = ->
  @sessions = element.all(By.repeater('session in sessions'))

  @newSessionTitle = element(By.model('newSession.title'))
  @newSessionDescription = element(By.model('newSession.description'))
  @createButton = element(By.id('create-button'))

  @lastSessionDescription = element.all(By.binding('session.description')).last()

  @index = ->
    browser.get "#/sessions"
    return

  @new = ->
    browser.get "#/sessions/new"
    return

  @create = (session) ->
    @newSessionTitle.sendKeys session.title
    @newSessionDescription.sendKeys session.description
    @createButton.click()
    return

  return

module.exports = new SessionsPage()