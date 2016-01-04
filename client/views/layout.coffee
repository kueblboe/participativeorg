Template.layout.onCreated ->
  template = this
  template.autorun ->
    template.subscribe 'coworkers'
    template.subscribe 'notifications'