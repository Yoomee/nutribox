class GenerateReferralCodesForExistingUsers < ActiveRecord::Migration
  def up
    User.all.each do |user|
      user.send(:generate_referral_code)
    end
  end

  def down
  end
end
