@SlackSearch = new SearchSource('slack', ['title', 'description'], {keepHistory: 1000 * 60 * 5, localSearch: true})

setOrToggleSortOrder = (sortBy, groupId, labelId) ->
  if Session.equals('slackSortBy', sortBy)
    Session.set('slackSortOrder', -Session.get('slackSortOrder'))
  else
    Session.set('slackSortBy', sortBy)
  highlightLabel(groupId, labelId)

setFilter = (filterBy, groupId, labelId) ->
  if Session.equals('slackFilterBy', filterBy)
    Session.set('slackFilterBy', undefined)
    removeHighlightLabel(groupId)
  else
    Session.set('slackFilterBy', filterBy)
    highlightLabel(groupId, labelId)

removeHighlightLabel = (groupId) ->
  $("#{groupId} a").removeClass('label-primary')

highlightLabel = (groupId, labelId) ->
  removeHighlightLabel(groupId)
  $("#{labelId}").addClass('label-primary')

Tracker.autorun ->
  sort = {}
  sort[Session.get('slackSortBy')] = Session.get('slackSortOrder')
  Session.set('slackSort', sort)

Tracker.autorun ->
  SlackSearch.search Session.get('slackSearchTerm'), {sort: Session.get('slackSort'), filter: Session.get('slackFilterBy')}

Template.slackOverview.helpers
  hasSlackEvents: ->
    SlackSearch.getData().length > 0

  slackEvents: ->
    SlackSearch.getData
      transform: (matchText, regExp) ->
        matchText.replace regExp, '<span class="search-text">$&</span>'
      sort: Session.get('slackSort')

  isLoading: ->
    SlackSearch.getStatus().loading

  sortAsc: ->
    Session.get('slackSortOrder') > 0

  sortDesc: ->
    Session.get('slackSortOrder') < 0

Template.slackOverview.rendered = ->
  Session.set('slackSearchTerm', '')
  Session.setDefault('slackSortBy', 'date')
  Session.setDefault('slackSortOrder', -1)
  highlightLabel('#sort', "#sort-#{Session.get('slackSortBy')}")

Template.slackOverview.events
  'keyup #search-box': _.throttle(((e) ->
    text = $(e.target).val().trim()
    Session.set('slackSearchTerm', text)
  ), 200)

  'click #sort-asc': (e) ->
    e.preventDefault()
    Session.set('slackSortOrder', -1)

  'click #sort-desc': (e) ->
    e.preventDefault()
    Session.set('slackSortOrder', 1)

  'click #sort-date': (e) ->
    e.preventDefault()
    setOrToggleSortOrder('date', '#sort', '#sort-date')

  'click #sort-cost': (e) ->
    e.preventDefault()
    setOrToggleSortOrder('cost', '#sort', '#sort-cost')

  'click #sort-effort': (e) ->
    e.preventDefault()
    setOrToggleSortOrder('effort', '#sort', '#sort-effort')

  'click #sort-ranking': (e) ->
    e.preventDefault()
    setOrToggleSortOrder('ranking', '#sort', '#sort-ranking')

  'click #filter-attend': (e) ->
    e.preventDefault()
    setFilter('attend', '#filter', '#filter-attend')

  'click #filter-read': (e) ->
    e.preventDefault()
    setFilter('read', '#filter', '#filter-read')

  'click #filter-other': (e) ->
    e.preventDefault()
    setFilter('other', '#filter', '#filter-other')
