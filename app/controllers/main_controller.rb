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

    search = {
      query: params[:q],
      type: params[:en],
      items_per_page: 10,
      current_page: params[:pagina] || 0
    }
    search[:from] = params[:desde] if params[:desde]
    search[:to] = params[:hasta] if params[:hasta]

    audiences = Audience.public_search(search[:query])
    search[:audiences] = audiences.records.as_json({for_public: true})

    search
  end

end
