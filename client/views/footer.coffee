Template.footer.helpers
  logoImgSrc: ->
    if Meteor.user()?.domain is 'stylight.com'
      "/img/stylight-logo.png"
    else
      "/img/poweredby_it-agile.png"

  logoLink: ->
    if Meteor.user()?.domain is 'stylight.com'
      "http://stylight.de"
    else
      "http://it-agile.de"