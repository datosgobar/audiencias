class audiencias.views.SearchShortcuts extends Backbone.View
  className: 'shortcuts'
  template: JST["backbone/templates/search/shortcuts"]

  render: ->
    fakeData = [
      { name: 'Subsecretaría de asuntos globales', val: 187 },
      { name: 'Subsecretaría de asuntos institucionales', val: 134 },
      { name: 'Secretaría de coordinación de políticas públicas', val: 143 },
      { name: 'Subsecretaría de evaluación del presupuesto nacional', val: 110 },
      { name: 'Secretaría de comunicación pública', val: 79 },
      { name: 'Subsecretaría de comunicación pública', val: 68 },
      { name: 'Subsecretaría de comunicación y contenidos de difusión', val: 55 },
      { name: 'Subsecretaría de vínculo ciudadano', val: 44 },
      { name: 'Estado argentino en la nueva televisión del sur (telesur)', val: 42 },
      { name: 'Secretaría de coordinación interministerial', val: 12 },
    ]

    @$el.html(@template(
      dependencies: fakeData,
      obligees: fakeData,
      applicants: fakeData
    ))