class TemplatesController < ApplicationController
    before_filter :chk_user
   def show
     @template = client.templates.where(name: params[:id]).first
   end
  def update
    @template=Template.find(params[:id])
    if @template.update_attributes(params[:template])
       redirect_to template_path(@template.name) ,:notice => "Saved changes"
    else
       render action: "show"
     end
  end

    def chk_user
    if !any_role?('Client', 'Manage Templates')
      redirect_to '/homes/index'
    end

    end

end
