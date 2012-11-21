class AddSummaryToPages < ActiveRecord::Migration
  def change
    add_column :pages, :summary, :text, :after => :text
  end
end
