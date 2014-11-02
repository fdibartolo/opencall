SessionsPage = ->
  @sessions = element.all(By.repeater('session in sessions'))

  @get = ->
    browser.get "#/sessions"
    return

  return

module.exports = new SessionsPage()