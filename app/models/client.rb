class Client < ActiveRecord::Base

  attr_accessible :user_attributes ,:name, :company ,:phone, :user_attributes

  validates_presence_of :name, :company ,:phone

  belongs_to :user
  has_one :template, :dependent => :destroy
  has_one :setting, :dependent => :destroy
  has_many :candidates, :dependent => :destroy
  has_many :exams, :dependent => :destroy
  has_many :instructions, :dependent => :destroy
  has_many :questions, :dependent => :destroy
  has_many :categories, :dependent => :destroy

  accepts_nested_attributes_for :user
end
