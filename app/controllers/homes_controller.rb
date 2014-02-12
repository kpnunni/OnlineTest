class HomesController < ApplicationController
  attr_accessor  :mail,:pass
  before_filter  :chk_admin ,:only => :admin
  #before_filter  :chk_user ,:only => :index
  skip_before_filter :authenticate,:only => :default_page
  def index
  end
  def admin

    @schedules1=clinet.schedules.where("sh_date between ? and ?",Date.today ,Date.tomorrow  ).reverse_order
    @schedules7=clinet.schedules.where("sh_date between ? and ?",Date.today.beginning_of_week,Date.today.end_of_week).reverse_order
    @schedules30=clinet.schedules.where("sh_date between ? and ?",Date.today.beginning_of_month,Date.today.end_of_month).reverse_order

    @results1 =RecruitmentTest.includes([:candidate]).where("completed_on between ? and ? and candidates.client_id = ?",Date.today ,Date.tomorrow ,client.id ).reverse_order
    @results7 =RecruitmentTest.includes([:candidate]).where("completed_on between ? and ? and candidates.client_id = ?",Date.today.beginning_of_week,Date.today.end_of_week,client.id ).reverse_order
    @results30 =RecruitmentTest.includes([:candidate]).where("completed_on between ? and ? and candidates.client_id = ?",Date.today.beginning_of_month,Date.today.end_of_month,client.id ).reverse_order

    @questions= client.questions.includes([:options,:category,:complexity,:type]).last(10).reverse
    @candidates=RecruitmentTest.includes([:candidate]).where("is_passed = 'Passed' and candidates.client_id = ?",client.id ).last(10).reverse

  end

  def chk_admin
    unless admin? || client?
      redirect_to  '/homes/index'
    end
  end
  def chk_user
    if my_roles.include?("Candidate")
      redirect_to  '/homes/default_page'
    end
  end
  def default_page

  end
end
