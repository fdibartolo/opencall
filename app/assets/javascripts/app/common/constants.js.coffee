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
      values: [
        { value: -2, text: 'Strong reject', bgColor: 'red', color: 'white', },
        { value: -1, text: 'Weak reject', bgColor: '#FF5500', color: 'white', },
        { value: 1, text: 'Weak accept', bgColor: '#84A900', color: 'white', },
        { value: 2, text: 'Strong accept', bgColor: 'green', color: 'white' }
      ]
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
  reports:
    sort:
      sessions:
        top:
          type: 'top'
          expression: 'title'
        bottom:
          type: 'bottom'
          expression: '-title'
      themes:
        top:
          type: 'top'
          expression: 'theme'
        bottom:
          type: 'bottom'
          expression: '-theme'
      reviews:
        top:
          type: 'top'
          expression: 'reviews.length'
        bottom:
          type: 'bottom'
          expression: '-reviews.length'

