require "test_helper"

module Charts
  class DailyStatisticTest < ActiveSupport::TestCase
    test "daily statistic job should enqueue critical queue" do
      assert_difference -> { Charts::DailyStatistic.jobs.size }, 1 do
        Charts::DailyStatistic.perform_async
      end
      assert_equal "critical", Charts::DailyStatistic.queue
    end
  end
end
