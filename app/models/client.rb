class Client < ActiveRecord::Base

  attr_accessible :user_attributes ,:name, :company ,:phone, :user_attributes

  validates_presence_of :name, :company ,:phone

  belongs_to :user
  has_many :templates, :dependent => :destroy
  has_many :settings, :dependent => :destroy
  has_many :candidates, :dependent => :destroy
  has_many :exams, :dependent => :destroy
  has_many :instructions, :dependent => :destroy
  has_many :questions, :dependent => :destroy
  has_many :categories, :dependent => :destroy
  has_many :schedules, :dependent => :destroy

  accepts_nested_attributes_for :user
  after_create :create_settings
  after_create :create_templates

  def create_setting
    self.settings.create([
        {name: "time_limit_for_each_question", status: "off"},
        {name: "start_code", status: "12345"},
        {name: "js_mode", status: "off"},
        {name: "negative_mark", status: "off"},
        {name: "auto_result", status: "off"},
        {name: "load_more", status: "off"},
        {name: "can_start_exam", status: "10"},
        {name: "canot_start_exam", status: "10"},
        {name: "multiply_with", status: "0.9"}
    ])
  end

  def create_template
      self.templates.create([
          {name: "new schedule"},
          {name: "re schedule"},
          {name: "cancel schedule"},
          {name: "result passed"},
          {name: "result failed"},
          {name: "remote schedule"}
      ])
  end
end
