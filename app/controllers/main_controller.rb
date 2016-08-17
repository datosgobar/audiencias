class MainController < ApplicationController

  def home
    @aggregations = Audience.shortcut_aggregations({
      dependency_size: 50,
      obligee_size: 50,
      applicant_size: 50
    }).as_json
  end

  def audience
    @audience = Audience.find_by_id(params[:id])
    if @audience and @audience.published
      @aggregations = Audience.shortcut_aggregations({
        dependency_size: 50,
        obligee_size: 50,
        applicant_size: 50
      }).as_json
      render :home
    else
      redirect_to '/404'  
    end
  end

  def audience_historic
    @audience = OldAudience.where(id_audiencia: params[:id]).first
    if @audience
      @aggregations = Audience.shortcut_aggregations({
        dependency_size: 50,
        obligee_size: 50,
        applicant_size: 50
      }).as_json
      render :home
    else
      redirect_to '/404'  
    end
  end

  def search
    @search_results = do_search
    render :home
  end

  def download
    filename = Pathname.new(request.path).basename.to_s
    @search_options, @selected = collect_search_options

    if filename[0..20] == 'audiencias_historicas'
      search_results = OldAudience.public_search(@search_options)
      records = search_results.paginate(page: 1, per_page: OldAudience.count).records
    else
      search_results = Audience.public_search(@search_options)
      records = search_results.paginate(page: 1, per_page: Audience.count).records
    end

    respond_to do |format|
      format.csv { send_data generate_csv(records) , filename: filename }
      format.json { send_data generate_json(records) , filename: filename }
      format.xlsx { send_data generate_xlsx(records) , filename: filename }
    end
  end

  def dependencies
    @aggregations = Audience.shortcut_aggregations({
      dependency_size: Dependency.count,
      obligee_size: 0,
      applicant_size: 0
    }).as_json
    @dependencies = Dependency.all.as_json(for_public: true)
    render :shortcuts
  end

  def obligees
    @aggregations = Audience.shortcut_aggregations({
      dependency_size: 0,
      obligee_size: 150,
      applicant_size: 0
    }).as_json  
    render :shortcuts
  end

  def applicants
    @aggregations = Audience.shortcut_aggregations({
      dependency_size: 0,
      obligee_size: 0,
      applicant_size: 150
    }).as_json    
    render :shortcuts
  end


  private 

  def do_search
    page = (params[:pagina] || 1).to_i
    @search_options, @selected = collect_search_options

    audience_search_results = Audience.public_search(@search_options)
    audience_paginated_results = audience_search_results.paginate(page: page)
    audience_json = audience_paginated_results.records.as_json({for_public: true})
    audience_total_pages = audience_paginated_results.total_pages
    audience_aggregations = audience_search_results.response['aggregations'].as_json
    audience_total = audience_paginated_results.records.total

    if selected_facet
      old_audience_json = []
      old_audience_total_pages = 0
      old_audience_total = 0
    else
      old_audience_paginated_results = OldAudience.public_search(@search_options).paginate(page: page)
      old_audience_json = old_audience_paginated_results.records.as_json({for_public: true})
      old_audience_total_pages = old_audience_paginated_results.total_pages
      old_audience_total = old_audience_paginated_results.records.total
    end

    {
      audiences: {
        records: audience_json,
        total_pages: audience_total_pages,
        total: audience_total,
        aggregations: audience_aggregations,
        selected_values: @selected,
        per_page: Audience.per_page,
      },
      old_audiences: {
        records: old_audience_json,
        total_pages: old_audience_total_pages,
        total: old_audience_total,
        per_page: OldAudience.per_page
      },
      current_page: page,
      options: @search_options,
      total: audience_total + old_audience_total
    }
  end

  def generate_csv(audiences)
    require 'csv'
    CSV.generate(headers: true) do |csv|
      attributes = if audiences.length > 1 then audiences.first.class.table_headers else [] end
      csv << attributes
      audiences.each do |audience|
        csv << audience.as_csv
      end
    end
  end

  def generate_json(audiences)
    audiences_json = audiences.as_json(for_public: true)
    audiences_json = audiences.first.class.prepare_json_for_download(audiences_json)
    JSON.pretty_generate(audiences_json)
  end

  def generate_xlsx(audiences)
    xlsx_package = Axlsx::Package.new
    xlsx_package.use_shared_strings = true
    workbook = xlsx_package.workbook
    workbook.add_worksheet(:name => "audiencias") do |sheet|
      if audiences.length > 1 
        attributes = audiences.first.class.table_headers
        types = audiences.first.class.table_types
        sheet.add_row(attributes)
      end
      audiences.each do |audience|
        sheet.add_row(audience.as_csv, types: types)
      end
    end
    xlsx_package.to_stream.read
  end

  def collect_search_options
    search_options = params.permit([
      'buscar-persona', 'buscar-pen', 'buscar-textos', 'buscar-representado', 
      'desde', 'hasta', 'q', 'pagina', 'interes-invocado', 'persona', 'pen',
      'organismo-estatal', 'grupo-de-personas', 'persona-juridica', 'historico',
      'roles-persona'
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

    [search_options, selected]
  end

  def selected_facet
    ['person', 'interest_invoked', 'dependency', 'organism', 'group', 'entity'].any? { |param| @selected.include?(param) }
  end

end
