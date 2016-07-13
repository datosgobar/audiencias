class MainController < ApplicationController

  def home
  end

  def audience
    @audience = Audience.find_by_id(params[:id])
    if @audience and @audience.published
      render :home
    else
      redirect_to '/404'  
    end
  end

  def search
    @search_results = search_audiences
    render :home
  end

  private 

  def search_audiences
    search_options = params.permit([
      'buscar-persona', 'buscar-pen', 'buscar-textos', 'buscar-representado', 
      'desde', 'hasta', 'q', 'pagina', 'interes-invocado', 'persona', 'pen',
      'organismo-estatal', 'grupo-de-personas', 'persona-juridica', 'historico'
    ])

    selected = {}
    if search_options.include?('persona')
      person = Person.find_by_id(search_options['persona'])
      selected['person'] = person.name if person
    end
    if search_options.include?('interes-invocado')
      selected['interest_invoked'] = search_options['interes-invocado'].titleize
    end
    if search_options.include?('pen')
      dependency = Dependency.find_by_id(search_options['pen'])
      selected['dependency'] = dependency.name if dependency
    end
    if search_options.include?('organismo-estatal')
      organism = StateOrganism.find_by_id(search_options['organismo-estatal'])
      selected['organism'] = organism.name if organism
    end
    if search_options.include?('grupo-de-personas')
      people_group = PeopleGroup.find_by_id(search_options['grupo-de-personas'])
      selected['group'] = people_group.name if people_group
    end
    if search_options.include?('persona-juridica')
      legal_entity = LegalEntity.find_by_id(search_options['persona-juridica'])
      selected['entity'] = legal_entity.name if legal_entity
    end

    audience_search_results = Audience.public_search(search_options)
    old_audience_search_results = OldAudience.public_search(search_options)

    page = (params[:pagina] || 1).to_i
    audience_paginated_results = audience_search_results.paginate(page: page)
    old_audience_paginated_results = old_audience_search_results.paginate(page: page)

    {
      audiences: { 
        records: audience_paginated_results.records.as_json({for_public: true}),
        total_pages: audience_paginated_results.total_pages,
        aggregations: audience_search_results.response['aggregations'].as_json,
        selected_values: selected,
        per_page: Audience.per_page,
        total: audience_paginated_results.records.total
      },
      old_audiences: {
        records: old_audience_paginated_results.records.as_json({for_public: true}),
        total_pages: old_audience_paginated_results.total_pages,
        total: old_audience_paginated_results.records.total
      },
      total: audience_paginated_results.records.total + old_audience_paginated_results.records.total,
      current_page: page,
      options: search_options
    }
  end

end
