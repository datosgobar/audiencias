class MainController < ApplicationController

  def home
  end

  def search
    @search_results = search_audiences
    render :home
  end

  private 

  def search_audiences 
    search_options = {
      query: params[:q],
      type: params[:en]
    }

    search_options[:from] = parse_date(params[:desde]) if params[:desde]
    search_options[:to] = parse_date(params[:hasta]) if params[:hasta]

    search_results = Audience.public_search(search_options)
    page = (params[:pagina] || 1).to_i
    audiences = search_results.records.paginate(page: page)

    {
      audiences: audiences.as_json({for_public: true}),
      total: audiences.total_entries,
      total_pages: audiences.total_pages,
      per_page: Audience.per_page,
      aggregations: search_results.response['aggregations'].as_json
    }
  end

  def parse_date(date_string)
    Date.parse(date_string, "%d-%m-%Y").iso8601()
  end

end
