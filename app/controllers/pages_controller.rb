class PagesController < ApplicationController
  def home
    @featured_services = Service.active.ordered.limit(6)
    @inquiry = Inquiry.new
    @services = Service.active.ordered
  end

  def about
  end

  def services
    @services_by_category = Service.active.ordered.group_by(&:category)
    @selected_category = params[:category]
    if @selected_category.present? && Service::CATEGORIES.include?(@selected_category)
      @services_by_category = @services_by_category.slice(@selected_category)
    end
  end

  def contacts
    @inquiry = Inquiry.new
    @services = Service.active.ordered
  end
end
