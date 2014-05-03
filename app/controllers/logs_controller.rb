class LogsController < ApplicationController
  LOGS_PER_PAGE = 25

  def index
    @logs = SugarCrm::UpdateLog.list.paginate(page: params[:page], per_page: LOGS_PER_PAGE)
  end

  def show
  end
end