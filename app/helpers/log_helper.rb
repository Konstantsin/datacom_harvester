module LogHelper

  def name_for(log)
    log.gsub(SugarCrm::UpdateLog::LOGS_PATH, "").gsub(SugarCrm::UpdateLog::LOGS_FORMAT, "").gsub("/", "")
  end

  def current_log_file_path
    File.join(SugarCrm::UpdateLog::LOGS_PATH, "#{params[:id]}#{SugarCrm::UpdateLog::LOGS_FORMAT}")
  end
end