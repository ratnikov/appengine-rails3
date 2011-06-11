require 'app/models/comment'
require 'spec_helper'

require 'thrust/development'

describe Comment do
  it "should allow saving comments" do
    comment = Comment.new :text => 'Hello world!'

    comment.save.should be_true

    (comments = Comment.all).any? { |comment| comment.attribute?(:text) && comment.text == "Hello world!" }.should be_true, "Expected #{comments.inspect} to have good stuff"
  end
end
