# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
  # Class method to filter users based on campaign names in their campaigns_list
  def self.with_campaigns(campaign_names)
    sanitized_campaigns = sanitize_sql_for_conditions(
      ['JSON_CONTAINS(campaigns_list, ?)', campaign_names.map { |name| { campaign_name: name } }.to_json]
    )

    where(sanitized_campaigns)
  end
end
