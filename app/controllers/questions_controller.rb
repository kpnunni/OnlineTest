class QuestionsController < ApplicationController
  #layout false ,:only => :show
  before_filter :chk_user
  def chk_user
    if !any_role?('Client','Add Questions Only','Manage Questions','Add Questions')
      redirect_to '/homes/index'
    end
  end
  def index
    if client?
      @questions= Question.filtered(params[:search],client).paginate(:page => params[:page], :per_page =>params[:per_page] || 15)
    else
      @questions= Question.filtered(params[:search],nil).paginate(:page => params[:page], :per_page =>params[:per_page] || 15)
    end
    if all_role?('Add Questions', 'Manage Questions')
      @questions.select! {|q| q.created_by==current_user.user_email}
    elsif all_role?('Add Questions Only', 'Manage Questions', 'Add Questions')
      @questions.select! {|q| q.created_at>=(Time.now-1.minutes)&&q.created_by==current_user.user_email }
    end
    @complexity=Complexity.first(3)
    @category = client.categories
    @types=Type.all
    @users=client.questions.select("created_by").uniq
  end

  def show
    @question = client.questions.find(params[:id])
    @options = @question.options

    if my_roles.include?('Add Questions') && !any_role?('Client','Manage Questions')
      redirect_to questions_path if @question.created_by != current_user.user_email
    end

  end
  def new
    @question = Question.new
    4.times{ @question.options.build }
    @complexity=Complexity.first(3)
    @categorys=client.categories
    @types=Type.all
  end
  def edit
    @question =  client.questions.find(params[:id])
    @opt=@question.options.all
    @complexity=Complexity.first(3)
    @categorys=client.categories
    @types=Type.all
  end
  def create
    @question = Question.new(params[:question])
    @question.created_by =current_user.user_email
    @question.answer_id=""
    @question.type_id=""
    @complexity=Complexity.first(3)
    @categorys=client.categories
    @types=Type.all
    @question.client = client
    if @question.save
      redirect_to questions_path , notice: 'Question was successfully created.'
    else
      render action: "new"
    end
  end
  def update
    @question =  client.questions.find(params[:id])
    params[:question][:updated_by]=current_user.user_email
    @complexity=Complexity.first(3)
    @categorys=client.categories
    @types=Type.all
    @opt=@question.options.all
    flag=0
    params[:question]['options_attributes'].each {|k,v| flag=1 if v['is_right']=='1'}
    if params[:question][:question]==""&&params[:question][:question_image].nil?
      flash.now[:error]="Question or image should not be blank"
      render action: "edit"
      return
    end
    if flag==0
      flash.now[:error]="atleast one option should be true"
      render action: "new"
      return
    end
    if @question.update_attributes(params[:question])
      @question.options.first.save
      redirect_to questions_path , notice: 'Question was successfully updated.'
    else
      @complexity=Complexity.all
      @category=client.categories
      @types=Type.all
      @opt=@question.options.all
      render action: "edit"
    end
  end
  def destroy
    @question =  client.questions.find(params[:id])
    @question.destroy
    redirect_to questions_url, notice: 'Question was successfully deleted.'
  end
  def multiple
    if params[:commit] == "Delete selected"
      flag=0
      nothing_to_delete=1
      if !params[:question].nil?
        params[:question][:ids].each do |q|
          @question= client.questions.find(q.to_i)
          flag=1 if !@question.exams.empty?
          @question.delete
          nothing_to_delete=0
        end
      end
      if flag==1
        flash[:warning]="some questions are part of question paper.So you cant delete."
      elsif nothing_to_delete==1
        flash[:error]="Nothing to delete"
      else
        flash[:notice]="Question's' deleted successfully"
      end
    elsif params[:commit] == "Update all"    #edit all
      time = params[:new_allowed_time].to_i
      if time > 0 and time <= 200
        client.questions.update_all({allowed_time: time},{ id:  params[:question][:ids]})
        flash[:notice]="Question's' updated successfully"
      else
        flash[:error]="Invalid allowed time"
      end
    else  #to print
       if params[:question] && !params[:question][:ids].empty?
         @questions =   client.questions.where(id: params[:question][:ids]).reverse
         render print_questions_questions_path(:format => 'pdf')
         return
       else
         flash[:error]="Nothing to print"
       end
    end
    redirect_to questions_path
  end
  def print_questions
  end
  def delete_image
    @question= client.questions.find(params[:id])
    @question.question_image.clear
    @question.save(validate: false)
    redirect_to edit_question_path(@question)
  end
end
