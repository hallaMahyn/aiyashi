class InquiriesController < ApplicationController
  def new
    @inquiry = Inquiry.new
    @services = Service.active.ordered
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.save
      redirect_to root_path, notice: "Ваша заявка принята! Мы свяжемся с вами в ближайшее время."
    else
      @services = Service.active.ordered
      render :new, status: :unprocessable_entity
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :phone, :email, :service_id, :message)
  end
end
