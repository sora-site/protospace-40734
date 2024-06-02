class PrototypesController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :move_to_index, only: [:edit, :update]

  def index
    @prototypes = Prototype.all
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to '/'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @prototype = Prototype.new
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])

    unless user_signed_in?
      redirect_to root_path
    end

    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

    private
    
    def prototype_params
      params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
    end

    def move_to_index
      id = Prototype.find(params[:id]).user_id
      unless current_user.id == id
        redirect_to action: :index
      end
    end

end
