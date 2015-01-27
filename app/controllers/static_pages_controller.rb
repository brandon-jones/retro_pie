class StaticPagesController < ApplicationController
    before_action :authenticate, only: :manage
    
  def index
    @title = "Play all the games!"
  end

  def manage
    @title = "Overview of Site"
  end

  def contact_me
    if params["commit"] && params["commit"] == 'Send Question'
      ContactMeMailer.contact_me_send_mail(params['name'],params['email'],params['body'],).deliver
      redirect_to root_path, notice: 'Thanks for reaching out to me. I will get back to you ASAP!'
    end
  end

end