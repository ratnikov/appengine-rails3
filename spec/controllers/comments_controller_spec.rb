require 'spec_helper'

describe CommentsController do
  context "#create" do
    setup { post :create, :comment => { :text => 'Hello world!' } }

    it "should create comment" do
      Comment.exists? :text => 'Hello world!'
    end

    it { response.should be_redirect }
  end
end
