describe "Reviews page", ->
  beforeEach ->
    @signinPage = require './pages/signin_page.coffee'
    @signinPage.signinAs 'reviewer@mail.com'

    @sessionsPage = require './pages/sessions_page.coffee'
    @reviewPage = require './pages/review_page.coffee'
    @userReviewsPage = require './pages/user_reviews_page.coffee'

    return

  it "should have access to the review form", (done) ->
    @sessionsPage.index()

    sessionIndex = 1
    @sessionsPage.review sessionIndex

    expect(browser.getCurrentUrl()).toMatch '/sessions\/review/'
    done()
    return

  it "should be able to submit a review", (done) ->
    @sessionsPage.index()

    sessionIndex = 1
    @sessionsPage.review sessionIndex

    review = 
      body: 'I like it!'
      privateBody: 'private comment'

    @reviewPage.submit review
    expect(browser.getCurrentUrl()).toMatch '/users\/reviews'

    @userReviewsPage.index()
    expect(@userReviewsPage.reviews.count()).toEqual(1)
    done()
    return

  return
