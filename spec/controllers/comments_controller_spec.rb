require 'spec_helper'

describe CommentsController do
  context "POST /create" do
    context "while logged in" do
      before do
        login_as 'joe@example.com'

        post :create, :comment => { :text => 'Hello world!' }
      end

      it "should create comment" do
        Comment.exists? :text => 'Hello world!'
      end

      it "should remember the user who created it" do
        Comment.all(:text => 'Hello world!').first.user.email.should == 'joe@example.com'
      end

      it { response.should be_redirect }
    end

    it "should require being logged in" do
      logout

      post :create, :comment => { :text => 'Hello world!' }

      response.should redirect_to(controller.login_url(controller.url_for))
    end
  end

  def login_as(email, options = nil)
    admin = options && options[:admin] == true

    Thrust::Development.environment.current_email = email
    Thrust::Development.environment.admin = admin
  end

  def logout
    Thrust::Development.environment.reset!
  end
end
