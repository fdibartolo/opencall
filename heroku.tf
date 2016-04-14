provider "heroku" {
  email = "${var.email}"
  api_key = "${var.api_key}"
}

resource "heroku_app" "default" {
  name = "${var.name}"
  region = "${var.region}"

  config_vars {
    GITHUB_KEY = "${var.github_key}"
    GITHUB_SECRET = "${var.github_secret}"
    TWITTER_KEY = "${var.twitter_key}"
    TWITTER_SECRET = "${var.twitter_secret}"
    GOOGLE_KEY = "${var.google_key}"
    GOOGLE_SECRET = "${var.google_secret}"
    LINKEDIN_KEY = "${var.linkedin_key}"
    LINKEDIN_SECRET = "${var.linkedin_secret}"
    TZ = "${var.tz}"
    LANG = "${var.lang}"
    SUBMISSION_DUE_DATE = "${var.submission_due_date}"
    ACCEPTANCE_DUE_DATE = "${var.acceptance_due_date}"
    WEB_CONCURRENCY = "${var.web_concurrency}"
  }

  provisioner "local-exec" {
    command = "git remote add ${heroku_app.default.name} ${heroku_app.default.git_url}; git push ${heroku_app.default.name} master; heroku run rake db:setup"
  }
}

resource "heroku_addon" "database" {
  app = "${heroku_app.default.name}"
  plan = "heroku-postgresql:hobby-dev"
}

resource "heroku_addon" "elasticsearch" {
  app = "${heroku_app.default.name}"
  plan = "searchbox:starter"
}

resource "heroku_addon" "sendgrid" {
  app = "${heroku_app.default.name}"
  plan = "sendgrid:starter"
}

resource "heroku_addon" "deployhooks" {
  app = "${heroku_app.default.name}"
  plan = "deployhooks:email"
}
