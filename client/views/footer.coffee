Template.footer.helpers
  logoImgSrc: ->
    if Meteor.user()?.domain is 'stylight.com' or Session.equals("domainString", 'stylight-com')
      "/img/stylight-logo.png"
    else
      "/img/poweredby_it-agile.png"

  logoLink: ->
    if Meteor.user()?.domain is 'stylight.com' or Session.equals("domainString", 'stylight-com')
      "http://stylight.de"
    else
      "http://it-agile.de"