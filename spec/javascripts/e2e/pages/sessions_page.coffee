SessionsPage = ->
  @sessions = element.all(By.repeater('session in sessions'))

  @newSessionTitle = element(By.model('newSession.title'))
  @newSessionSummary = element(By.model('newSession.summary'))
  @newSessionDescription = element(By.model('newSession.description'))
  @newSessionLastTrack = element.all(By.css('#select-track > option')).last()
  @newSessionLastTheme = element.all(By.css('#select-theme > option')).last()
  @newSessionAudienceTrack = element.all(By.css('#select-audience > option')).last()
  @createButton = element(By.id('create-button'))

  @showSessionTitle = element(By.binding('session.title'))

  @availableVotes = element(By.binding('availableVotes'))

  @index = ->
    browser.get "#/sessions"
    return

  @new = ->
    browser.get "#/sessions/new"
    return

  @create = (session) ->
    @newSessionTitle.sendKeys session.title
    @newSessionLastTheme.click()
    @newSessionLastTrack.click()
    @newSessionAudienceTrack.click()
    @newSessionSummary.sendKeys session.summary
    @newSessionDescription.sendKeys session.description
    @createButton.click()
    return

  @vote = (index) ->
    element.all(By.id('vote-btn')).get(index).click()
    return

  return

module.exports = new SessionsPage()