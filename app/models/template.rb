class Template < ActiveRecord::Base
   attr_accessible :name, :body
   belongs_to :client

end
