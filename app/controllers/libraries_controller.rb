class LibrariesController < ApplicationController
  def index
  	@libraries = Library.all

    @libraries.each do |library|
    PeasantsWorker.perform_async(library.id)
    end

	  	respond_to do |f|
        f.html
	  		f.json {render :json => {"libraries" => @libraries.as_json(except: :id)}}
	  	end
  end

  def new
    @library = Library.new
  end

  def create
    #sidekiq worker goes here
    new_library = Library.create(library_params)
    OrcsWorker.perform_async(new_library.id)
    redirect_to adventures_path

  end

  private

  def library_params
    params.require(:library).permit(:url)
  end

end
