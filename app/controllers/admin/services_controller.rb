class Admin::ServicesController < Admin::BaseController
  before_action :set_service, only: [:edit, :update, :destroy, :toggle_active]

  def index
    @services = Service.ordered
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(service_params)
    if @service.save
      redirect_to admin_services_path, notice: "Услуга добавлена."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @service.update(service_params)
      redirect_to admin_services_path, notice: "Услуга обновлена."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @service.destroy
    redirect_to admin_services_path, notice: "Услуга удалена."
  end

  def toggle_active
    @service.update!(active: !@service.active)
    redirect_to admin_services_path, notice: @service.active? ? "Услуга активирована." : "Услуга скрыта."
  end

  def reorder
    ids = params[:ids]
    ids.each_with_index do |id, index|
      Service.where(id: id).update_all(position: index)
    end
    head :ok
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :description, :category, :price_rub, :position, :active, :image)
  end
end
