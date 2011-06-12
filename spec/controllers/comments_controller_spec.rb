require 'spec_helper'

describe CommentsController do
  context "#create" do
    context "while logged in" do
      before do
        Thrust::Development.environment.current_email = 'joe@example.com'

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
      Thrust::Development.environment.logged_in?.should be_false

      post :create, :comment => { :text => 'Hello world!' }

      response.should redirect_to(controller.login_url(controller.url_for))
    end
  end
end
