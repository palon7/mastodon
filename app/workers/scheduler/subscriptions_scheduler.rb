# frozen_string_literal: true
<<<<<<< HEAD
require 'sidekiq-scheduler'
=======

require 'sidekiq-scheduler'
require 'sidekiq-bulk'
>>>>>>> 1.4.7

class Scheduler::SubscriptionsScheduler
  include Sidekiq::Worker

  def perform
    logger.info 'Queueing PuSH re-subscriptions'

<<<<<<< HEAD
    expiring_accounts.pluck(:id).each do |id|
      Pubsubhubbub::SubscribeWorker.perform_async(id)
    end
=======
    Pubsubhubbub::SubscribeWorker.push_bulk(expiring_accounts.pluck(:id))
>>>>>>> 1.4.7
  end

  private

  def expiring_accounts
    Account.expiring(1.day.from_now).partitioned
  end
end
