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

set :path, '/opt/enju_trunk'
set :environment, :production
set :output, "#{path}/log/cron_log.log"

every 5.minute do
  #runner "MessageRequest.send_messages"
end

every 1.day, :at => '0:00 am' do
  runner "Reserve.expire; Basket.expire; User.lock_expired_users"
end

every 1.day, :at => '0:10 am' do
  runner "KeywordCount.calc; Statistic.calc_sum"
end

every 1.day, :at => '1:00 am' do
  runner "UserCheckoutStat.calculate_stat; UserReserveStat.calculate_stat; ManifestationCheckoutStat.calculate_stat; ManifestationReserveStat.calculate_stat; BookmarkStat.calculate_stat"
  runner "AccessLog.calc_sum_yesterday"
end

every 1.day, :at => '2:00 am' do
  command "#{path}/script/tools/postgres_backup.sh"
end

every 1.day, :at => '2:10 am' do
  command "#{path}/script/tools/deletefile.sh /backup/db 14 \"*.custom\""
end

every 1.day, :at => '2:15 am' do
  command "#{path}/script/delayed_job stop ; sleep 2 ; #{path}/script/delayed_job start"
end

every 1.day, :at => '2:20 am' do
  #rake "enju_trunk:sync:scheduled_export"
end

every 1.day, :at => '2:30 am' do
  #command "#{path}/script/enjusync/imp-dumpfile.sh"
end

every 1.day, :at => '4:30 am' do
  #runner "Checkout.apend_to_reminder_list"
end

every '30 0 1 * *' do
  runner 'Statistic.calc_sum_prev_month'
end

every '0 4 1 * *' do
  runner 'NdlStatistic.calc_sum'
end

every '0 4 1 4 *' do
  runner 'NdlStatistic.calc_sum_prev_year'
end

every 1.hour do
  runner "ResourceImportTextfile.import"
##  runner "PatronImportFile.import; EventImportFile.import; ResourceImportTextfile.import"
##  runner "PatronImportFile.expire; EventImportFile.expire; ResourceImportTextfile.expire"
#  runner "ResourceImportTextfile.import; ResourceImportTextfile.expire"
end

#every 1.day, :at => '3:00 am' do
#  rake "sunspot:reindex"
#  rake "sitemap:refresh:no_ping"
#end

#every 1.day, :at => '5:00 am' do
#  runner "Checkout.send_due_date_notification; Checkout.send_overdue_notification; Checkout.apend_to_reminder_list"
  runner "PatronImportFile.stucked.destroy_all; EventImportFile.stucked.destroy_all; ResourceImportFile.stucked.destroy_all"
#end
