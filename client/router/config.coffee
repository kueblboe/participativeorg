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

  @route 'slackNew',
    path: '/slack/new',
    template: 'slackEdit'
    data: {date: new Date().toJSON().slice(0,10), category: 'other'}

  @route 'slack',
    waitOn: -> Meteor.subscribe("slack", Session.get('selectedUserId'), Session.get('selectedYear')) if Meteor.user()
    data: -> {year: Session.get('selectedYear')}

  @route 'slackPage',
    path: '/slack/:_id',
    waitOn: -> Meteor.subscribe("singleSlack", @params._id)
    data: -> Slack.findOne(@params._id)

  @route 'slackEdit',
    path: '/slack/:_id/edit',
    waitOn: -> Meteor.subscribe("singleSlack", @params._id)
    data: -> Slack.findOne(@params._id)

  @route 'slackCopy',
    path: '/slack/:_id/copy',
    template: 'slackEdit'
    waitOn: -> Meteor.subscribe("singleSlack", @params._id)
    data: -> _.extend(_.omit(Slack.findOne(@params._id), '_id'), {copyOf: @params._id})

  @route 'slackGoalNew',
    path: '/slack/goal/new',
    template: 'slackGoalEdit'

  @route 'slackGoalPage',
    path: '/slack/goal/:_id',
    waitOn: -> Meteor.subscribe("goal", @params._id)
    data: -> Goals.findOne(@params._id)

  @route 'slackGoalEdit',
    path: '/slack/goal/:_id/edit',
    waitOn: -> Meteor.subscribe("goal", @params._id)
    data: -> Goals.findOne(@params._id)

  @route 'feedback',
    waitOn: -> Meteor.subscribe("feedback", Session.get('selectedUserId'), Session.get('selectedYear')) if Meteor.user()
    data: -> {year: Session.get('selectedYear')}

  @route 'colleagues', {}

requireLogin = ->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @render "accessDenied", {to: 'status'}

Router.before requireLogin
Router.before clearErrors
Router.before -> Meteor.subscribe "coworkers"
Router.before -> Meteor.subscribe "notifications"

Router.load ->
  Session.set('selectedUserId', @params.userId || Session.get('selectedUserId') || Meteor.userId() || null)
  Session.set('selectedYear', parseInt(@params.year) || Session.get('selectedYear') || moment().year())

