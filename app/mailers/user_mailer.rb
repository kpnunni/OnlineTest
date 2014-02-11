class UserMailer < ActionMailer::Base
  default from: "noreply@suyati.com"

  def welcome_email(user,pass)
    @user = user
    @pass=pass
    @url = "recruitment-suyati.herokuapp.com"
    mail(:to => user.user_email, :subject => "Welcome to Suyati online recruitment test Site")
  end
  def schedule_email(user)
    @user = user
    @templates = @user.client ? @user.client.templates : Templates.all
    if @user.candidate.schedule.remote
      @content=@templates.where(name: "remote schedule")
    else
      @content=@templates.where(name: "new schedule")
    end
    mail(:to => user.user_email, :subject => "Recruitment test")
  end
  def admin_schedule_email (admin,schedule)
    @user = admin
    @schedule= schedule
    mail(:to => admin.user_email, :subject => "New Schedule")
  end
  def update_schedule_email(user)
    @user = user
    @templates = @user.client ? @user.client.templates : Templates.all
    @content=@templates.where(name: "re schedule")
     mail(:to => user.user_email, :subject => "Update schedule")
  end
  def admin_update_schedule_email(user,schedule)
    @user = user
    @schedule= schedule
    @url = "recruitment-suyati.herokuapp.com"
    mail(:to => user.user_email, :subject => "Update schedule")
  end
  def cancel_schedule_email(user,schedule)
     @user = user
    @templates = @user.client ? @user.client.templates : Templates.all
    @content=@templates.where(name: "cancel schedule")
    @schedule= schedule
    @url = "recruitment-suyati.herokuapp.com"
    mail(:to => user.user_email, :subject => "Scheduled exam canceled")
  end
  def exam_complete_email(user,candidate)
    @user = user
    @candidate=candidate
    @url = "recruitment-suyati.herokuapp.com"
    mail(:to => user.user_email, :subject => "Result for validation")
  end
  def admin_result_email(user,result)
    @additional = Category.where("category = 'Additional'").first.questions.size
    @results = result
    @user = user
    mail(:to => user.user_email, :subject => "Test completed")
  end
  def admin_selected_result_email(user,result)
    @additional = Category.where("category = 'Additional'").first.questions.size
    @results = result
    @user = user
    mail(:to => user.user_email, :subject => "Mark Details")
  end
  def result_email(user)
    @user = user
    @templates = @user.client ? @user.client.templates : Templates.all
    @pass=@templates.where(name: "result passed")
    @fail=@templates.where(name: "result failed")
     @url = "recruitment-suyati.herokuapp.com"
    mail(:to => user.user_email, :subject => "Recruitment test result")
  end
  def sent_password(user,token)
    @user = user
    @url = "recruitment-suyati.herokuapp.com/sessions/#{token}/reset_pass"
    mail(:to => user.user_email, :subject => "Reset password")
  end

end