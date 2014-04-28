class LogsController < ApplicationController
  LOGS_PER_PAGE = 25

  def index
    @logs = logs_list.paginate(page: params[:page], per_page: LOGS_PER_PAGE)
  end

  def show
  end

  private

  def logs_list
    Dir[File.join(SugarCrm::UpdateLog::LOGS_PATH, "*#{SugarCrm::UpdateLog::LOGS_FORMAT}")].sort
  end
end