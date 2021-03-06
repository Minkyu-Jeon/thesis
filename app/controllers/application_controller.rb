class ApplicationController < ActionController::API
  rescue_from ApplicationError, with: :handle_error

  protected

  def require_params!(*args)
    args.any? { |param_key| params[param_key.to_sym].blank? } and raise ParameterRequiredError.new(args)
  end

  private

  def handle_error(e)
    case e
    when InvalidParameterError
      render json: e.errors.reverse_merge(code: e.class::CODE), status: :bad_request
    when ParameterRequiredError
      render json: { code: e.class::CODE, message: e.message }, status: :bad_request
    end
  end
end
