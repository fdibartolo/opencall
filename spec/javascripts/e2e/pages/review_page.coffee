ReviewPage = ->
  @newSessionBody  = element(By.model('newSessionReview.body'))
  @newSessionScore = element.all(By.model('newSessionReview.score'))
  @submitButton = element(By.css('.btn-primary'))

  @new = (id) ->
    browser.get "#/sessions/review/#{id}"
    return

  @submit = (review) ->
    @newSessionBody.sendKeys review.body
    @newSessionScore.get(review.score - 1).click()
    @submitButton.click()
    return

  return

module.exports = new ReviewPage()