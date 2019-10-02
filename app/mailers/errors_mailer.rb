class ErrorsMailer < ActionMailer::Base
  default from: 'from@example.com'

  def captcha
    mail(to: 'egor.yavorsky@altoros.com', subject: 'DataCom-SugarCRM update: enter the right captcha')
  end
end
