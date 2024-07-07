# frozen_string_literal: true

class User < ApplicationRecord

  # Scope to filter users based on campaign names in their campaigns_list
  scope :with_campaigns, ->(campaign_names) {
    query = campaign_names.map { |name|
      "JSON_SEARCH(campaigns_list, 'all', '#{name}', NULL, '$[*].campaign_name')"
    }.join(' OR ')

    where(query)
  }
end
