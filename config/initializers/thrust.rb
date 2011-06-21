require 'thrust'

Thrust.configure do |c|
  c.logging = Rails.env.production? ? :java : :rails
end
