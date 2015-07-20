buildRegExp = (searchText) ->
  words = searchText.trim().split(/[ \-\:]+/)
  exps = _.map(words, (word) -> '(?=.*' + word + ')')
  fullExp = exps.join('') + '.+'
  new RegExp(fullExp, 'i')

SearchSource.defineSource 'slack', (searchText, options) ->
  options =
    sort: date: -1
    limit: 20
  if searchText
    regExp = buildRegExp(searchText)
    selector = {$and: [
      {domain: Meteor.user().domain},
      {$or: [
        {title: regExp},
        {description: regExp}
      ]}
    ]}
    Slack.find(selector, options).fetch()
  else
    Slack.find({domain: Meteor.user().domain}, options).fetch()