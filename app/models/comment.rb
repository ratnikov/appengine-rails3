require 'thrust'

class Comment < Thrust::Datastore::Record
  property :text, :user

  validates_presence_of :text
end
