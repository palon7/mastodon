# frozen_string_literal: true

class Api::SalmonController < Api::BaseController
  before_action :set_account
  respond_to :txt

  def update
<<<<<<< HEAD
    payload = request.body.read

    if !payload.nil? && verify?(payload)
      SalmonWorker.perform_async(@account.id, payload.force_encoding('UTF-8'))
=======
    if verify_payload?
      process_salmon
>>>>>>> 1.4.7
      head 201
    else
      head 202
    end
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

<<<<<<< HEAD
  def verify?(payload)
    VerifySalmonService.new.call(payload)
=======
  def payload
    @_payload ||= request.body.read
  end

  def verify_payload?
    payload.present? && VerifySalmonService.new.call(payload)
  end

  def process_salmon
    SalmonWorker.perform_async(@account.id, payload.force_encoding('UTF-8'))
>>>>>>> 1.4.7
  end
end
