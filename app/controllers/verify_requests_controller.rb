class VerifyRequestsController < ApplicationController
  def new; end

  def create
    qr_code_base64 = CreatePresentationRequestService.call

    redirect_to verify_requests_result_path(qr: qr_code_base64)
  end

  def result
    @qr_code_base64 = params[:qr]
  end
end
