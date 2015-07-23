buildRegExp = (searchText) ->
  words = searchText.trim().split(/[ \-\:]+/)
  exps = _.map(words, (word) -> '(?=.*' + word + ')')
  fullExp = exps.join('') + '.+'
  new RegExp(fullExp, 'i')

SearchSource.defineSource 'slack', (searchText, options = {}) ->
  options = _.defaults options,
    sort: date: -1
    limit: 20

  selector = {domain: Meteor.user().domain}
  if options.sort.ranking
    selector = {$and: [{ranking: {$gte: 0}}, selector]}

  if options.filter
    selector = {$and: [{category: options.filter}, selector]}

  if searchText
    regExp = buildRegExp(searchText)
    selector = {$and: [
      selector,
      {$or: [
        {title: regExp},
        {description: regExp},
        {userName: regExp}
      ]}
    ]}

  Slack.find(selector, options).fetch()
