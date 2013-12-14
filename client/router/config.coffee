Router.configure
  layoutTemplate: 'layout'
  notFoundTemplate: '404'
  loadingTemplate: 'loading'
  yieldTemplates:
    header:
      to: 'header'
    errors:
      to: 'errors'
    footer:
      to: 'footer'

Router.map ->
  @route 'home',
    path: '/'

  @route 'slack'

  @route 'slackNew',
    path: '/slack/new',
    template: 'slackEdit'
    data: {date: new Date().toJSON().slice(0,10)}

  @route 'slackPage',
    path: '/slack/:_id',
    data: -> Slack.findOne(this.params._id)

  @route 'slackEdit',
    path: '/slack/:_id/edit',
    data: -> Slack.findOne(this.params._id)

requireLogin = ->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @render "accessDenied"
    @stop()

Router.before requireLogin,
  only: "slackNew"

Router.before -> clearErrors()

