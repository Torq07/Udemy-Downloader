class ApplicationController < ActionController::Base
	before_action :set_udemy_account
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  def call_rake(task, options = {})
    options[:rails_env] ||= Rails.env
    args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
    system "rake #{task} #{args.join(' ')} --trace 2>&1 >> #{Rails.root}/log/rake.log &"
  end
  protect_from_forgery with: :exception

  def set_udemy_account
    @udemy_account = UdemyAccount.find_by(user_id:current_user)
  end

end
