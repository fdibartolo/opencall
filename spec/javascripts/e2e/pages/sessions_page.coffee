SessionsPage = ->
  @sessions = element.all(By.repeater('session in sessions'))

  @addNewSessionButton = element(By.id('add-button'))
  @newSessionAuthor = element(By.model('newSession.author'))
  @newSessionTitle = element(By.model('newSession.title'))
  @newSessionDescription = element(By.model('newSession.description'))
  @createButton = element(By.id('create-button'))

  @lastSessionDescription = element.all(By.binding('session.description')).last()

  @get = ->
    browser.get "#/sessions"
    return

  @create = (session) ->
    @newSessionAuthor.sendKeys session.author
    @newSessionTitle.sendKeys session.title
    @newSessionDescription.sendKeys session.description
    @createButton.click()
    return

  return

module.exports = new SessionsPage()