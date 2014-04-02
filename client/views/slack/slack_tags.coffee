Template.slackTags.helpers
  hashtagSymbol: ->
    if /#freizeit/.test(@description)
      'moon-o'
    else if /#vortrag/.test(@description)
      'bullhorn'
    else if /#ausland/.test(@description)
      'suitcase'

  highlightEffort: ->
    'highlight' if @effort > 16

  highlightCost: ->
    'highlight' if @cost > 500

  highlightRanking: ->
    'highlight' if @ranking > 4

  rankingList: ->
    [0...@ranking]

  rankingNegList: ->
    [0...(5 - @ranking)]