require 'app/models/comment'
require 'spec_helper'

describe Comment do
  it "should allow saving comments" do
    comment = Comment.new :text => 'Hello world!'

    comment.save.should be_true

    Comment.all.any? { |comment| comment.text == "Hello world!" }.should be_true
  end
end
