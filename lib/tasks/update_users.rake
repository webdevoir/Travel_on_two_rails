namespace :users do
  desc "Adds Verify true to all existing users"

  task :add_created_and_updated => :environment do
    User.all.each do |t|
      if t.created_at == nil
        t.update_attribute :created_at, Time.now
        t.update_attribute :updated_at, Time.now
      end
    end
  end

end
