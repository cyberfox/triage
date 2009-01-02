namespace :test do
  task :coverage do
    system("rcov test/**/*_test.rb -Itest/ -x '^(?!(app))' -x 'users_helper'")
  end
end
