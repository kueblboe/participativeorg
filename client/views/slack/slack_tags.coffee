Template.slackTags.helpers
  hashtagSymbol: ->
    if /#freizeit/.test(this.description)
      'moon-o'
    else if /#vortrag/.test(this.description)
      'bullhorn'
    else if /#ausland/.test(this.description)
      'suitcase'

  highlightEffort: ->
    'highlight' if this.effort > 16

  highlightCost: ->
    'highlight' if this.cost > 500

  highlightRanking: ->
    'highlight' if this.ranking > 4