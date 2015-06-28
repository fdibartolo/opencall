ReviewPage = ->
  @newSessionBody  = element(By.model('newSessionReview.body'))
  @newSessionPrivateBody  = element(By.model('newSessionReview.private_body'))
  @newSessionScore = element.all(By.model('newSessionReview.score'))
  @submitButton = element(By.css('.btn-primary'))

  @submit = (review) ->
    @newSessionBody.sendKeys review.body
    @newSessionPrivateBody.sendKeys review.privateBody
    @newSessionScore.get(review.score - 1).click()
    @submitButton.click()
    return

  return

module.exports = new ReviewPage()