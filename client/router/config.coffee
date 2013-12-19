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

  @route 'slack',
    waitOn: -> Meteor.subscribe "slack", Session.get('selectedUser')._id if Meteor.user()

  @route 'slackNew',
    path: '/slack/new',
    template: 'slackEdit'
    data: {date: new Date().toJSON().slice(0,10), category: 'other'}

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
      @render "accessDenied", {to: 'status'}

Router.before requireLogin

Router.before -> clearErrors()

