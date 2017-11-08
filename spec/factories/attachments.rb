FactoryBot.define do
  factory :attachment do
    attachable nil
    file { Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb") }
  end
end
