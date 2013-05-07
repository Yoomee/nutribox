class AddPageTitleAndDescriptionSnippets < ActiveRecord::Migration

  def up
    YmSnippets::Snippet.create(slug: 'gift_page_title', text: 'Give The Nutribox As A Gift')
    YmSnippets::Snippet.create(slug: 'gift_page_description', text: 'You can now give the Nutribox as a gift! Get 25% off your first box and treat your loved ones to deliciously healthy snacks!')
    YmSnippets::Snippet.create(slug: 'join_page_title', text: 'Sign Up To The Nutribox')
    YmSnippets::Snippet.create(slug: 'join_page_description', text: 'Sign up to the Nutribox and receive your very own supply of deliciously healthy snacks every month. Get 25% off your first box!')
    YmSnippets::Snippet.create(slug: 'my_subscriptions_page_title', text: 'Sign Up To The Nutribox')
    YmSnippets::Snippet.create(slug: 'my_subscriptions_page_description', text: 'Sign up to the Nutribox and receive your very own supply of deliciously healthy snacks every month. Get 25% off your first box!')
  end

  def down
    YmSnippets::Snippet.find_by_slug('gift_page_title').destroy
    YmSnippets::Snippet.find_by_slug('gift_page_description').destroy
    YmSnippets::Snippet.find_by_slug('join_page_title').destroy
    YmSnippets::Snippet.find_by_slug('join_page_description').destroy
    YmSnippets::Snippet.find_by_slug('my_subscriptions_page_title').destroy
    YmSnippets::Snippet.find_by_slug('my_subscriptions_page_description').destroy
  end

end
