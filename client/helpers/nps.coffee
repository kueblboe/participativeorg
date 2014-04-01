@npsCategory = (score) ->
  if score > 8
    'promote'
  else if score < 7
    'detract'
  else
    'indifferent'