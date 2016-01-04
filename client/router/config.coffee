Router.configure
  layoutTemplate: 'layout'
  notFoundTemplate: '404'
  loadingTemplate: 'loading'
  yieldRegions:
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
    path: '/pd/new',
    template: 'slackEdit'
    data: {date: new Date().toJSON().slice(0,10), category: 'other'}

  @route 'slack',
    path: '/pd',
    template: 'slackOverview'

  @route 'slackUser',
    path: 'pd/user/:userId/:year',
    template: 'slack',
    waitOn: -> Meteor.subscribe("slack", Session.get('selectedUserId'), Session.get('selectedYear')) if Meteor.user()
    data: -> Meteor.users.findOne(Session.get('selectedUserId'))

  @route 'slackPage',
    path: '/pd/:_id',
    waitOn: -> Meteor.subscribe("singleSlack", @params._id)
    data: -> Slack.findOne(@params._id)

  @route 'slackEdit',
    path: '/pd/:_id/edit',
    waitOn: -> Meteor.subscribe("singleSlack", @params._id)
    data: -> Slack.findOne(@params._id)

  @route 'slackCopy',
    path: '/pd/:_id/copy',
    template: 'slackEdit'
    waitOn: -> Meteor.subscribe("singleSlack", @params._id)
    data: -> _.extend(_.omit(Slack.findOne(@params._id), '_id'), {copyOf: @params._id})

  @route 'slackGoalNew',
    path: '/pd/goal/new',
    template: 'slackGoalEdit'

  @route 'slackGoalPage',
    path: '/pd/goal/:_id',
    waitOn: -> Meteor.subscribe("goal", @params._id)
    data: -> Goals.findOne(@params._id)

  @route 'slackGoalEdit',
    path: '/pd/goal/:_id/edit',
    waitOn: -> Meteor.subscribe("goal", @params._id)
    data: -> Goals.findOne(@params._id)

  @route 'feedback',
    waitOn: -> Meteor.subscribe("feedback", Session.get('selectedUserId'), Session.get('selectedYear')) if Meteor.user()
    data: -> {year: Session.get('selectedYear')}

  @route 'satisfaction',
    waitOn: -> Meteor.subscribe("satisfaction", Session.get('selectedMonth')) if Meteor.user()
    data: -> {month: Session.get('selectedMonth')}

  @route 'colleagues',
    waitOn: -> ColleagueSearch.search Session.get('colleagueSearchTerm'), {sort: Session.get('colleagueSort')}

  @route 'profile',
    data: -> Meteor.user()

requireLogin = ->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @render "header", {to: 'header'}
      @render "accessDenied", {to: 'status'}
      @render "footer", {to: 'footer'}
      @render "/login"
  else
    @next()

Router.onBeforeAction(requireLogin, {except: ['home', 'login', 'register', 'recovery', 'verifyEmail']})

Router.onBeforeAction ->
  clearErrors
  @next()

Router.onRun ->
  Session.set('selectedUserId', @params.userId || Session.get('selectedUserId') || Meteor.userId() || null)
  Session.set('selectedYear', parseInt(@params.year) || Session.get('selectedYear') || moment().year())
  Session.set('selectedMonth', parseInt(@params.month) || Session.get('selectedMonth') || month())
  Session.set('domainString', @params.query.domain) if @params.query.domain
  @next()
