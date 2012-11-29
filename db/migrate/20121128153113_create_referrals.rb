class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.belongs_to :referrer
      t.belongs_to :referree
      t.timestamps
    end
    add_index :referrals, :referrer_id
    
    add_column :users, :referral_code, :string
    User.reset_column_information
    User.all.each do |user|
      user.send(:generate_referral_code)
      user.save
    end
  end
end
