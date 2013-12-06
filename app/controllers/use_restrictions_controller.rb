class UseRestrictionsController < InheritedResources::Base
  respond_to :html, :json
  before_filter :check_client_ip_address
  load_and_authorize_resource

  def update
    @use_restriction = UseRestriction.find(params[:id])
    if params[:move]
      move_position(@use_restriction, params[:move])
      return
    end
    update!
  end
end
