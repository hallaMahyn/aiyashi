class Admin::InquiriesController < Admin::BaseController
  include Pagy::Backend

  def index
    scope = Inquiry.recent.includes(:service)
    scope = scope.where(status: params[:status]) if params[:status].present? && Inquiry.statuses.key?(params[:status])
    @pagy, @inquiries = pagy(scope, limit: 25)

    @stats = {
      total:       Inquiry.count,
      new_inquiry: Inquiry.new_inquiry.count,
      in_progress: Inquiry.in_progress.count,
      completed:   Inquiry.completed.count
    }
  end

  def show
    @inquiry = Inquiry.find(params[:id])
  end

  def update_status
    @inquiry = Inquiry.find(params[:id])
    new_status = params[:status]
    if Inquiry.statuses.key?(new_status) && @inquiry.update(status: new_status)
      redirect_to admin_inquiry_path(@inquiry), notice: "Статус обновлён."
    else
      redirect_to admin_inquiry_path(@inquiry), alert: "Не удалось обновить статус."
    end
  end

  def new
    @inquiry = Inquiry.new
    @services = Service.active.ordered
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.save
      redirect_to admin_inquiry_path(@inquiry), notice: "Заявка добавлена."
    else
      @services = Service.active.ordered
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @inquiry = Inquiry.find(params[:id])
    if @inquiry.update(inquiry_params)
      redirect_to admin_inquiry_path(@inquiry), notice: "Заметка сохранена."
    else
      redirect_to admin_inquiry_path(@inquiry), alert: "Не удалось сохранить."
    end
  end

  def destroy
    @inquiry = Inquiry.find(params[:id])
    @inquiry.destroy
    redirect_to admin_inquiries_path, notice: "Заявка удалена."
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :phone, :email, :service_id, :message, :status, :note)
  end
end
