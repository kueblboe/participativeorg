buildRegExp = (searchText) ->
  words = searchText.trim().split(/[ \-\:]+/)
  exps = _.map(words, (word) -> '(?=.*' + word + ')')
  fullExp = exps.join('') + '.+'
  new RegExp(fullExp, 'i')

SearchSource.defineSource 'slack', (searchText, options = {}) ->
  domain = Meteor.user()?.domain
  return null unless domain
  options = _.defaults options,
    domain: domain
    sort: date: -1
    limit: 20

  selector = {domain: domain}
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

SearchSource.defineSource 'colleagues', (searchText, options = {}) ->
  domain = Meteor.user()?.domain
  return null unless domain
  options = _.defaults options,
    domain: domain
    sort: {'profile.firstname': 1, 'profile.lastname': 1}
    limit: 500

  selector = {domain: domain}

  if searchText
    regExp = buildRegExp(searchText)
    selector = {$and: [
      selector,
      {$or: [
        {'profile.firstname': regExp},
        {'profile.lastname': regExp}
      ]}
    ]}

  Meteor.users.find(selector, options).fetch()