# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :job_template, "sh -l -c ':job'"
env :PATH, ENV['PATH']
set :output, 'log/cron.log'

# 每个小时调用一次 rake check_event_registrations
# every 2.minutes do
#   runner "User.test_cron"
# end



# 数据库备份
every 1.day, at: '4:30 am' do
  command "cd /myapp && ./backup.rb"
end