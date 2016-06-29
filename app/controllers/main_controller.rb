class MainController < ApplicationController

  def search
    unless params[:q] and params[:q].length > 0
      redirect_to root_path
      return 
    end
    
    @audiences = search_audiences
    render :home
  end

  private 

  def search_audiences 
    # todo: incluir tipo de busqueda, si incluye historico y/o rango de fecha
    {
      query: params[:q],
      items_per_page: 10,
      current_page: params[:pagina] || 0,
      audiences: Audience.public_search(params[:q]).records.as_json({for_public: true})
    }
  end

end
