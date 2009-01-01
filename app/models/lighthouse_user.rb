class LighthouseUser < ActiveRecord::Base
  def self.update_frequency
    7.days.ago
  end

  def self.get(current_user, lh_id)
    user = cached_user = find_by_lighthouse_id(lh_id)
    if cached_user.nil? || cached_user.updated_at < update_frequency
      Lighthouse.account = current_user.subdomain
      user = Lighthouse::User.find(lh_id)
    end

    if cached_user.nil?
      if user
        cached_user = LighthouseUser.create(:name => user.name,
                              :lighthouse_id => user.id,
                              :website => user.website,
                              :job => user.job)
      end
    else
      cached_user.update_attributes(:name => user.name,
                                    :lighthouse_id => user.id,
                                    :website => user.website,
                                    :job => user.job)
    end

    return cached_user
  end
end
