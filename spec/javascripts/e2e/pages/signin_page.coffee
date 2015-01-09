SigninPage = ->
  @emailInput = element(By.id('input-email'))
  @passwordInput = element(By.id('input-password'))
  @signinButton = element(By.id('signin-button'))

  @signinAs = (name) ->
    signOutIfNeeded()
    browser.get "/users/sign_in"
    @emailInput.sendKeys name
    @passwordInput.sendKeys '12345678'
    @signinButton.click()
    return

  signOutIfNeeded = () ->
    browser.get "/"
    element(By.id('signout-link')).isPresent().then (isLoggedIn) ->
      if isLoggedIn
        element(By.id('user-menu-link')).click()
        element(By.id('signout-link')).click()
    return

  return

module.exports = new SigninPage()