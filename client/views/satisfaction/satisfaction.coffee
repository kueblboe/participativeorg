Template.satisfaction.helpers
  satisfactionEvents: ->
    Satisfaction.find({month: @month})