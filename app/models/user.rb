class User
  include ActiveModel::Model
  include ActiveModel::Attributes

  @@users ||= []

  validates :first_name, :last_name, presence: true
  validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, if: Proc.new { |user| user.email.present? }
  validate :unique?
  
  FIELDS = %i[first_name last_name email gov_id_number gov_id_type]

  FIELDS.each do |field|
    attribute field, :string, default: ''
  end

  class << self
    def all
      @@users
    end
  end

  def save
    return false unless valid?

    @@users << self
    self.attributes
  end

  def attributes
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      gov_id_type: gov_id_type,
      gov_id_number: gov_id_number
    }
  end

  def unique?
    duplicates = User.all.select do |user|
      user.first_name == first_name &&
      user.last_name == last_name &&
      user.email == email &&
      user.gov_id_number == gov_id_number &&
      user.gov_id_type == gov_id_type
    end
    return unless duplicates.any?

    errors.add :not_unique, "Record is not unique"
  end
end
