Template.slackTags.helpers
  hashtagSymbol: ->
    if /#freizeit/.test(@description)
      'moon-o'
    else if /#vortrag/.test(@description)
      'bullhorn'
    else if /#ausland/.test(@description)
      'suitcase'

  effort: ->
    Math.round @effort

  cost: ->
    Math.round @cost

  highlightEffort: ->
    'highlight' if @effort > 16

  highlightCost: ->
    'highlight' if @cost > 500