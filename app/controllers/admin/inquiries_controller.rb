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

  def destroy
    @inquiry = Inquiry.find(params[:id])
    @inquiry.destroy
    redirect_to admin_inquiries_path, notice: "Заявка удалена."
  end
end
