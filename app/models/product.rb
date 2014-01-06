class Product < ActiveRecord::Base
	validates_presence_of :title, :description, :image_url, :price
	validates_numericality_of :price, :greater_than_or_equal_to => 0.01
	validates_format_of :image_url, :with => %r{\.(png|jpg|jpeg)\z}i, :message => " must be extended with PNG|JPG|JPEG formats"
	validates_uniqueness_of :title

	default_scope :order => 'title'
	has_many :orders, :through => :line_items
	has_many :line_items
    before_destroy :ensure_not_referenced_by_any_line_item

    def ensure_not_referenced_by_any_line_item
		if line_items.count.zero?
			return true
		else
			errors.add(:base, 'Line Items present' )
			return false
		end
	end
	def who_bought
		@product = Product.find(params[:id])
		respond_to do |format|
			format.atom
			format.xml { render :xml => @product }
		end
	end
end
