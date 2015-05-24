angular.module('openCall.constants').constant 'constants', 
  sessions:
    status:
      new: 'new'
      accepted: 'accepted'
      declined: 'declined'
  reviews:
    score:
      poorThreshold: 3
      goodThreshold: 7
    status:
      pending: 'pending'
      accepted: 'accepted'
      rejected: 'rejected'
  notifications:
    sort:
      top:
        type: 'top'
        expression: 'reviews.length'
      bottom:
        type: 'bottom'
        expression: '-reviews.length'

