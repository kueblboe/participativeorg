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
    waitOn: -> Meteor.subscribe("singleSlack", this.params._id)
    data: -> Slack.findOne(this.params._id)

  @route 'slackEdit',
    path: '/slack/:_id/edit',
    waitOn: -> Meteor.subscribe("singleSlack", this.params._id)
    data: -> Slack.findOne(this.params._id)

  @route 'slackCopy',
    path: '/slack/:_id/copy',
    template: 'slackEdit'
    waitOn: -> Meteor.subscribe("singleSlack", this.params._id)
    data: -> _.extend(_.omit(Slack.findOne(this.params._id), '_id'), {copyOf: this.params._id})

  @route 'slackGoalNew',
    path: '/slack/goal/new',
    template: 'slackGoalEdit'

  @route 'slackGoalEdit',
    path: '/slack/goal/:_id/edit',
    waitOn: -> Meteor.subscribe("goal", this.params._id)
    data: -> Goals.findOne(this.params._id)

requireLogin = ->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @render "accessDenied", {to: 'status'}

Router.before requireLogin
Router.before clearErrors
Router.before -> Meteor.subscribe "coworkers", Meteor.userId()

Router.load ->
  Session.set('selectedUserId', this.params.userId || Session.get('selectedUserId') || Meteor.userId() || null)
  Session.set('selectedYear', parseInt(this.params.year) || Session.get('selectedYear') || moment().year())

