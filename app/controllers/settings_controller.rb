class SettingsController < ApplicationController
  before_filter :chk_role
  def edit
     @setting = Setting.new
     @settings = client.settings
     @multiply_with = get_status('multiply_with')
     @start_code = get_status('start_code')
     @load_more = get_status('load_more')
     @negative_mark = get_status('negative_mark')
     @auto_result = get_status('auto_result')
     @from = get_status('can_start_exam')
     @untill = get_status('canot_start_exam')
     @each_mode = get_status('time_limit_for_each_question')
     @js_mode = get_status('js_mode')
     @categories = client.categories.all
     @cut_off = (0..100).to_a.select {|v| v%5==0 }
  end
  def update
    @js_mode = client.settings.find_by_name('js_mode')
    @multiply_with = client.settings.find_by_name('multiply_with')
    @start_code = client.settings.find_by_name('start_code')
    @load_more=client.settings.find_by_name('load_more')
    @negative_mark=client.settings.find_by_name('negative_mark')
    @auto_result=client.settings.find_by_name('auto_result')
    @from=client.settings.find_by_name('can_start_exam')
    @untill=client.settings.find_by_name('canot_start_exam')
    @each_mode=client.settings.find_by_name('time_limit_for_each_question')
    if params[:js_mode]=="1"
       @js_mode.update_attribute(:status,:on)
    else
       @js_mode.update_attribute(:status,:off)
    end
    if params[:negative]=="1"
       @negative_mark.update_attribute(:status,:on)
    else
       @negative_mark.update_attribute(:status,:off)
    end
    @auto_result.set_cutoff(params[:categories_attributes])
    if params[:auto_result]=="1"
      @auto_result.update_attribute(:status,:on)
    else
      @auto_result.update_attribute(:status,:off)
    end
    if params[:load_more]=="1"
      @load_more.update_attribute(:status,:on)
    else
      @load_more.update_attribute(:status,:off)
    end
    if params[:each_mode]=="1" && @each_mode.status == "off"
      @each_mode.update_attribute(:status,:on)
      increase_total_time
    elsif params[:each_mode].nil? && @each_mode.status == "on"
      @each_mode.update_attribute(:status,:off)
      reduce_total_time
    end
    @from.update_attribute(:status,params[:from].to_i)
    @untill.update_attribute(:status,params[:untill].to_i)
    @multiply_with.update_attribute(:status,params[:multiply_with].to_f)
    @start_code.update_attribute(:status,params[:start_code])
      redirect_to '/settings/edit' ,:notice => "Settings updated"
  end
  def chk_role
    unless admin? || my_roles.include?("Client")
       redirect_to root_path
    end
  end
  def reduce_total_time
    multiply = client.settings.find_by_name('multiply_with').status.to_f
    Exam.all.each do |exam|
      current_time = exam.total_time
      new_time = current_time * multiply
      exam.update_attribute(:total_time, new_time)
    end
  end

  def increase_total_time
    Exam.all.each do |exam|
      new_time = exam.questions.collect {|v| v.allowed_time}.sum
      exam.update_attribute(:total_time, new_time)
    end
  end
  def get_status(name)
    @settings.select { |s| s.name == name }.map(&:status).join
  end
end
