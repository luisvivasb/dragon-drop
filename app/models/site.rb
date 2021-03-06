class Site < ActiveRecord::Base
	has_many :pages,
		class_name: :Page,
		primary_key: :identifier,
		foreign_key: :site_id,
		dependent: :destroy

	has_many :views, dependent: :destroy

	belongs_to :user

	amoeba do
		enable
  end

	validates :name, :user_id, presence: true
	validates :identifier, uniqueness: true
	after_initialize :ensure_identifier, :create_home

	def create_home
		p self
		self.pages.new(name: 'Home', path: '/') if self.pages.empty?
	end

	def ensure_identifier
		self.identifier ||= Site.generateUniqueIdentifier(name)
	end

	def self.nouns
		%w(camp vase fall motion grandmother cap observation rule insect size gate beginner lumber ducks hammer expansion sleet pen transport throat move pear rain desk pizzas suit bee magic word bulb tramp key box lake plant heat humor pleasure haircut swing surprise rod tub join jail look memory appliance screw afternoon ghost wall statement oil holiday wrist fork sleep morning bikes rake vein oven potato pump desire glass mom battle request finger bit tree grandfather force shape berry beef office star lace pies ink peace kick crime drop guitar partner head cats sort tendency zinc mailbox laugh aunt payment copper hook)
	end

	def self.adjs
		%w(pleasant idiotic nauseating freezing vagabond chivalrous hanging cautious futuristic needy stereotyped vulgar rigid female deafening infamous ratty hulking private weak aback same agonizing curvy erect callous lovely tense apathetic proud towering future graceful hard foolish impolite chubby equable disturbed utopian luxuriant red cute detailed omniscient savory grieving labored lazy hollow melodic messy watery grandiose rambunctious new fearless ruddy abaft wretched simplistic obnoxious frantic judicious finicky complete incredible obsequious dirty ordinary funny stale deranged cooperative joyous distinct drunk tremendous evanescent flagrant belligerent open ajar wooden absent festive unusual medical expensive harsh incandescent educated elderly faded dangerous royal rich crooked grumpy daily)
	end

	def self.generateUniqueIdentifier(name)
		if name
			identifier = name.downcase.gsub(/[^0-9a-z. ]/i, '').gsub(" ", "-").gsub(".", "-");
		else
			identifier = "#{adjs.sample}-#{nouns.sample}"
		end
		while (Site.find_by_identifier(identifier))
			identifier = "#{adjs.sample}-#{nouns.sample}"
		end
		identifier
	end

	def views_by_date
		View.where('site_id = ? AND created_at < ?', id, Time.now).group('date(created_at)').count
	end
end
