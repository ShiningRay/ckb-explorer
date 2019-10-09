require "test_helper"

class DaoEventTest < ActiveSupport::TestCase
  should validate_presence_of(:value)
  should validate_numericality_of(:value).
    is_greater_than_or_equal_to(0)

  test "should have correct columns" do
    dao_event = create(:dao_event)
    expected_attributes = %w(address_id block_id contract_id created_at event_type id status transaction_id updated_at value)
    assert_equal expected_attributes, dao_event.attributes.keys.sort
  end
end
