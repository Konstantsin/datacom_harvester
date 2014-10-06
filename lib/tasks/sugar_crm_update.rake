namespace :sugar_crm do
  desc "Updates first 10 accounts from SugarCrm"
  task update: :environment do
    SugarCrm::UpdaterDataCom.update
  end
end
