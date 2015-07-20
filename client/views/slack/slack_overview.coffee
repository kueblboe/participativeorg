SlackSearch = new SearchSource('slack', ['title', 'description'], {keepHistory: 1000 * 60 * 5, localSearch: true})

Template.slackOverview.helpers
  hasSlackEvents: ->
    SlackSearch.getData().length > 0

  slackEvents: ->
    SlackSearch.getData
      transform: (matchText, regExp) ->
        matchText.replace regExp, '<u>$&</u>'
      sort: date: -1

  isLoading: ->
    SlackSearch.getStatus().loading

Template.slackOverview.rendered = ->
  SlackSearch.search ''
  return

Template.slackOverview.events 'keyup #search-box': _.throttle(((e) ->
  text = $(e.target).val().trim()
  SlackSearch.search text
), 200)