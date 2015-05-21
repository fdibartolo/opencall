UserReviewsPage = ->
  @reviews = element.all(By.repeater('review in reviews'))

  @index = ->
    browser.get "#/users/reviews"
    return

  return

module.exports = new UserReviewsPage()