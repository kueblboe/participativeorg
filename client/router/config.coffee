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

AccountController = RouteController.extend(
  verifyEmail: ->
    Accounts.verifyEmail @params.token, ->
      Router.go "/colleagues"
)

Router.map ->
  @route 'home',
    path: '/'

  @route 'login'
  @route 'register'

  @route "verifyEmail",
    controller: AccountController
    path: "/verify-email/:token"
    action: "verifyEmail"

  @route 'recovery',
    path: '/recovery/:token?',
    data: -> {token: if @params then @params.token else ''}

  @route 'slackNew',
    path: '/slack/new',
    template: 'slackEdit'
    data: {date: new Date().toJSON().slice(0,10), category: 'other'}

  @route 'slack',
    template: 'slackOverview'

  @route 'slackUser',
    path: 'slack/user/:userId/:year',
    template: 'slack',
    waitOn: -> Meteor.subscribe("slack", Session.get('selectedUserId'), Session.get('selectedYear')) if Meteor.user()
    data: -> Meteor.users.findOne(Session.get('selectedUserId'))

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

  @route 'satisfaction',
    waitOn: -> Meteor.subscribe("satisfaction", Session.get('selectedMonth')) if Meteor.user()
    data: -> {month: Session.get('selectedMonth')}

  @route 'colleagues', {}

  @route 'profile',
    data: -> Meteor.user()

requireLogin = ->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else if this.path in ["/login", "/register", "/recovery"]
      # don't show login alert if on login page
    else
      @render "accessDenied", {to: 'status'}

Router.onBeforeAction ->
  requireLogin
  @next()

Router.onBeforeAction ->
  clearErrors
  @next()

Router.onBeforeAction ->
  Meteor.subscribe "coworkers"
  @next()

Router.onBeforeAction ->
  Meteor.subscribe "notifications"
  @next()

Router.onRun ->
  Session.set('selectedUserId', @params.userId || Session.get('selectedUserId') || Meteor.userId() || null)
  Session.set('selectedYear', parseInt(@params.year) || Session.get('selectedYear') || moment().year())
  Session.set('selectedMonth', parseInt(@params.month) || Session.get('selectedMonth') || month())
  @next()
