class Sample < ActiveRecord::Base

  belongs_to :organism
  belongs_to :user
  belongs_to :organization
  
  has_many :y_chromosome_seqs
  has_many :y_chromosomes
  has_many :microsatellite_horizontals
  has_many :microsatellites
  has_many :mt_dnas
  has_many :mt_dna_seqs
  has_many :mhcs
  has_many :mhc_seqs
  has_many :genders
  has_many :dna_results
  
  accepts_nested_attributes_for :genders
  accepts_nested_attributes_for :dna_results
  accepts_nested_attributes_for :mt_dnas
  
  before_save :assign_collected_YMD
  
  file_column :sample_image1

# done in contoller now  
#  after_create :send_sample_mail
#  def send_sample_mail
#    if Rails.env.production?
#      Emailer.deliver_submission("lindarutledge@icloud.com, mharnden@nrdpfc.ca, info@nrdpfc.ca, james@burrett.org", "New Sample Submitted", self.submitted_by, self.project_id, self.field_code,self.date_submitted,self.shipping_date ) 
#    else
#      Emailer.deliver_submission("drburrett@gmail.com", "New TEST Sample Submitted", self.submitted_by, self.project_id, self.field_code,self.date_submitted,self.shipping_date ) 
#    end
#  end


  def assign_collected_YMD

    if self.collected_on_day.blank? or self.collected_on_month.blank? or self.collected_on_year.blank?
      self.date_collected = nil
    else
      self.date_collected = DateTime.strptime(self.collected_on_year + "/" + self.collected_on_month + "/" + self.collected_on_day, "%Y/%m/%d" )
    end
  end

  
end
