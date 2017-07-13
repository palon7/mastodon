# frozen_string_literal: true

class SubscribeService < BaseService
  def call(account)
    account.secret = SecureRandom.hex

    subscription = account.subscription(api_subscription_url(account.id))
    response     = subscription.subscribe

    if response_failed_permanently?(response)
<<<<<<< HEAD
      # An error in the 4xx range (except for 429, which is rate limiting)
      # means we're not allowed to subscribe. Fail and move on
      account.secret = ''
      account.save!
    elsif response_successful?(response)
      # Anything in the 2xx range means the subscription will be confirmed
      # asynchronously, we've done what we needed to do
      account.save!
    else
      # What's left is the 5xx range and 429, which means we need to retry
      # at a later time. Fail loudly!
=======
      # We're not allowed to subscribe. Fail and move on.
      account.secret = ''
      account.save!
    elsif response_successful?(response)
      # The subscription will be confirmed asynchronously.
      account.save!
    else
      # The response was either a 429 rate limit, or a 5xx error.
      # We need to retry at a later time. Fail loudly!
>>>>>>> 1.4.7
      raise "Subscription attempt failed for #{account.acct} (#{account.hub_url}): HTTP #{response.code}"
    end
  end

  private

<<<<<<< HEAD
  def response_failed_permanently?(response)
    response.code > 299 && response.code < 500 && response.code != 429
  end

  def response_successful?(response)
    response.code > 199 && response.code < 300
=======
  # Any response in the 3xx or 4xx range, except for 429 (rate limit)
  def response_failed_permanently?(response)
    (response.status.redirect? || response.status.client_error?) && !response.status.too_many_requests?
  end

  # Any response in the 2xx range
  def response_successful?(response)
    response.status.success?
>>>>>>> 1.4.7
  end
end
