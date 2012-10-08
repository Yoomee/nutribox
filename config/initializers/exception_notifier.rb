unless (Rails.env.development? || Rails.env.test?)
  Nutribox::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[NUTRIBOX] ",
    :sender_address => "notifier <notifier@nutribox.yoomee.com>",
    :exception_recipients => %w{developers@yoomee.com}
end