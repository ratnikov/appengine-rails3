require 'app/models/comment'
require 'spec_helper'

require 'thrust/development'

describe Comment do
  before do
    Thrust::Development::ServerEnvironment.new.delegate!
  end

  it "should allow saving comments" do
    comment = Comment.new :text => 'Hello world!'

    Thrust::Development::Environment.new.set_for_current_thread do 
      comment.save.should be_true

      (comments = Comment.all).any? { |comment| comment.attribute?(:text) && comment.text == "Hello world!" }.should be_true, "Expected #{comments.inspect} to have good stuff"
    end
  end
end
