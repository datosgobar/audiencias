class MainController < ApplicationController

  def home
  end

  def search
    @search_results = search_audiences
    render :home
  end

  private 

  def search_audiences 
    search_options = params.permit([
      'buscar-historico', 'buscar-persona', 'buscar-pen', 
      'buscar-textos', 'buscar-representado', 'desde', 
      'hasta', 'q', 'pagina', 'interes-invocado'
    ])

    page = (params[:pagina] || 1).to_i
    search_results = Audience.public_search(search_options)
    paginated_results = search_results.paginate(page: page)

    {
      audiences: paginated_results.records.as_json({for_public: true}),
      total: paginated_results.records.total,
      total_pages: paginated_results.total_pages,
      current_page: page,
      per_page: Audience.per_page,
      aggregations: search_results.response['aggregations'].as_json,
      options: search_options
    }
  end

end
