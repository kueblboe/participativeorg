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

  pipeline = [
    {$match: selector},
    {$group: {_id: "$masterId", title: {$first: "$title"}, category: {$first: "$category"}, url: {$first: "$url"}, date: {$first: "$date"}, domain: {$first: "$domain"}, description: {$push: "$description"}, ranking: {$avg: "$ranking"}, rankings: {$push: "$ranking"}, effort: {$avg: "$effort"}, cost: {$avg: "$cost"}, copies: {$push: {userId: "$userId", userName: "$userName", slackId: "$_id"}}}}
  ]

  Slack.aggregate(pipeline)

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