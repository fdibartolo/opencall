require('coffee-script');

exports.config = {
  seleniumAddress: 'http://localhost:4444/wd/hub',

  capabilities: {
    'browserName': 'chrome'
  },

  specs: [
    'e2e/pages/sessions_page.coffee',
    'e2e/*.coffee'
  ],

  baseUrl: 'http://localhost:4000',

  jasmineNodeOpts: {
    showColors: true,
    defaultTimeoutInterval: 30000
  },
};
