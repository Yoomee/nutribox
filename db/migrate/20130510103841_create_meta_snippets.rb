class CreateMetaSnippets < ActiveRecord::Migration
  def up
    %w{gift home join my_subscriptions}.each do |page|
      YmSnippets::Snippet.create(:slug => "meta_#{page}_page_title", :text => YmSnippets::Snippet.find_by_slug("#{page}_page_title").text)
      YmSnippets::Snippet.create(:slug => "meta_#{page}_page_description", :text => YmSnippets::Snippet.find_by_slug("#{page}_page_description").text)
      YmSnippets::Snippet.create(:slug => "meta_#{page}_page_keywords", :text => 'healthy snacks delivered, gluten free, nutribox, energy snacks, endurance sport nutrition, paleo, pre and post training nutrition, triathlon nutrition, marathon nutrition')
    end
    YmSnippets::Snippet.create(:slug => 'meta_box_page_keywords', :text => 'healthy snacks delivered, gluten free, nutribox, energy snacks, endurance sport nutrition, paleo, pre and post training nutrition, triathlon nutrition, marathon nutrition')

    %w{gift home join my_subscriptions}.each do |page|
      YmSnippets::Snippet.find_by_slug("#{page}_page_title").destroy
      YmSnippets::Snippet.find_by_slug("#{page}_page_description").destroy
    end
  end

  def down
    %w{gift home join my_subscriptions}.each do |page|
      YmSnippets::Snippet.create(:slug => "#{page}_page_title", :text => YmSnippets::Snippet.find_by_slug("meta_#{page}_page_title").text)
      YmSnippets::Snippet.create(:slug => "#{page}_page_description", :text => YmSnippets::Snippet.find_by_slug("meta_#{page}_page_description").text)
    end


    YmSnippets::Snippet.find_by_slug('meta_box_page_keywords').destroy
    %w{gift home join my_subscriptions}.each do |page|
      YmSnippets::Snippet.find_by_slug("meta_#{page}_page_title").destroy
      YmSnippets::Snippet.find_by_slug("meta_#{page}_page_description").destroy
      YmSnippets::Snippet.find_by_slug("meta_#{page}_page_keywords").destroy
    end
  end
end
