class MainController < ApplicationController

  def search
    @search_results = search_audiences
    render :home
  end

  private 

  def search_audiences 
    search_options = {
      query: params[:q],
      type: params[:en],
      items_per_page: 10,
      current_page: params[:pagina] || 0
    }
    search_options[:from] = parse_date(params[:desde]) if params[:desde]
    search_options[:to] = parse_date(params[:hasta]) if params[:hasta]

    audiences = Audience.public_search(search_options)

    search_results = search_options
    search_results[:audiences] = audiences.records.as_json({for_public: true})
    search_results[:total] = audiences.count
    
    search_results
  end

  def parse_date(date_string)
    Date.parse(date_string, "%d-%m-%Y").iso8601()
  end

end
