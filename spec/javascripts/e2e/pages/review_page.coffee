ReviewPage = ->
  @newSessionBody         = element(By.model('newSessionReview.body'))
  @newSessionPrivateBody  = element(By.model('newSessionReview.private_body'))
  @newSessionPairReviewer = element.all(By.css('#select-second-reviewer > option')).last()
  @newSessionScore        = element.all(By.css('#select-score > option')).last()

  @submitButton = element(By.css('.btn-primary'))

  @submit = (review) ->
    @newSessionPairReviewer.click()
    @newSessionBody.sendKeys review.body
    @newSessionPrivateBody.sendKeys review.privateBody
    @newSessionScore.click()
    @submitButton.click()
    return

  return

module.exports = new ReviewPage()